//
//  Deadline.swift
//  Deadline
//
//  Created by Егор Мальцев on 05.03.2021.
//

import Foundation
import CoreData
import SwiftUI


public class Deadline: NSManagedObject, Identifiable {
    
    @NSManaged public var done: Bool
    
    @NSManaged public var isPinned: Bool
    @NSManaged public var name: String
    @NSManaged public var note: String
    @NSManaged public var start: Date?
    @NSManaged public var end: Date?
    
    @NSManaged public var color: UIColor?
    @NSManaged public var notifications: [Bool]?
    
    @NSManaged public var idD: Int32
    
}
