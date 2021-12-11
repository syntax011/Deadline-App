//
//  deadline struct.swift
//  DeadlineAppWidgetDExtension
//
//  Created by Егор Мальцев on 01.04.2021.
//

import Foundation
import UIKit
import SwiftUI

struct DeadlineStruct: Identifiable, Hashable, Codable {
    var id = UUID().uuidString
    var name: String
    var start: Date
    var end: Date
    var colorR: Int
    var colorG: Int
    var colorB: Int
    var idD: Int32
}

extension DeadlineStruct {
    
    static let previewDeadline: DeadlineStruct = DeadlineStruct(
        name: "Create a report",
        start: Date().addingTimeInterval(-10000),
        end: Date().addingTimeInterval(20000),
        colorR: 232,
        colorG: 204,
        colorB: 124,
        idD: Int32(-2)
    )
    
    static func getAll() -> [DeadlineStruct] {
        let names: [String] = UserDefaults(suiteName: "group.deadlineApp")?.array(forKey: "name") as! [String]
        let starts: [Date] = UserDefaults(suiteName: "group.deadlineApp")?.array(forKey: "start") as! [Date]
        let ends: [Date] = UserDefaults(suiteName: "group.deadlineApp")?.array(forKey: "end") as! [Date]
        let colorR: [Int] = UserDefaults(suiteName: "group.deadlineApp")?.array(forKey: "colorR") as! [Int]
        let colorG: [Int] = UserDefaults(suiteName: "group.deadlineApp")?.array(forKey: "colorG") as! [Int]
        let colorB: [Int] = UserDefaults(suiteName: "group.deadlineApp")?.array(forKey: "colorB") as! [Int]
        let idD: [Int32] = UserDefaults(suiteName: "group.deadlineApp")?.array(forKey: "idD") as! [Int32]
        
        var ans: [DeadlineStruct] = []
        for item in 0..<(names.count) {
            ans.append(
                DeadlineStruct.init(
                    name: names[item],
                    start: starts[item],
                    end: ends[item],
                    colorR: colorR[item],
                    colorG: colorG[item],
                    colorB: colorB[item],
                    idD: idD[item]
                )
            )
        }
        
        ans.append(
            DeadlineStruct.init(
                name: "-",
                start: Date(),
                end: Date(),
                colorR: 255,
                colorG: 255,
                colorB: 255,
                idD: -1001
            )
        )
        
        return ans
    }
    
    
    static func fromId(id: String) -> DeadlineStruct? {
        DeadlineStruct.getAll().first { "\($0.idD)" == id }
    }
    
}


