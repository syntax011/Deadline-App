//
//  DetailedItemView.swift
//  Deadline
//
//  Created by Егор Мальцев on 07.03.2021.
//

import SwiftUI

import WidgetKit
import CoreData
import CloudKit
import EventKit

import UIKit


struct SecondDetailedItemView: View {
    
    var ipadMacConfig = {
        IpadAndMacConfiguration(anchor: nil, arrowEdge: nil)
    }()
    
    let deleteText = NSLocalizedString("Delete", comment: "")
    let cancelText = NSLocalizedString("Cancel", comment: "")
    let titleText = NSLocalizedString("Do you really want to delete the deadline", comment: "")
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var deadline: Deadline
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showingEditView = false
    @State var deleteController = false
    @State var ipadDeleteController = false
    @State var year: Int
    @State var month: Int
    @State var day: Int
    @State var hour: Int
    @State var minute: Int
    @State var second: Int
    @State var notificationsEnabled: Bool
    
    let timerController = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State var showAlert: Bool = false
    
    @AppStorage("alert") private var alertBeforeDelete: Bool = false
    
    var body: some View {
        
        ZStack {
            VStack {
                VStack(alignment: .leading) {
                    Spacer()
                    HStack(alignment: .top) {
                        Text(deadline.name)
                            .font(.system(size: 28, weight: .medium))
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color(white: 32/255))
                            .lineLimit(3)
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        VStack(alignment: .leading) {
                            HStack(spacing: 10) {
                                Text(dateString(date: deadline.start ?? Date()))
                                    .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                Text(timeString(date: deadline.start ?? Date()))
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
                            HStack(spacing: 10) {
                                Text(dateString(date: deadline.end ?? Date()))
                                    .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                Text(timeString(date: deadline.end ?? Date()))
                                    .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                            }
                            Text(LocalizedStringKey("deadline"))
                                .font(.system(size: 14.5, weight: .regular))
                                .foregroundColor(
                                    Float((deadline.end ?? Date()).timeIntervalSince(Date())) <= 0 ?
                                        Color(deadline.color ?? UIColor.white) : Color.gray)
                        }
                    }
                }.padding(20)
                    .padding(.top, 64)
                    .background(
                        ProgressBar(
                            deadline: deadline,
                            ProgressValue: Double((deadline.end ?? Date()).timeIntervalSince(Date())/(deadline.end ?? Date()).timeIntervalSince(deadline.start ?? Date())),
                            cornerRadius: 0
                        )
                    )
                    .frame(height: 275)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text(LocalizedStringKey("Time left"))
                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                        Spacer()
                    }.padding(.leading, 20)
                    if Float((deadline.end ?? Date()).timeIntervalSince(Date())) <= 0 {
                        HStack {
                            Spacer()
                            Text(LocalizedStringKey("expired"))
                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                .font(.title)
                                .fontWeight(.medium)
                            Spacer()
                        }
                    } else {
                        
                        HStack {
                            Spacer()
                            HStack(spacing: 25) {
                                
                                if year != 0 {
                                    VStack {
                                        Text("\(year)")
                                            .font(.title)
                                            .fontWeight(.medium)
                                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                        Text(LocalizedStringKey("y"))
                                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                    }
                                }
                                if month != 0 || year != 0 {
                                    VStack {
                                        Text("\(raznitsa(deadline: deadline, type: "month"))")
                                            .font(.title)
                                            .fontWeight(.medium)
                                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                        Text(LocalizedStringKey("mo"))
                                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                    }
                                }
                                if day != 0 || month != 0 || year != 0 {
                                    VStack {
                                        Text("\(day)")
                                            .font(.title)
                                            .fontWeight(.medium)
                                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                        Text(LocalizedStringKey("d"))
                                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                    }
                                }
                                if hour != 0 || day != 0 || month != 0 || year != 0 {
                                    VStack {
                                        Text("\(hour)")
                                            .font(.title)
                                            .fontWeight(.medium)
                                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                        Text(LocalizedStringKey("h"))
                                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                    }
                                }
                                if minute != 0 || hour != 0 || day != 0 || month != 0 || year != 0 {
                                    VStack {
                                        Text("\(minute)")
                                            .font(.title)
                                            .fontWeight(.medium)
                                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                        Text(LocalizedStringKey("min"))
                                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                    }
                                }
                                if second != 0 || minute != 0 || hour != 0 || day != 0 || month != 0 || year != 0 {
                                    VStack {
                                        Text("\(second)")
                                            .font(.title)
                                            .fontWeight(.medium)
                                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                        Text(LocalizedStringKey("sec"))
                                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                    }
                                }
                                
                            }
                            .fixedSize(horizontal: true, vertical: false)
                            .onReceive(timerController) { _ in
                                
                                DispatchQueue.main.async {
                                
                                year = raznitsa(deadline: deadline, type: "year")
                                month = raznitsa(deadline: deadline, type: "month")
                                day = raznitsa(deadline: deadline, type: "day")
                                hour = raznitsa(deadline: deadline, type: "hour")
                                minute = raznitsa(deadline: deadline, type: "minute")
                                second = raznitsa(deadline: deadline, type: "second")
                                
                                }
                            }
                            .frame(width: 300)
                            
                            Spacer()
                        }
                        
                    }
                        
                }.padding([.horizontal, .top])
                .padding(.top, 10)
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    HStack(spacing: 0) {
                        Text(LocalizedStringKey("Notifications"))
                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                            .onReceive(timerController) { _ in
                                
                                DispatchQueue.main.async {
                                notificationsEnabled = areNotificationsEnabled()
                                }
                            }
                            
                        Text(":")
                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                        Spacer()
                    }.padding(.leading, 20)
                    
                    
                    
                    if !notificationsEnabled {
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    if UserDefaults.standard.bool(forKey: "notifiationRequest") == false {
                                        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (_, _) in
                                        }
                                        UserDefaults.standard.set(true, forKey: "notifiationRequest")
                                    } else {
                                        if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                                            if UIApplication.shared.canOpenURL(appSettings) {
                                                UIApplication.shared.open(appSettings)
                                            }
                                        }
                                    }
                                }, label: {
                                    Text(LocalizedStringKey("allow notifications"))
                                        .padding(.horizontal, 15)
                                        .foregroundColor(colorScheme == .dark ? Color(white: 32/255) : Color.white)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                                .frame(height: 32)
                                                .foregroundColor(colorScheme == .dark ? Color.white : Color(white: 32/255))
                                        )
                                })
                                Spacer()
                            }.padding([.horizontal, .top])
                        }
                    } else {
                        if deadline.notifications == [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false] {
                            
                            HStack {
                                Spacer()
                                Text(LocalizedStringKey("No notifications"))
                                    .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.top, 5)
                                
                        } else {
                            VStack(alignment: .leading) {
                                if (deadline.notifications?.filter { $0 == true }.count ?? 0) > 3 {
                                    ScrollView {
                                        VStack(alignment: .leading) {
                                            ForEach(0..<17, id: \.self) { notification in
                                                if deadline.notifications?[notification] == true {
                                                    HStack {
                                                        Circle()
                                                            .frame(width: 8, height: 8)
                                                            .foregroundColor(colorScheme == .dark ? Color.white : Color(white: 32/255))
                                                        switch notification {
                                                        case 0:
                                                            Text(LocalizedStringKey("at time"))
                                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                        case 1:
                                                            Text(LocalizedStringKey("1 month"))
                                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                        case 2:
                                                            Text(LocalizedStringKey("2 weeks"))
                                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                        case 3:
                                                            Text(LocalizedStringKey("7 days"))
                                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                        case 4:
                                                            Text(LocalizedStringKey("3 days"))
                                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                        case 5:
                                                            Text(LocalizedStringKey("2 days"))
                                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                        case 6:
                                                            Text(LocalizedStringKey("24 hours"))
                                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                        case 7:
                                                            Text(LocalizedStringKey("12 hours"))
                                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                        case 8:
                                                            Text(LocalizedStringKey("6 hours"))
                                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                        case 9:
                                                            Text(LocalizedStringKey("3 hours"))
                                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                        case 10:
                                                            Text(LocalizedStringKey("2 hours"))
                                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                        case 11:
                                                            Text(LocalizedStringKey("1 hour"))
                                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                        case 12:
                                                            Text(LocalizedStringKey("30 minutes"))
                                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                        case 13:
                                                            Text(LocalizedStringKey("15 minutes"))
                                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                        case 14:
                                                            Text(LocalizedStringKey("10 minutes"))
                                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                        case 15:
                                                            Text(LocalizedStringKey("5 minutes"))
                                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                        case 16:
                                                            Text(LocalizedStringKey("1 minute"))
                                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                        default:
                                                            Text("ОШИБКА")
                                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    ForEach(0..<17, id: \.self) { notification in
                                        if deadline.notifications?[notification] == true {
                                            HStack {
                                                Circle()
                                                    .frame(width: 8, height: 8)
                                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(white: 32/255))
                                                switch notification {
                                                case 0:
                                                    Text(LocalizedStringKey("at time"))
                                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                case 1:
                                                    Text(LocalizedStringKey("1 month"))
                                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                case 2:
                                                    Text(LocalizedStringKey("2 weeks"))
                                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                case 3:
                                                    Text(LocalizedStringKey("7 days"))
                                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                case 4:
                                                    Text(LocalizedStringKey("3 days"))
                                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                case 5:
                                                    Text(LocalizedStringKey("2 days"))
                                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                case 6:
                                                    Text(LocalizedStringKey("24 hours"))
                                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                case 7:
                                                    Text(LocalizedStringKey("12 hours"))
                                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                case 8:
                                                    Text(LocalizedStringKey("6 hours"))
                                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                case 9:
                                                    Text(LocalizedStringKey("3 hours"))
                                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                case 10:
                                                    Text(LocalizedStringKey("2 hours"))
                                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                case 11:
                                                    Text(LocalizedStringKey("1 hour"))
                                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                case 12:
                                                    Text(LocalizedStringKey("30 minutes"))
                                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                case 13:
                                                    Text(LocalizedStringKey("15 minutes"))
                                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                case 14:
                                                    Text(LocalizedStringKey("10 minutes"))
                                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                case 15:
                                                    Text(LocalizedStringKey("5 minutes"))
                                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                case 16:
                                                    Text(LocalizedStringKey("1 minute"))
                                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                default:
                                                    Text("ОШИБКА")
                                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                }
                                            }
                                        }
                                    }
                                }
                            }.padding(.leading, 60)
                            
                        }
                    }
                }.padding([.horizontal, .top])
                
                NotesView(deadline: deadline)
                    .environment(\.managedObjectContext, managedObjectContext)
                    .padding(.bottom, 20)
                
                Spacer()
                HStack(spacing: 15) {
                    Button(action: {
                        
                        if alertBeforeDelete {
                            medium()
                            showAlert.toggle()
                        } else {
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

                        
                        
                        
                        
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                .frame(height: 50)
                            Text(LocalizedStringKey("Done!"))
                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                        }
                    })
                    
                    .actionSheet(isPresented: $ipadDeleteController) {
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
                                presentationMode.wrappedValue.dismiss()
                                
                            },
                            
                            .default(
                                Text(LocalizedStringKey("Cancel")).foregroundColor(colorScheme == .dark ? Color.init(white: 223/255) : Color.init(white: 32/255)))
                                {}
                            ])
                    }
                    .actionOver(
                        presented: $deleteController,
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
                                        
                                        presentationMode.wrappedValue.dismiss()
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
                    
                    Button(action: {
                        medium()
                        showingEditView.toggle()
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                .frame(height: 50)
                            Text(LocalizedStringKey("Edit"))
                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                
                        }
                    })
                }
                .sheet(isPresented: $showingEditView,
                       onDismiss: {
                        year = raznitsa(deadline: deadline, type: "year")
                        month = raznitsa(deadline: deadline, type: "month")
                        day = raznitsa(deadline: deadline, type: "day")
                        hour = raznitsa(deadline: deadline, type: "hour")
                        minute = raznitsa(deadline: deadline, type: "minute")
                        second = raznitsa(deadline: deadline, type: "second")
                       },
                       content: {
                    if #available(iOS 15.0, *) {
                        EditView(addingName: deadline.name, addingStart: deadline.start!, addingEnd: deadline.end!, addingNotifications: deadline.notifications!, addingColor: Color(deadline.color!), deadline: deadline).environment(\.managedObjectContext, managedObjectContext)
                    } else {
                        // Fallback on earlier versions
                    }
                       }
                )
                
                .padding()
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                .edgesIgnoringSafeArea(.all)
            }
            if showAlert {
                AlertControlView(
                    showAlert: $showAlert,
                    deadline: deadline
                )
            }
        }
        
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
            
            presentationMode.wrappedValue.dismiss()
        }
        let cancelAction = UIAlertAction(title: cancelText, style: .default) { (action: UIAlertAction) in
            
        }
        
        
        
        deleteAction.setValue(UIColor(Color(deadline.color ?? .white)), forKey: "titleTextColor")
        cancelAction.setValue((colorScheme == .dark ? UIColor.white : UIColor(white: 32/255, alpha: 1)), forKey: "titleTextColor")
        
        alertVC.addAction(deleteAction)
        alertVC.addAction(cancelAction)
        
        
        
        let viewController = UIApplication.shared.windows.first!.rootViewController!
        viewController.present(alertVC, animated: true, completion: nil)
    }
}

