//
//  DeadlineApp.swift
//  Deadline App Extension
//
//  Created by Егор Мальцев on 07.04.2021.
//

import SwiftUI

@main
struct DeadlineApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
