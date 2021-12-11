//
//  IntentHandler.swift
//  DeadlineAppIntent
//
//  Created by Егор Мальцев on 03.04.2021.
//

import Intents

class IntentHandler: INExtension, ConfigurationIntentHandling {
    func provideDeadlineOptionsCollection(for intent: ConfigurationIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<WidgetDeadline>?, Error?) -> Void) {
        
        let deadlines = DeadlineStruct.getAll().map { item in
            WidgetDeadline(identifier: "\(item.idD)", display: item.name)
        }
        
        let collection = INObjectCollection(items: deadlines)
        
        completion(collection, nil)
        
    }
}