struct DetailedItemView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var deadline: Deadline
    
//    @State var isAddedToCalendar: Bool
   
    var body: some View {
    
            NavigationView {
                ZStack {
                    if colorScheme == .dark {
                        Color(white: 32/255)
                            .edgesIgnoringSafeArea(.all)
                    }
                    
                SecondDetailedItemView(
                    deadline: deadline,
                    year: raznitsa(deadline: deadline, type: "year"),
                    month: raznitsa(deadline: deadline, type: "month"),
                    day: raznitsa(deadline: deadline, type: "day"),
                    hour: raznitsa(deadline: deadline, type: "hour"),
                    minute: raznitsa(deadline: deadline, type: "minute"),
                    second: raznitsa(deadline: deadline, type: "second"),
                    notificationsEnabled: areNotificationsEnabled()
                )
                    
                .padding(.top, -150)
                .toolbar(content: {
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        
                        addToCalendarView(deadline: deadline, isAddded: isEventInCalendar(deadline: deadline))
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            light()
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text(LocalizedStringKey("Done"))
                        })
                    }
                    })
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .accentColor(colorScheme == .dark ? Color.white : Color(white: 32/255))
    }
}

import EventKitUI
import EventKit

func isAccessToCalendarEnabled() -> Bool? {
    var isAccessEnabled: Bool?
    
    switch EKEventStore.authorizationStatus(for: .event) {
    case .authorized:
        isAccessEnabled = true

    case .denied:
        isAccessEnabled = false

    case .notDetermined:
        eventStore.requestAccess(to: .event, completion:
            {(granted: Bool, error: Error?) -> Void in
                if granted {
                    isAccessEnabled = true
                } else {
                    isAccessEnabled = false
                }
        })
    default:
        print("DEFAULT")
    }
    
    return isAccessEnabled
}

