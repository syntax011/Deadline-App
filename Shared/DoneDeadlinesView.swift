//
//  DoneDeadlinesView.swift
//  Deadline (iOS)
//
//  Created by Егор Мальцев on 23.11.2021.
//

import SwiftUI
import WidgetKit


struct DoneDeadlineItem: View {
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
    
    @State var showAlert = false
    
    var body: some View {
        
        ZStack {
        
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
        
            
            
            if showAlert {
                RealDeleteAlertControlView(
                    showAlert: $showAlert,
                    deadline: deadline
                )
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                    medium()
                    
                    
                    for item in 0..<17 {
                        if deadline.notifications![item] == true {
                            var nextTriggerDate = Calendar.current.date(byAdding: .second, value: 0, to: Date())!
                            switch item {
                            case 0:
                                nextTriggerDate = Calendar.current.date(byAdding: .second, value: 0, to: (deadline.end?.zeroNanoseconds!)!)!
                            case 1:
                                nextTriggerDate = Calendar.current.date(byAdding: .month, value: -1, to: (deadline.end?.zeroNanoseconds!)!)!
                            case 2:
                                nextTriggerDate = Calendar.current.date(byAdding: .day, value: -14, to: (deadline.end?.zeroNanoseconds!)!)!
                            case 3:
                                nextTriggerDate = Calendar.current.date(byAdding: .day, value: -7, to: (deadline.end?.zeroNanoseconds!)!)!
                            case 4:
                                nextTriggerDate = Calendar.current.date(byAdding: .day, value: -3, to: (deadline.end?.zeroNanoseconds!)!)!
                            case 5:
                                nextTriggerDate = Calendar.current.date(byAdding: .day, value: -2, to: (deadline.end?.zeroNanoseconds!)!)!
                            case 6:
                                nextTriggerDate = Calendar.current.date(byAdding: .hour, value: -24, to: (deadline.end?.zeroNanoseconds!)!)!
                            case 7:
                                nextTriggerDate = Calendar.current.date(byAdding: .hour, value: -12, to: (deadline.end?.zeroNanoseconds!)!)!
                            case 8:
                                nextTriggerDate = Calendar.current.date(byAdding: .hour, value: -6, to: (deadline.end?.zeroNanoseconds!)!)!
                            case 9:
                                nextTriggerDate = Calendar.current.date(byAdding: .hour, value: -3, to: (deadline.end?.zeroNanoseconds!)!)!
                            case 10:
                                nextTriggerDate = Calendar.current.date(byAdding: .hour, value: -2, to: (deadline.end?.zeroNanoseconds!)!)!
                            case 11:
                                nextTriggerDate = Calendar.current.date(byAdding: .hour, value: -1, to: (deadline.end?.zeroNanoseconds!)!)!
                            case 12:
                                nextTriggerDate = Calendar.current.date(byAdding: .minute, value: -30, to: (deadline.end?.zeroNanoseconds!)!)!
                            case 13:
                                nextTriggerDate = Calendar.current.date(byAdding: .minute, value: -15, to: (deadline.end?.zeroNanoseconds!)!)!
                            case 14:
                                nextTriggerDate = Calendar.current.date(byAdding: .minute, value: -10, to: (deadline.end?.zeroNanoseconds!)!)!
                            case 15:
                                nextTriggerDate = Calendar.current.date(byAdding: .minute, value: -5, to: (deadline.end?.zeroNanoseconds!)!)!
                            case 16:
                                nextTriggerDate = Calendar.current.date(byAdding: .minute, value: -1, to: (deadline.end?.zeroNanoseconds!)!)!
                            default:
                                nextTriggerDate = Calendar.current.date(byAdding: .minute, value: 0, to: (deadline.end?.zeroNanoseconds!)!)!
                            }
                            
                            let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: nextTriggerDate)
                            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
                            let content = UNMutableNotificationContent()
                            content.sound = .default
                            
                            switch item {
                            case 0:
                                content.body = NSLocalizedString("Deadline expired", comment: "")
                            case 1:
                                content.body = NSLocalizedString("1 month left before the deadline", comment: "")
                            case 2:
                                content.body = NSLocalizedString("2 weeks left before the deadline", comment: "")
                            case 3:
                                content.body = NSLocalizedString("1 week left before the deadline", comment: "")
                            case 4:
                                content.body = NSLocalizedString("3 days left before the deadline", comment: "")
                            case 5:
                                content.body = NSLocalizedString("2 days left before the deadline", comment: "")
                            case 6:
                                content.body = NSLocalizedString("24 hours left before the deadline", comment: "")
                            case 7:
                                content.body = NSLocalizedString("12 hours left before the deadline", comment: "")
                            case 8:
                                content.body = NSLocalizedString("6 hours left before the deadline", comment: "")
                            case 9:
                                content.body = NSLocalizedString("3 hours left before the deadline", comment: "")
                            case 10:
                                content.body = NSLocalizedString("2 hours left before the deadline", comment: "")
                            case 11:
                                content.body = NSLocalizedString("1 hour left before the deadline", comment: "")
                            case 12:
                                content.body = NSLocalizedString("30 minutes left before the deadline", comment: "")
                            case 13:
                                content.body = NSLocalizedString("15 minutes left before the deadline", comment: "")
                            case 14:
                                content.body = NSLocalizedString("10 minutes left before the deadline", comment: "")
                            case 15:
                                content.body = NSLocalizedString("5 minutes left before the deadline", comment: "")
                            case 16:
                                content.body = NSLocalizedString("1 minute left before the deadline", comment: "")
                            default:
                                content.body = NSLocalizedString("Deadline expired", comment: "")
                            }
                            
                            
                            content.title = "\(deadline.name.trimmingCharacters(in: .whitespaces))"


                            let req = UNNotificationRequest(identifier: "\(deadline.idD)\(item)", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
                        }
                    }
                    
                    
                    deadline.done = false
                    
                    do {
                        try managedObjectContext.save()
                    } catch {
                        print("OOPS…")
                    }
                    
                    WidgetCenter.shared.reloadAllTimelines()
                    
                    
                }
            }) {
                HStack {
                    Text(LocalizedStringKey("Восстановаить"))
                    Image(systemName: "arrow.turn.right.up")
                }
            }
            
