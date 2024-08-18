//
//  FindEntityTraitProtocol.swift
//  MagicalRecord
//
//  Created by Alexey Vedushev on 16/01/2019.
//

import Foundation
import MagicalRecord

public protocol FindEntityTraitProtocol where Self: NSManagedObject {
    associatedtype key: RawRepresentable where key.RawValue == String
}

extension FindEntityTraitProtocol {
    public static func findOrCreate(in context: NSManagedObjectContext, byField: key, withValue: Any) -> Self {
        return ORCoreDataEntityFinderAndCreator(context).findOrCreateEntityOfType(Self.self, byAttribute: byField.rawValue, withValue: withValue)
    }
    
    public static func find(in context: NSManagedObjectContext, byField: key, withValue: Any) -> Self? {
        return ORCoreDataEntityFinderAndCreator(context).findEntityOfType(Self.self, byAttribute: byField.rawValue, withValue: withValue)
    }
}