struct addToCalendarView: View {
    let timerController = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @ObservedObject var deadline: Deadline
    @State var isAddded: Bool

    @Environment(\.colorScheme) var colorScheme
    
    @State var activeSheetController: ShareSheetController?
    @State var activeAlertController: AlertController?
    
    var body: some View {
        
        
        ZStack {
            
            Rectangle()
                .foregroundColor(Color(red: 1, green: 1, blue: 1, opacity: 0))
                .sheet(item: $activeSheetController) { item in
                    switch item {
                        case .qr:
                            QRView(deadline: deadline)
                        case .share:
                            ZStack {
                                if colorScheme == .dark {
                                    Color(white: 32/255)
                                        .edgesIgnoringSafeArea(.all)
                                }
                                ActivityView(
                                    activityItems: ["""
        \(NSLocalizedString("Name", comment: "")): \(deadline.name)
        \(NSLocalizedString("Start", comment: "")) \(dateString(date: deadline.start ?? Date())) \(timeString(date: deadline.start ?? Date())) \(timeZoneString(date: deadline.start ?? Date()))
        \(NSLocalizedString("deadline", comment: "")) \(dateString(date: deadline.end ?? Date())) \(timeString(date: deadline.end ?? Date())) \(timeZoneString(date: deadline.start ?? Date()))
        
        """, NSURL(string: "\(createDeadlineURL(deadline: deadline))")!] as [Any], applicationActivities: nil)
                                    .edgesIgnoringSafeArea(.all)
                               }
                        //Чтобы добавить себе этот дедлайн, нажмите на ссылку ниже:
                    }
                }
                
                .alert(item: $activeAlertController, content: { item in
                    switch item {
                    case .access:
                        return
                            Alert(
                                title: Text("«Deadline App» Would Like to Access Your Calendar"),
                                message: Text("We’d like to access your calendar to add deadlines"),
                                primaryButton: .default(Text("Don't Allow")) {
                                    
                                },
                                secondaryButton: .default(Text("OK")) {
                                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                                    }
                                }
                            )
                    case .success:
                        return
                            Alert(
                                title: Text(LocalizedStringKey("added to calendar"))
                            )
                    
                    }
                    }
                )
            
            Menu() {
                Button(action: {
                    
                    DispatchQueue.main.async {
                        medium()
                        
                        UIView.appearance().tintColor = UIColor(named: "AccentColor")
                        
                        eventStore.requestAccess(to: .event) { (granted, error) in
                            
                            if granted {
                                DispatchQueue.main.async {
                                    if isEventInCalendar(deadline: deadline) {
                                        gotoAppleCalendar(date: deadline.end ?? Date())
                                    } else {
                                        addToCalendar(deadline: deadline)
                                    }
                                }
                            } else {
                                activeAlertController = .access
                            }
                            
                        
                        }
                    }
                    
                }) {
                    
                    ZStack {
                        if isAddded {
                            HStack {
                                Text(LocalizedStringKey("inCalendar"))
                                Image(systemName: "calendar")
                            }
                        } else {
                            HStack {
                                Text(LocalizedStringKey("add to calendar"))
                                Image(systemName: "calendar.badge.plus")
                            }
                        }
                    }
                    
                }
                
                Button(action: {
                    DispatchQueue.main.async {
                        medium()
                        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(named: "AccentColor")
                        activeSheetController = .share
                    }
                }) {
                    HStack {
                        Text(LocalizedStringKey("shareDeadline"))
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                
                Button(action: {
                    medium()

                    activeSheetController = .qr
                    
                }) {
                    
                    HStack {
                        Text(LocalizedStringKey("qr share"))
                        Image(systemName: "qrcode")
                    }

                }
                
            } label: {
                
                
                Image(systemName: "ellipsis.circle")
//                    .fill
                
//                    .font(.system(size: 22.5, weight: .light))
                
            }
        }
            .onReceive(timerController, perform: { _ in
                
                DispatchQueue.main.async {
                isAddded = isEventInCalendar(deadline: deadline)
                }
            })
        }
    
    
    func addToCalendar(deadline: Deadline) {
        
        
        var isCalendarCreated = false
        for calendar in calendars {
            if calendar.title == "Deadline app" {
                isCalendarCreated = true
            }
        }
        
        if isCalendarCreated == false {
            let calendar = EKCalendar(for: .event, eventStore: eventStore)
            calendar.title = "Deadline app"
            calendar.cgColor = UIColor.orange.cgColor
            
            
            guard let source = bestPossibleEKSource() else {
                return
            }
            calendar.source = source
            try! eventStore.saveCalendar(calendar, commit: true)
        }
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            if (granted) && (error == nil) {
                
                print("granted \(granted)")
                print("error \(String(describing: error))")
                
                let event: EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = deadline.name
                event.startDate = deadline.end
                event.endDate = deadline.end
    //            event.notes = "This is a note"
                event.calendar = eventStore.calendar(withIdentifier: calendarID())
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                    
                    activeAlertController = .access
                    
                }
                
                activeAlertController = .success
            } else {
                activeAlertController = .access
            }
        }
        
    }
}