            Button(action: {
                medium()
                showAlert.toggle()
//                deleteActionSheet()
            }) {
                HStack {
                    Text(LocalizedStringKey("Delete"))
                    Image(systemName: "trash")
                }
            }
            
            
            
            
            
            
//            Button(action: {
//                medium()
//                withAnimation {
//                    DispatchQueue.main.async {
//                        deadline.isPinned.toggle()
//                        do {
//                            try managedObjectContext.save()
//                        } catch {
//                            print("OOPS…")
//                        }
//                    }
//                }
//            }) {
//                HStack {
//                    Text(deadline.isPinned ? LocalizedStringKey("Unpin") : LocalizedStringKey("Pin"))
//                    Image(systemName: deadline.isPinned ? "mappin.slash" : "mappin")
//                }
//            }
            
            
            
            
            
            
            
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

struct DoneDeadlineButton: View {
    @Environment(\.colorScheme) var colorScheme
    @State var tapController = false
    var body: some View {
        Button(action: {
            light()
            tapController.toggle()
        }, label: {
            ZStack {
                Circle()
                    .frame(width: 60, height: 60)
                    .foregroundColor(colorScheme == .dark ?
                                 Color(white: 44/255) : Color(white: 245/255))
                Image(systemName: "archivebox")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
            }
        })
        
            .padding(50)
            .sheet(isPresented: $tapController, onDismiss: {}, content: {
                DoneDeadlinesView()
            })
        
            
        
    }
}

struct DoneDeadlinesView: View {
    
