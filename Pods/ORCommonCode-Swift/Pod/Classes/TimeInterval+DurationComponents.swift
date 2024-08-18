//
//  TimeInterval+DurationComponents.swift
//  Pods
//
//  Created by Maxim Soloviev on 01/04/16.
//
//

import Foundation

extension TimeInterval {
    
    public func or_timeComponents() -> (days: Int, hours: Int, minutes: Int, seconds: Int, milliseconds: Int) {
        let value: TimeInterval = self < 0 ? 0 : self
        
        let days = Int(value / (60 * 60 * 24))
        let hours = Int(value / (60 * 60)) - days * 24
        let minutes = Int(value / 60) - days * 24 * 60 - hours * 60
        let seconds = Int(value) - days * 24 * 60 * 60 - hours * 60 * 60 - minutes * 60
        let milliseconds = Int(fmod(value, 1) * 1000)
        
        return (days: days, hours: hours, minutes: minutes, seconds: seconds, milliseconds: milliseconds)
    }
    
    /**
     Only 2 top components are printed to string, or only 1 if others == 0
     */
    public func or_timeStringShort(daysLocalized: String = "d", hoursLocalized: String = "h", minutesLocalized: String = "m") -> String {
        var result = ""
        let components = or_timeComponents()

        if components.days > 0 {
            if components.hours > 0 {
                result = "\(components.days)" + daysLocalized + " \(components.hours)" + hoursLocalized
            } else {
                result = "\(components.days)" + daysLocalized
            }
        } else if components.hours > 0 {
            if components.minutes > 0 {
                result = "\(components.hours)" + hoursLocalized + " \(components.minutes)" + minutesLocalized
            } else {
                result = "\(components.hours)" + hoursLocalized
            }
        } else {
            result = "\(components.minutes)" + minutesLocalized
        }
        
        return result
    }
    
    public func or_timeStringHMSMsec() -> String {
        let components = or_timeComponents()
        let res = "\(components.hours + components.days * 24):\(String(format: "%02d", components.minutes)):\(String(format: "%02d", components.seconds)).\(String(format: "%03d", components.milliseconds))"
        return res
    }
}