func isEventInCalendar(deadline: Deadline) -> Bool {
    
    var isAdded = false
    for calendar in calendars {
        if calendar.title == "Deadline app" {

            let predicate = eventStore.predicateForEvents(
                withStart: deadline.end?.addingTimeInterval(-1) ?? Date(),
                end: deadline.end?.addingTimeInterval(1) ?? Date(),
                calendars: nil
            )
            
            let events = eventStore.events(matching: predicate)

            for event in events {
                if event.title == deadline.name && event.startDate == deadline.end && event.endDate == deadline.end {
                    isAdded = true
                }
            }
        }
    }
    return isAdded
}

func gotoAppleCalendar(date: Date) {
    let interval = date.timeIntervalSinceReferenceDate
    let url = URL(string: "calshow:\(interval)")!
//    url
    UIApplication.shared.open(url)
}

func calendarID() -> String {
    var calendarID = ""
    for calendar in calendars {
        if calendar.title == "Deadline app" {
            calendarID = calendar.calendarIdentifier
        }
    }
    return calendarID
}

func isCalendarCreated() -> Bool {
    var isCalendarCreated = false
    for calendar in calendars {
        if calendar.title == "Deadline app" {
            isCalendarCreated = true
        }
    }
    return isCalendarCreated
}

let eventStore = EKEventStore()
let calendars = eventStore.calendars(for: .event)

