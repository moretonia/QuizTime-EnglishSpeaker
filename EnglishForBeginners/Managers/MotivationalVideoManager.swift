//
//  MotivationalVideoManager.swift
//  EnglishForBeginners
//
//  Created by Jan Kaltoun on 18.04.2021.
//  Copyright © 2021 Bryan Rolandsen. All rights reserved.
//

import Foundation

class MotivationalVideoManager {
    static let baseURL = URL(string: //"https://thirdageapps.com/thirdageapps.com/Rolandsen/Motivational_Movies")!
                             "https://drongoapps.com/Motivational_Movies")!
    static let filenameFormat = "mtvnl_%d.mp4"
    static let maxVideoNumber = 24

    static let movies = "Movies%@.mp4"

    static let shared = MotivationalVideoManager()
    
    var nextVideoNumber: Int {
        guard
            let lastVideoNumber = UserDefaultsManager.shared.lastMotivationalVideoNumber,
            lastVideoNumber < Self.maxVideoNumber
        else {
            return 1
        }
        
        return lastVideoNumber + 1
    }
    
    var nextVideoURL: URL {
        Self.baseURL.appendingPathComponent(
            String(format: Self.filenameFormat, nextVideoNumber)
        )
    }
    
    func setNextVideoAsLast() {
        UserDefaultsManager.shared.lastMotivationalVideoNumber = nextVideoNumber
    }

    func getMovies(for number: String) -> URL {
        let value = String(format: Self.movies, number)
        return Self.baseURL.appendingPathComponent(
            value
        )
    }
}
