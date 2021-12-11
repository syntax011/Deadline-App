//
//  DeadlineItem.swift
//  Deadline
//
//  Created by Егор Мальцев on 06.03.2021.
//

import SwiftUI

import WidgetKit

import CoreData

import UIKit

struct ProgressBar: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.colorScheme) var colorScheme
    
    let controller = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    @ObservedObject var deadline: Deadline
    
    @State var ProgressValue: Double
    @State var cornerRadius: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                
                    
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .foregroundColor(
                        self.colorScheme == .dark ? Color.init(white: 44/255) : Color.init(white: 245/255)
                    
                    )
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                
                    .foregroundColor(
                        Color(deadline.color ?? UIColor.white)
                    )
                    
                    .opacity(
                        Float((deadline.end ?? Date()).timeIntervalSince(Date())) <= 0 ? 0.2 : 0
                    )
                    
                HStack(spacing: -5) {
                    Rectangle()
                        
                        .frame(width: min(CGFloat(self.ProgressValue)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                        .foregroundColor((
                            
                            colorScheme == .dark ? Color.init(white: 44/255) : Color.init(white: 245/255)
                        ))
                        .opacity(0)
//                        .animation(.linear)
                    Rectangle()
                        .frame(width: 4.5)
                        .foregroundColor(Color(deadline.color ?? UIColor(Color.white)))
                        
                }
                .onReceive(controller, perform: { _ in
                    
                    DispatchQueue.main.async {
                    
                        if (deadline.end ?? Date()).timeIntervalSince(deadline.start ?? Date()) != 0 {
                            ProgressValue = Double((deadline.end ?? Date()).timeIntervalSince(Date())/(deadline.end ?? Date()).timeIntervalSince(deadline.start ?? Date()))
                        }
                        
                    }
                    
                })
            }.clipShape(RoundedRectangle(cornerRadius: CGFloat(cornerRadius), style: .continuous))
        }
    }
}

struct DeadlineItem: View {
    
    var ipadMacConfig = {
        IpadAndMacConfiguration(anchor: nil, arrowEdge: nil)
    }()
    
    let deleteText = NSLocalizedString("Delete", comment: "")
    let cancelText = NSLocalizedString("Cancel", comment: "")
    let titleText = NSLocalizedString("Do you really want to delete the deadline", comment: "")
        
    @State var year: Int
    @State var month: Int
    @State var day: Int
    @State var hour: Int
    @State var minute: Int
    @State var second: Int
            
    let timerControllerItem = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
       
    func dateString(date: Date) -> String {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        
        let formatter2 = DateFormatter()
        formatter2.timeStyle = .medium
        
        return "\(formatter1.string(from: date))"
        
    }
    
