//
//  TopicsViewController.swift
//  EnglishForBeginners
//
//  Created by Vladimir on 28.02.18.
//  Copyright © 2018 Omega-R. All rights reserved.
//

import UIKit
import ORCommonUI_Swift
import ORCommonCode_Swift

import AVFoundation
import AVKit
import Reachability

class TopicsViewController: BaseVC, UICollectionViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ThemeExamCVCellDelegate {
    
    @IBOutlet weak var topicsPageControl: UIPageControl!
    @IBOutlet weak var topicsCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var labelThemeName: UILabel!
    @IBOutlet weak var buttonBuy: ORRoundRectButton!
    
    var topicsCountWithExam: Int {
        return topics.count == 0 ? 0 : topics.count + 1
    }

    var isOpened: Bool = false {
        didSet {
            buttonBuy.isHidden = isOpened
        }
    }
    
    var theme: Theme!
    var topics = [Topic]()
    var productInfo: ProductInfo?

    var activityIndicator: UIActivityIndicatorView?
    var stars: Int = 0
    var experience: Int = 0
    var topic: Topic?
    lazy var playerViewController: AVPlayerViewController = {
        let playerViewController = AVPlayerViewController()
        playerViewController.showsPlaybackControls = true
        return playerViewController
    }()
    var currentMovieNumber = "1"
    let myNextButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)


    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareCollectionView()
        prepareBuyButton()
        
        prepareNotifications()
        updateView()
        
        AnalyticsHelper.logEventWithParameters(event: .ME_Theme_Opened, themeId: theme.name!, topicId: nil, typeOfLesson: nil, starsCount: nil, language: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        topicsCollectionView.reloadData()
    }
    
    deinit {
        or_removeObserver(self, name: Notifications.iApProductsFetched)
        or_removeObserver(self, name: Notifications.iApProductPurchased)
    }
    
    // MARK: -
    
    private func prepareBuyButton() {
        buttonBuy.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonBuy.titleLabel?.numberOfLines = 1
        buttonBuy.titleLabel?.lineBreakMode = .byClipping
        
        buttonBuy.alpha = 1.0
        buttonBuy.isUserInteractionEnabled = true
        
        if let priceWithCurrency = productInfo?.priceWithCurrency {
            buttonBuy.setTitle("buy-theme".localizedWithCurrentLanguage() + " \(priceWithCurrency)", for: .normal)
        } else {
            buttonBuy.setTitle("main-buy-button".localizedWithCurrentLanguage(), for: .normal)
            buttonBuy.alpha = 0.8
            buttonBuy.isUserInteractionEnabled = false
        }
    }
    
    private func prepareNotifications() {
        or_addObserver(self, selector: #selector(productsWasFetched(_:)), name: Notifications.iApProductsFetched)
        or_addObserver(self, selector: #selector(productWasPurchased(_:)), name: Notifications.iApProductPurchased)
    }

    func prepareCollectionView() {
        
        topicsCollectionView.allowsSelection = false
        automaticallyAdjustsScrollViewInsets = false
        
        topicsCollectionView.or_registerCellNib(forClass: TopicsCVCell.self)
        topicsCollectionView.or_registerCellNib(forClass: ThemeExamCVCell.self)
    }
    
    func updateView() {
        labelThemeName.text = theme.nativeWord?.word
        topics = theme.convertedTopics
        isOpened = theme.opened
        topicsCollectionView.reloadData()
    }
    
    // MARK: - Notifications
    
    @objc func productsWasFetched(_ notification: NSNotification) {
        guard let productsInfo = notification.userInfo?[Constants.purchasesInfo] as? [ProductInfo] else {
            return
        }
        
        self.productInfo = productsInfo.filter({ (productInfo) -> Bool in
            return productInfo.themeName == theme.name
        }).first
        
        DispatchQueue.main.async {
            self.prepareBuyButton()
        }
        
        
    }
    
    @objc func productWasPurchased(_ notification: NSNotification) {
        defer {
            hideActivityIndicator()
        }
        
        guard let productsInfo = notification.userInfo?[Constants.purchasesInfo] as? [ProductInfo], let status = notification.userInfo?[Constants.purchaseStatus] as? IAPHandlerAlertType else {
            return
        }
        
        if status == .disabled || status == .error || status == .failed {
            or_showAlert(title: "Purchases", message: status.message())
            return
        }
        
        let isCurrentThemePurchased = !productsInfo.filter { (productInfo) -> Bool in
            return productInfo.themeName == theme.name
        }.isEmpty
        
        if isCurrentThemePurchased, let themeName = theme.name {
            ThemeManager.buyThemes([themeName]) { [weak self] in
                guard let sself = self else {
                    return
                }
                
                sself.updateView()
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func close(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buyButtonPressed(_ sender: Any) {
        guard let themeName = theme.name else {
            return
        }
        
        showActivityIndicator()
        
        IAPHandler.shared.purchaseTheme(with: themeName)
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        topicsPageControl.numberOfPages = topicsCountWithExam
        return topicsCountWithExam
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isTopicCell = indexPath.row < topics.count
        
        if isTopicCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TopicsCVCell.self),
                                                          for: indexPath) as! TopicsCVCell
            
            let topic = topics[indexPath.row]
            
            if let imageName = topic.imageName {
                cell.photoView.image = UIImage(named: imageName)
            }
            
            cell.updateTopicName(topic.nativeWord?.word ?? topic.name!)
            cell.changeState(isOpened)

            cell.delegate = self
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ThemeExamCVCell.self),
                                                          for: indexPath) as! ThemeExamCVCell
            cell.labelExamName.text = String(format: "some-theme-quiz".localizedWithCurrentLanguage(), theme.nativeWord?.word ?? theme.name!)            
            var examStatus: ThemeExamCVCell.ExamState = .notPurchased

            if let theme = theme, isOpened {
                let starType = ThemeManager.starType(of: theme)                
                examStatus = theme.passed ? .passAgain : (starType == .gold ? .opened : .locked)
            }
            
            cell.updateProgress(theme?.starsCount ?? 0)
            
            cell.changeState(examStatus)
            cell.delegate = self
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isTopicCell = indexPath.row < topics.count
        if isTopicCell, let cell = cell as? TopicsCVCell {
            cell.stars = topics[indexPath.row].starsSet
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let thisWidth = CGFloat(UIScreen.main.bounds.width)
        
        return CGSize(width: thisWidth, height: UIScreen.main.bounds.height)
    }

    // MARK: - ThemeExamCVCellDelegate
    func examButtonPressed() {
        let examVC = VCEnum.levels.vc as! LevelsVC
        examVC.lessonType = nil
        examVC.theme = theme
        
        navigationController?.pushViewController(examVC, animated: true)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        topicsPageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        topicsPageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

// MARK: - TopicsCVCellDelegate
extension TopicsViewController: TopicsCVCellDelegate {
    func dictionaryPressed(topicsCVCell: TopicsCVCell) {
        guard let index = topicsCollectionView.indexPath(for: topicsCVCell)?.row, index < topics.count else {
            return
        }

        let selectedTopic = topics[index]

        let dictionaryVC = VCEnum.dictionary.vc as! DictionaryVC
        dictionaryVC.itemsIds = selectedTopic.wordsIds
        dictionaryVC.themeName = theme.name!

        AnalyticsHelper.logEventWithParameters(event: .ME_Dictionary_Opened, themeId: theme.name!, topicId: topics[index].name!, typeOfLesson: nil, starsCount: nil, language: nil)

        navigationController?.pushViewController(dictionaryVC, animated: true)
    }

    func lessonPressed(topicsCVCell: TopicsCVCell, lessonType: LessonType) {
        guard let index = topicsCollectionView.indexPath(for: topicsCVCell)?.row, index < topics.count else {
            return
        }
        let selectedTopic = topics[index]
        let lessonVC = VCEnum.levels.vc as! LevelsVC
        lessonVC.lessonType = lessonType
        lessonVC.topic = selectedTopic
        navigationController?.pushViewController(lessonVC, animated: true)
    }

    func moviesPressed(topicsCVCell: TopicsCVCell) {
        let url = MotivationalVideoManager.shared.getMovies(for: currentMovieNumber)
        prepareVideoPlayer(videoURL: url)
    }
}

extension TopicsViewController {
    private func addButtonsOnVideoPlayer() {
        addNextButton()
        addCloseButton()
    }
    private func addNextButton() {
        myNextButton.setTitle("Next", for: .normal)
        myNextButton.setTitleColor(UIColor.white, for: .normal)
        myNextButton.backgroundColor = UIColor(0, 174, 239)
        myNextButton.addTarget(self, action: #selector(playNextVideo), for: .touchUpInside)
        myNextButton.layer.cornerRadius = 20
        view.addSubview(myNextButton)
        myNextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myNextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: +60),
            myNextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            myNextButton.widthAnchor.constraint(equalToConstant: 100),
            myNextButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        myNextButton.bringSubviewToFront(playerViewController.view)
        myNextButton.alpha = 0
    }
    private func addCloseButton() {
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(UIColor.white, for: .normal)
        closeButton.backgroundColor = UIColor(0, 174, 239)
        closeButton.addTarget(self, action: #selector(closeVideo), for: .touchUpInside)
        closeButton.layer.cornerRadius = 20
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -60),
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        closeButton.bringSubviewToFront(playerViewController.view)
        closeButton.alpha = 0
    }

    @objc func closeVideo() {
        removePlayer()
    }

    @objc func playNextVideo() {
        var value = currentMovieNumber.toInt()
        myNextButton.setTitle("Next", for: .normal)
        if value > 0, value < 3 {
            value += 1
            currentMovieNumber = "\(value)"
        } else {
            if value == 3, myNextButton.titleLabel?.text != "Repeat" {
                currentMovieNumber = "\(value)"
                myNextButton.setTitle("Repeat", for: .normal)
            } else {
                value = 1
                currentMovieNumber = "\(value)"
            }
        }
        let url = MotivationalVideoManager.shared.getMovies(for: currentMovieNumber)
        playerViewController.player?.pause()
        playVideo(with: url)
    }

    private func prepareVideoPlayer(videoURL: URL) {
        if activityIndicator == nil {
            if #available(iOS 13.0, *) {
                activityIndicator = UIActivityIndicatorView(style: .large)
            } else {
                activityIndicator = UIActivityIndicatorView(style: .gray)
            }
                activityIndicator?.center = view.center
                activityIndicator?.hidesWhenStopped = true
                if let indicator = activityIndicator {
                    playerViewController.view.addSubview(indicator)
                }
            }

        activityIndicator?.startAnimating()
        guard
            let reachability = try? Reachability(),
            [.cellular, .wifi].contains(reachability.connection)
        else {
            activityIndicator?.stopAnimating()
            return
        }

        addChild(playerViewController)
        playerViewController.view.frame = view.frame
        view.addSubview(playerViewController.view)
        playerViewController.view.alpha = 0
        addButtonsOnVideoPlayer()
        playVideo(with: videoURL)
    }

    private func playVideo(with url: URL) {
        let player = AVPlayer(url: url)
        player.volume = 5
        playerViewController.player = player
        UIView.animate(withDuration: 0.5, delay: 0, options: []) { [weak self] in
            self?.playerViewController.view.alpha = 1
            self?.myNextButton.alpha = 1
            self?.closeButton.alpha = 1
        } completion: { _ in
            self.activityIndicator?.stopAnimating()
            player.play()
        }
    }

    private func removePlayer() {
        playerViewController.removeFromParent()
        playerViewController.view.removeFromSuperview()
        myNextButton.removeFromSuperview()
        closeButton.removeFromSuperview()
    }
}
