//
//  sheetAlert.swift
//  Deadline (iOS)
//
//  Created by Егор Мальцев on 27.05.2021.
//

import Foundation
import SwiftUI
import UIKit

import WidgetKit

struct AlertControlView: UIViewControllerRepresentable {
    let deleteText = NSLocalizedString("Delete", comment: "")
    let cancelText = NSLocalizedString("Cancel", comment: "")
    let titleText = NSLocalizedString("Do you really want to delete the deadline", comment: "")
    
    @Binding var showAlert: Bool
    @ObservedObject var deadline: Deadline
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertControlView>) -> UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AlertControlView>) {
        
       
        guard context.coordinator.alert == nil else { return }
        
        if self.showAlert {
            
            let alert = UIAlertController(
                title: titleText,
                message: nil,
                preferredStyle: .actionSheet
            )
            context.coordinator.alert = alert
            
            let deleteAction = UIAlertAction(title: deleteText, style: .default) { (action: UIAlertAction) in
                DispatchQueue.main.async {
                medium()
                
                for item in 0..<17 {
                   UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(deadline.idD)\(item)"])
                }
                
                
                deadline.done = true
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print("OOPS…")
                }
                
                WidgetCenter.shared.reloadAllTimelines()
                
                
                showRequest()
                }
                
                presentationMode.wrappedValue.dismiss()
                
                
            }
            
            deleteAction.setValue(UIColor(Color(deadline.color ?? .white)), forKey: "titleTextColor")
            
            alert.addAction(
                deleteAction
            )
            
            let cancelAction = UIAlertAction(title: cancelText, style: .default) { (action: UIAlertAction) in
            }
            
            cancelAction.setValue(UIColor(named: "AccentColor"), forKey: "titleTextColor")
            
            alert.addAction(cancelAction)
           
            DispatchQueue.main.async { 
                uiViewController.present(alert, animated: true, completion: {
                    self.showAlert = false
                    context.coordinator.alert = nil
                })
                
            }
        }
    }
    
    func makeCoordinator() -> AlertControlView.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        var alert: UIAlertController?
        
        var control: AlertControlView
        
        init(_ control: AlertControlView) {
            self.control = control
        }
    }
}

struct DeleteAlertControlView: UIViewControllerRepresentable {
    
    
    let deleteText = NSLocalizedString("Delete", comment: "")
    let cancelText = NSLocalizedString("Cancel", comment: "")
    let titleText = NSLocalizedString("Do you really want to delete the deadline", comment: "")
    
    @Binding var showAlert: Bool
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Deadline.end, ascending: true)],
        animation: .default) var deadlines: FetchedResults<Deadline>
    
    
    @ObservedObject var deadline: Deadline
    

    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DeleteAlertControlView>) -> UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<DeleteAlertControlView>) {
        
       
        guard context.coordinator.alert == nil else { return }
        
        if self.showAlert {
            
            let alert = UIAlertController(
                title: titleText,
                message: nil,
                preferredStyle: .actionSheet
            )
            context.coordinator.alert = alert
            
            let deleteAction = UIAlertAction(title: deleteText, style: .default) { (action: UIAlertAction) in
                DispatchQueue.main.async {
                medium()
                
                    
                    for deadline in deadlines {
                        
                        if deadline.done {
                            for item in 0..<17 {
                               UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(deadline.idD)\(item)"])
                            }
                            
                            
                            managedObjectContext.delete(deadline)
                            
                            do {
                                try managedObjectContext.save()
                            } catch {
                                print("OOPS…")
                            }
                            
                            WidgetCenter.shared.reloadAllTimelines()
                            
                            
                            
                        }
                    }
                
                }
                
                presentationMode.wrappedValue.dismiss()
                
                
            }
            
            deleteAction.setValue(
                UIColor(
                    Color(deadline.color ?? .white)
                )
                , forKey: "titleTextColor")
            
            alert.addAction(
                deleteAction
            )
            
            let cancelAction = UIAlertAction(title: cancelText, style: .default) { (action: UIAlertAction) in
            }
            
            cancelAction.setValue(UIColor(named: "AccentColor"), forKey: "titleTextColor")
            
            alert.addAction(cancelAction)
           
            DispatchQueue.main.async {
                uiViewController.present(alert, animated: true, completion: {
                    self.showAlert = false
                    context.coordinator.alert = nil
                })
                
            }
        }
    }
    
    func makeCoordinator() -> DeleteAlertControlView.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        var alert: UIAlertController?
        
        var control: DeleteAlertControlView
        
        init(_ control: DeleteAlertControlView) {
            self.control = control
        }
    }
}

struct RealDeleteAlertControlView: UIViewControllerRepresentable {
    let deleteText = NSLocalizedString("Delete", comment: "")
    let cancelText = NSLocalizedString("Cancel", comment: "")
    let titleText = NSLocalizedString("Do you really want to delete the deadline", comment: "")
    
    @Binding var showAlert: Bool
    @ObservedObject var deadline: Deadline
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<RealDeleteAlertControlView>) -> UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<RealDeleteAlertControlView>) {
        
       
        guard context.coordinator.alert == nil else { return }
        
        if self.showAlert {
            
            let alert = UIAlertController(
                title: titleText,
                message: nil,
                preferredStyle: .actionSheet
            )
            context.coordinator.alert = alert
            
            let deleteAction = UIAlertAction(title: deleteText, style: .default) { (action: UIAlertAction) in
                DispatchQueue.main.async {
                medium()
                
                for item in 0..<17 {
                   UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(deadline.idD)\(item)"])
                }
                
                
                    managedObjectContext.delete(deadline)
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print("OOPS…")
                }
                
                WidgetCenter.shared.reloadAllTimelines()
                
                
                showRequest()
                }
                
                presentationMode.wrappedValue.dismiss()
                
                
            }
            
            deleteAction.setValue(UIColor(Color(deadline.color ?? .white)), forKey: "titleTextColor")
            
            alert.addAction(
                deleteAction
            )
            
            let cancelAction = UIAlertAction(title: cancelText, style: .default) { (action: UIAlertAction) in
            }
            
            cancelAction.setValue(UIColor(named: "AccentColor"), forKey: "titleTextColor")
            
            alert.addAction(cancelAction)
           
            DispatchQueue.main.async {
                uiViewController.present(alert, animated: true, completion: {
                    self.showAlert = false
                    context.coordinator.alert = nil
                })
                
            }
        }
    }
    
    func makeCoordinator() -> RealDeleteAlertControlView.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        var alert: UIAlertController?
        
        var control: RealDeleteAlertControlView
        
        init(_ control: RealDeleteAlertControlView) {
            self.control = control
        }
    }
}