    func timeString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return "\(dateFormatter.string(from: date))"
       
    }
    
    
    @State var sheetController = false
    @ObservedObject var deadline: Deadline
    @State var showingEdit = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.colorScheme) var colorScheme
    
    @State var itemDeleteController = false
    @State var itemiPadDeleteController = false
    
    
    @State var showingExpired: Bool
    
    @AppStorage("alert") private var alertBeforeDelete: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .top) {
                if deadline.isPinned {
                    Image(systemName: "mappin")
                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                        .font(.system(size: 17, weight: .medium))
                }
                Text(deadline.name)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 18, weight: .medium))
                    .lineLimit(5)
                    .sheet(isPresented: $sheetController, content: {
                        DetailedItemView(
                            deadline: deadline
                        ).environment(\.managedObjectContext, managedObjectContext)
                    })
                Spacer()
                VStack(alignment: .trailing) {
                    Text(LocalizedStringKey("Time left"))
                        .font(.system(size: 14.5, weight: .regular))
                        .foregroundColor(
                            Float((deadline.end ?? Date()).timeIntervalSince(Date())) <= 0 ?
                                Color(deadline.color ?? UIColor.white) : Color.gray
                    )
                        .sheet(isPresented: $showingEdit, content: {
                            if #available(iOS 15.0, *) {
                                EditView(addingName: deadline.name, addingStart: deadline.start!, addingEnd: deadline.end!, addingNotifications: deadline.notifications!, addingColor: Color(deadline.color!), deadline: deadline).environment(\.managedObjectContext, managedObjectContext)
                            } else {
                                // Fallback on earlier versions
                            }
                        })
                    HStack(spacing: 0) {
                        Spacer()
                        if showingExpired {
                            Text(LocalizedStringKey("expired"))
                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                        } else {
                            Text(deadline.end ?? Date(), style: .relative)
                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                        }
                    }.frame(width: 130)
                    
                    
                }
            }
            .onReceive(timerControllerItem) { _ in
                DispatchQueue.main.async {
                    self.showingExpired = (Float((deadline.end ?? Date()).timeIntervalSince(Date())) <= 0)
                }
            }
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    if Text(dateString(date: deadline.end ?? Date())) == Text(dateString(date: deadline.start ?? Date())) {
                        Text(timeString(date: deadline.start ?? Date()))
                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                    } else {
                        Text(dateString(date: deadline.start ?? Date()))
                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                    }
                    
                    
                    Text(LocalizedStringKey("Start"))
                        .font(.system(size: 14.5, weight: .regular))
                        .foregroundColor(
                            Float((deadline.end ?? Date()).timeIntervalSince(Date())) <= 0 ?
                                Color(deadline.color ?? UIColor.white) : Color.gray)
                    
                }
                
                Spacer()
                VStack(alignment: .trailing) {
                    if (Text(dateString(date: deadline.end ?? Date())) == Text(dateString(date: deadline.start ?? Date()))) ||  Text(dateString(date: Date())) == Text(dateString(date: deadline.end ?? Date())) || Text(dateString(date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)) == Text(dateString(date: deadline.end ?? Date())) {
                        if Text(dateString(date: Date())) == Text(dateString(date: deadline.end ?? Date())) {
                            HStack(spacing: 0) {
                                Text(LocalizedStringKey("Today at"))
                                    .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                Text("\(timeString(date: deadline.end ?? Date()))")
                                    .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                            }
                        } else if Text(dateString(date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)) == Text(dateString(date: deadline.end ?? Date())) {
                            HStack(spacing: 0) {
                                Text(LocalizedStringKey("Tomorrow at"))
                                    .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                Text("\(timeString(date: deadline.end ?? Date()))")
                                    .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                            }
                        } else {
                            Text(timeString(date: deadline.end ?? Date()))
                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                        }
                        
                    } else {
                        Text(dateString(date: deadline.end ?? Date()))
                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                    }
                    Text(LocalizedStringKey("deadline"))
                        .font(.system(size: 14.5, weight: .regular))
                        .foregroundColor(
                            Float((deadline.end ?? Date()).timeIntervalSince(Date())) <= 0 ?
                                Color(deadline.color ?? UIColor.white) : Color.gray)
                        
                     
                }
            }
        }
        
        .actionSheet(isPresented: $itemiPadDeleteController) {
            ActionSheet(title: Text(LocalizedStringKey("Do you really want to delete the deadline")), buttons: [
                .destructive(Text(LocalizedStringKey("Delete"))) {
                    
                    
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
                                    
                },
                
                .default(Text(LocalizedStringKey("Cancel")).foregroundColor(colorScheme == .dark ? Color.init(white: 223/255) : Color.init(white: 32/255))) {
                    
                }
                ])
        }
        
        .actionOver(
            presented: $itemDeleteController,
            title: titleText,
            message: nil,
            buttons:
                [
                    ActionOverButton(
                        title: deleteText,
                        type: .destructive,
                        action: {
                            
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
                        }
                    ),
                    
                    
                    ActionOverButton(
                        title: cancelText,
                        type: .normal,
                        action: {}
                    )
                    
                ]
            ,
            ipadAndMacConfiguration: ipadMacConfig, normalButtonColor: UIColor(Color(deadline.color ?? UIColor.white))
    )
        
        .accentColor(colorScheme == .dark ? .white : Color(white: 32/255))
        .padding()
        .background(
            ProgressBar(deadline: deadline, ProgressValue: Double((deadline.end ?? Date()).timeIntervalSince(Date())/(deadline.end ?? Date()).timeIntervalSince(deadline.start ?? Date())), cornerRadius: 20)
                .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        )
        .contextMenu {
                Button(action: {
                    if alertBeforeDelete {
                        medium()
                        deleteActionSheet()
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
                    }
                    
                    
                }) {
                    HStack {
                        Text(LocalizedStringKey("Done = Delete"))
                        Image(systemName: "checkmark")
                    }
                }
                
                Button(action: {
                    medium()
                    showingEdit.toggle()
                }) {
                    HStack {
                        Text(LocalizedStringKey("Edit"))
                        Image(systemName: "pencil")
                    }
                }
            
            
            
            
            Button(action: {
                medium()
                withAnimation {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                        deadline.isPinned.toggle()
                        }
                        do {
                            try managedObjectContext.save()
                        } catch {
                            print("OOPS…")
                        }
                    }
                }
            }) {
                HStack {
                    Text(deadline.isPinned ? LocalizedStringKey("Unpin") : LocalizedStringKey("Pin"))
                    Image(systemName: deadline.isPinned ? "mappin.slash" : "mappin")
                }
            }
            
            
            
            
            
            }
        .onOpenURL { url in
            
            
            if url == URL(string: "deadlineAppWidget://\(deadline.idD)")  {
                
                light()
                
                self.sheetController = true
            }
        }
        .onTapGesture(perform: {
            light()
            self.sheetController.toggle()
        })
        
        
        
    }
    
    func deleteActionSheet() {
//        let deleteText = NSLocalizedString("Delete", comment: "")
//        let cancelText = NSLocalizedString("Cancel", comment: "")
//        let titleText = NSLocalizedString("Do you really want to delete the deadline", comment: "")
        
        let alertVC = UIAlertController(title: titleText, message: nil, preferredStyle: .actionSheet)
        
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
            
            
        }
        let cancelAction = UIAlertAction(title: cancelText, style: .default) { (action: UIAlertAction) in
            
        }
        
        deleteAction.setValue(UIColor(Color(deadline.color ?? .white)), forKey: "titleTextColor")
        cancelAction.setValue(UIColor(named: "AccentColor"), forKey: "titleTextColor")
        
        alertVC.addAction(deleteAction)
        alertVC.addAction(cancelAction)
        
        
        
        let viewController = UIApplication.shared.windows.first!.rootViewController!
        viewController.present(alertVC, animated: true, completion: nil)
    }
   
    
}



   
