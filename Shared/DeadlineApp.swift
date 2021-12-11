//
//  DeadlineApp.swift
//  Shared
//
//  Created by Егор Мальцев on 05.03.2021.
//

import SwiftUI
import CoreData
import WidgetKit
import CloudKit
import UIKit
import WatchConnectivity

var shortcutController = false

@main
struct DeadlineApp: App {
    
    var persistenceController = PersistenceController.shared
    
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    
    
    private let quickActionService = QuickActionService()
    
    @AppStorage("paschalkaController") private var showingPaschalka: Bool = false
    
    init() {
        UIApplication.shared.isStatusBarHidden = true
    }
   
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(quickActionService)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            .statusBar(hidden: true)
            
                .onAppear(perform: {
                    showingPaschalka = false
                })
        }
        .onChange(of: scenePhase) { scenePhase in
            switch scenePhase {
            case .active:
                guard let shortcutItem = appDelegate.shortcutItem else { return }
                
                quickActionService.action = QuickAction(rawValue: shortcutItem.type)
                
                if quickActionService.action == QuickAction(rawValue: QuickAction.newDeadline.rawValue) {
                    addNewDynamicQuickActions()
                } else {
                    addDynamicQuickActions()
                }
                
            case .background:
                if quickActionService.action == QuickAction(rawValue: QuickAction.newDeadline.rawValue) {
                    addNewDynamicQuickActions()
                } else {
                    addDynamicQuickActions()
                }
                
            default: return
            }
        }
        
    }
    
    private func addDynamicQuickActions() {
        UIApplication.shared.shortcutItems = [
            UIApplicationShortcutItem(
                type: QuickAction.newDeadline.rawValue,
                localizedTitle: newDeadlineShortcut,
                localizedSubtitle: nil,
                icon: UIApplicationShortcutIcon(systemImageName: "plus"),
                userInfo: nil
            )
        ]
    }
    
    private func addNewDynamicQuickActions() {
        UIApplication.shared.shortcutItems = [
            UIApplicationShortcutItem(
                type: QuickAction.newNewDeadline.rawValue,
                localizedTitle: newDeadlineShortcut,
                localizedSubtitle: nil,
                icon: UIApplicationShortcutIcon(systemImageName: "plus"),
                userInfo: nil
            )
        ]
    }
    
    let newDeadlineShortcut = NSLocalizedString("New deadline", comment: "")
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    var shortcutItem: UIApplicationShortcutItem? { AppDelegate.shortcutItem }
    
    fileprivate static var shortcutItem: UIApplicationShortcutItem?
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        
        
        application.isStatusBarHidden = UserDefaults.standard.bool(forKey: "isStatusBarHidden")
        
        
        if let shortcutItem = options.shortcutItem {
            AppDelegate.shortcutItem = shortcutItem
        }
        
        let sceneConfiguration = UISceneConfiguration(
            name: "Scene Configuration",
            sessionRole: connectingSceneSession.role
        )
        sceneConfiguration.delegateClass = SceneDelegate.self
        
        return sceneConfiguration
    }
}

private final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        AppDelegate.shortcutItem = shortcutItem
        completionHandler(true)
    }
}

enum QuickAction: String {
    case newDeadline
    case newNewDeadline
}

final class QuickActionService: ObservableObject {
    @Published var action: QuickAction?
    
    init(initialValue: QuickAction? = nil) {
        action = initialValue
    }
}

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Deadline")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "iCloud.group.deadlineApp")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            fatalError("\(error)")
        }
       
    }
}
