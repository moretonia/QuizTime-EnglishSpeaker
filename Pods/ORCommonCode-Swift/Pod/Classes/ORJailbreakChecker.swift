//
//  ORJailbreakChecker.swift
//  ORCommonCode-Swift
//
//  Created by Sergey Aleksandrov on 09/01/2019.
//

public struct ORJailbreakChecker {
    
    public static func isDeviceJailbroken() -> Bool {
        #if targetEnvironment(simulator)
            return false
        #else
            return isFoundJailbreakFiles() || isFoundJailbrokenReadWritePermissions() || isFoundJailbreakSymlinks()
        #endif
    }
    
    private static func isFoundJailbreakFiles() -> Bool {
        let filePaths = ["/bin/bash",
                         "/etc/apt",
                         "/usr/sbin/sshd",
                         "/Library/MobileSubstrate/MobileSubstrate.dylib",
                         "/Applications/Cydia.app",
                         "/bin/sh",
                         "/var/cache/apt",
                         "/var/tmp/cydia.log"]
        
        return filePaths.contains(where: { FileManager.default.fileExists(atPath: $0) })
    }
    
    private static func isFoundJailbreakSymlinks()-> Bool {
        let symLinkPaths = ["/Applications",
                            "/usr/libexec",
                            "/usr/share",
                            "/Library/Wallpaper",
                            "/usr/include"]
        
        for path in symLinkPaths {
            if let attributes = try? FileManager.default.attributesOfItem(atPath: path), let type = attributes[.type] as? FileAttributeType, type == .typeSymbolicLink {
                return true
            }
        }
        return false
    }
    
    private static func isFoundJailbrokenReadWritePermissions() -> Bool {
        if UIApplication.shared.canOpenURL(URL(string: "cydia://package/com.com.com")!) {
            return true
        }
        
        let stringToBeWritten = "0"
        if (try? stringToBeWritten.write(toFile: "/private/jailbreak.test", atomically: true, encoding: .utf8)) != nil {
            return true
        }
        return false
    }
}