func bestPossibleEKSource() -> EKSource? {
    let `default` = eventStore.defaultCalendarForNewEvents?.source
    let iCloud = eventStore.sources.first(where: { $0.title == "iCloud" })
    let local = eventStore.sources.first(where: { $0.sourceType == .local })

    return `default` ?? iCloud ?? local
}

func createNewCalendar() {
    let calendar = EKCalendar(for: .event, eventStore: eventStore)
    calendar.title = "Deadline app"
    calendar.cgColor = UIColor.orange.cgColor
    
    
    guard let source = bestPossibleEKSource() else {
        return
    }
    calendar.source = source
    try! eventStore.saveCalendar(calendar, commit: true)
}

struct QRView: View {
    @ObservedObject var deadline: Deadline
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            if colorScheme == .dark {
                Color(white: 32/255)
                    .edgesIgnoringSafeArea(.all)
            }
            NavigationView {
                ZStack {
                    if colorScheme == .dark {
                        Color(white: 32/255)
                            .edgesIgnoringSafeArea(.all)
                    }
                }
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            light()
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text(LocalizedStringKey("Done"))
                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                        })
                        
                        
                    }
                })
            }
            .padding(.horizontal, 3)
            Image(uiImage: generateDeadlineQRCode(from: "\(createDeadlineURL(deadline: deadline))"))
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
        }
    }
}

enum ShareSheetController: Identifiable {
    case qr, share
    
    var id: Int {
        hashValue
    }
}

enum AlertController: Identifiable {
    case access, success
    
    var id: Int {
        hashValue
    }
}