    @State var showAlert: Bool = false
    
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Deadline.end, ascending: true)],
        animation: .default) var deadlines: FetchedResults<Deadline>
    
    @State var deleteController = false
    
    let deleteText = NSLocalizedString("Delete", comment: "")
    let cancelText = NSLocalizedString("Cancel", comment: "")
    let titleText = NSLocalizedString("Do you really want to delete the deadline", comment: "")
    
    var ipadMacConfig = {
        IpadAndMacConfiguration(anchor: nil, arrowEdge: nil)
    }()
    
    
    var body: some View {
        NavigationView {
            ZStack {
                if colorScheme == .dark {
                    Color(white: 32/255)
                        .edgesIgnoringSafeArea(.all)
                }
                ScrollView(showsIndicators: false, content: {
                    VStack(spacing: 14) {
                        VStack(spacing: 14) {
                            ForEach(deadlines, id: \.self) { deadline in
                                if deadline.done {
                                    DoneDeadlineItem(
                                        year: raznitsa(deadline: deadline, type: "year"),
                                        month: raznitsa(deadline: deadline, type: "month"),
                                        day: raznitsa(deadline: deadline, type: "day"),
                                        hour: raznitsa(deadline: deadline, type: "hour"),
                                        minute: raznitsa(deadline: deadline, type: "minute"),
                                        second: raznitsa(deadline: deadline, type: "second"),
                                        deadline: deadline,
                                        showingExpired: (Float((deadline.end ?? Date()).timeIntervalSince(Date())) <= 0)
                                    )
                                }
                                
                            }
                        }
                            
                        .padding([.horizontal, .bottom])
//                            .padding(.top, 10)
                        .padding(.top, 20)
                        
                        
                        
                        Spacer()
                        
                        
                        Button(action: {
                            light()
                            showAlert.toggle()
                            
                        }, label: {
                            ZStack {
                                Circle()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(colorScheme == .dark ?
                                                 Color(white: 44/255) : Color(white: 245/255))
                                Image(systemName: "trash")
                                    .font(.system(size: 22, weight: .medium))
                                    .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                            }
                        })
                        
                            .padding(.vertical, 50)
                            
                        
                        Spacer()
                        Spacer()
                        
                    }
                    
                    
                })
                    
                    .fixFlickering()
                
                
                if showAlert {
                    DeleteAlertControlView(
                        showAlert: $showAlert,
                        deadline: getDeadline()!
                        
                    )
                }
                
            }
            .toolbar(content: {
                Button(action: {
                    
                    #if os(iOS)
                    light()
                    #endif
                    self.presentationMode.wrappedValue.dismiss()
                    
                }, label: {
                    Text(LocalizedStringKey("Done"))
                })
            })
            .navigationTitle(Text("Выполненные"))
            .navigationBarTitleDisplayMode(.inline)
        }
        
        //перевести
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(colorScheme == .dark ? .white : Color(white: 32/255))
        
    }
    
    
    func getDeadline() -> Deadline? {
        
        var colors: [Deadline] = []
        
        for deadline in deadlines {
            if deadline.done {
                colors.append(deadline)
            }
        }
        var counts = [Deadline: Int]()

        colors.forEach { counts[$0 as! Deadline] = (counts[$0] ?? 0) + 1 }

        
        // Find the most frequent value and its count with max(by:)
        if let (value, count) = counts.max(by: {$0.1 < $1.1}) {
            return value
        } else {
            return nil
        }
        
    }
    
    
    func deleteFunc() {
        
        
        let alertVC = UIAlertController(title: titleText, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: deleteText, style: .default) { (action: UIAlertAction) in
            
            DispatchQueue.main.async {
            
                for deadline in deadlines {
                    if deadline.done {
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
                            
                        }
                        
                        presentationMode.wrappedValue.dismiss()
                        
                        
                        
                        
                    }
                }
                
            }
            
            
        }
        let cancelAction = UIAlertAction(title: cancelText, style: .default) { (action: UIAlertAction) in
            
        }
        
        deleteAction.setValue(UIColor(.white
//            Color(deadline.color ?? .white)
        ), forKey: "titleTextColor")
        cancelAction.setValue(UIColor(named: "AccentColor"), forKey: "titleTextColor")
        
        alertVC.addAction(deleteAction)
        alertVC.addAction(cancelAction)
        
        
        
        let viewController = UIApplication.shared.windows.first!.rootViewController!
        viewController.present(alertVC, animated: true, completion: nil)
        
        
        
        
        light()
        
    }
}

/*
struct DoneDeadlinesView_Previews: PreviewProvider {
    static var previews: some View {
        DoneDeadlinesView()
    }
}
 */
