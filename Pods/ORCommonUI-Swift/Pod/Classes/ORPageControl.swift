//
//  ORPageControl.swift
//  ORCommonUI-Swift
//
//  Created by Sergey Aleksandrov on 09/01/2019.
//

open class ORPageControl: UIView {
    
    private let stackView = UIStackView()
    
    @IBInspectable open var selectedSize: CGFloat = 7
    @IBInspectable open var unselectedSize: CGFloat = 7
    @IBInspectable open var spacing: CGFloat = 5
    @IBInspectable open var selectedColor: UIColor = .white
    @IBInspectable open var unselectedColor: UIColor = UIColor.white.withAlphaComponent(0.15)
    @IBInspectable open var borderWidth: CGFloat = 0
    @IBInspectable open var borderColor: UIColor = .clear
    
    open var numberOfPages: Int = 0 {
        didSet {
            update()
        }
    }
    
    open var currentPage = 0 {
        didSet {
            if currentPage != oldValue {
                updatePage(currentPage: currentPage, oldPage: oldValue)
            }
        }
    }
    
    private var selectedScale: CGFloat {
        return selectedSize / unselectedSize
    }
    
    // MARK: - Lifecycle
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = spacing
        addSubview(stackView)
        stackView.autoCenterInSuperview()
        update()
    }
    
    private func update() {
        stackView.subviews.forEach { $0.removeFromSuperview() }
        for index in 0..<numberOfPages {
            let round = ORRoundRectView()
            round.layer.borderColor = borderColor.cgColor
            round.layer.borderWidth = borderWidth
            round.backgroundColor = index == currentPage ? selectedColor : unselectedColor
            round.autoSetDimensions(to: CGSize(width: unselectedSize, height: unselectedSize))
            if index == currentPage {
                round.transform = CGAffineTransform(scaleX: selectedScale, y: selectedScale)
            }
            stackView.addArrangedSubview(round)
        }
    }
    
    private func updatePage(currentPage: Int, oldPage: Int) {
        if stackView.arrangedSubviews.indices.contains(oldPage) {
            let oldPageView = stackView.arrangedSubviews[oldPage]
            oldPageView.backgroundColor = unselectedColor
            oldPageView.transform = .identity
        }
        
        if stackView.arrangedSubviews.indices.contains(currentPage) {
            let currentPageView = stackView.arrangedSubviews[currentPage]
            currentPageView.backgroundColor = selectedColor
            currentPageView.transform = CGAffineTransform(scaleX: selectedScale, y: selectedScale)
        }
    }
}

