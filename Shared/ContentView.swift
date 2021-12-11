//
//  ContentView.swift
//  Shared
//
//  Created by Егор Мальцев on 05.03.2021.
//

import SwiftUI
import CoreData

import WidgetKit

import CloudKit

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif



enum ActiveSheet: Identifiable {
    case first, second
    
    var id: Int {
        hashValue
    }
}

struct ContentView: View {
    
    @State var activeSheet: ActiveSheet?
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Deadline.end, ascending: true)],
        animation: .default) var deadlines: FetchedResults<Deadline>
    
    let widgetController = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    
    let colors = [

        Color.init(#colorLiteral(red: 0.963261067867279, green: 0.587435245513916, blue: 0.40973594784736633, alpha: 1.0)),
        Color.init(#colorLiteral(red: 0.4112072587, green: 0.7180628777, blue: 0.5513616204, alpha: 1)),
        Color.init(#colorLiteral(red: 0.9141021370887756, green: 0.7988627552986145, blue: 0.48544591665267944, alpha: 1.0)),
        Color.init(#colorLiteral(red: 0.3944269717, green: 0.6223002672, blue: 0.9217638969, alpha: 1))
        
    ]
    
    
    @AppStorage("paschalkaController2") private var showingWhatsNew: Bool = true
    
    
    @EnvironmentObject var quickActions: QuickActionService
    
    @State var contentViewName: String?
    @State var contentViewStart: Date?
    @State var contentViewDeadline: Date?
    @State var contentViewNotifications: [Bool]?
    @State var contentViewColor: Color?
    
    @AppStorage("paschalkaController") private var showingPaschalka: Bool = false
    
    
    func deadlinesCount() -> Int {
        var ans = 0
        for deadline in deadlines {
            if deadline.done == false {
                ans += 1
            }
        }
        return ans
    }
    
    func doneDeadlinesCount() -> Int {
        var ans = 0
        for deadline in deadlines {
            if deadline.done {
                ans += 1
            }
        }
        return ans
    }
    
    
    var body: some View {
            ZStack {
                if deviceType == .iphone {
                    Rectangle().foregroundColor(Color(red: 1, green: 1, blue: 1, opacity: 0))
                        .sheet(
                            isPresented: $showingWhatsNew,
                            onDismiss: {
                                showingWhatsNew = false
                        },
                            content: {
                            NewView()
                        })
                }
                
                ZStack {
                    if !showingPaschalka {
                        
                        NavigationView {
                            ZStack {
                                if colorScheme == .dark {
                                    Color(white: 32/255)
                                        .edgesIgnoringSafeArea(.all)
                                } else {
                                    Color.white
                                        .edgesIgnoringSafeArea(.all)
                                }
                                
                                
                                if doneDeadlinesCount() != 0 && deadlinesCount() == 0 {
                                    VStack(spacing: 30) {
                                        Spacer()
                                        Spacer()
                                        Spacer()
                                        
                                        Text(LocalizedStringKey("No deadlines"))
                                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                        
                                        DoneDeadlineButton()
                                        Spacer()
                                        Spacer()
                                    }
                                    
                                } else {
                                    if deadlinesCount() == 0 {
                                        Text(LocalizedStringKey("No deadlines"))
                                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                    }
                                }
                                
                                
                                
                                
                                ScrollView(
                                    showsIndicators: false
                                ) {
                                    VStack(spacing: 14) {
                                        
                                        
                                        AllDeadlinesView()
                                            .environment(\.managedObjectContext, managedObjectContext)
                                        Spacer()
                                        
                                        if doneDeadlinesCount() != 0 && deadlinesCount() != 0 {
                                            DoneDeadlineButton()
                                        }
                                        
                                        Spacer()
                                            
                                    }
                                    .padding([.horizontal, .bottom])
                                    .padding(.top, 10)
                                    .toolbar(content: {
                                        ToolbarItem(placement: .navigationBarLeading) {
                                            Button(action: {
                                                light()
                                                activeSheet = .first
                                            }, label: {
                                                Image(systemName: "info.circle")
                                            })
                                        }
                                        ToolbarItem(placement: .navigationBarTrailing) {
                                            Button(action: {
                                                    medium()
                                                    activeSheet = .second
                                            }, label: {
                                                Image(systemName: "plus")
                                            })
                                        }
                                    })
                                    .navigationTitle(Text("Deadline"))
                                }
                                .fixFlickering()
                            }
                            
                        }
                        
                    }
                }.onReceive(widgetController, perform: { _ in
                    
                    DispatchQueue.main.async {
                    
                    
                    var deadlinesNames: [String] = []
                    var deadlinesStarts: [Date] = []
                    var deadlinesEnds: [Date] = []
                    var deadlinesColorsR: [Int] = []
                    var deadlinesColorsG: [Int] = []
                    var deadlinesColorsB: [Int] = []
                    var deadlinesIdD: [Int32] = []


                    for item in deadlines {
                        deadlinesNames.append(item.name)
                        deadlinesStarts.append(item.start ?? Date())
                        deadlinesEnds.append(item.end ?? Date())
                        deadlinesColorsR.append(Int(Color((item.color ?? UIColor.init(.accentColor))).components.red * 255))
                        deadlinesColorsG.append(Int(Color((item.color ?? UIColor.init(.accentColor))).components.green * 255))
                        deadlinesColorsB.append(Int(Color((item.color ?? UIColor.init(.accentColor))).components.blue * 255))
                        deadlinesIdD.append(item.idD)
                    }

                    UserDefaults(suiteName: "group.deadlineApp")?.set(deadlinesNames, forKey: "name")
                    UserDefaults(suiteName: "group.deadlineApp")?.set(deadlinesStarts, forKey: "start")
                    UserDefaults(suiteName: "group.deadlineApp")?.set(deadlinesEnds, forKey: "end")
                    UserDefaults(suiteName: "group.deadlineApp")?.set(deadlinesColorsR, forKey: "colorR")
                    UserDefaults(suiteName: "group.deadlineApp")?.set(deadlinesColorsG, forKey: "colorG")
                    UserDefaults(suiteName: "group.deadlineApp")?.set(deadlinesColorsB, forKey: "colorB")
                    UserDefaults(suiteName: "group.deadlineApp")?.set(deadlinesIdD, forKey: "idD")
                    
                    WidgetCenter.shared.reloadAllTimelines()
                        
                    }
                })
                
                    .sheet(item: $activeSheet, onDismiss: {
                        contentViewName = nil
                        contentViewStart = nil
                        contentViewDeadline = nil
                        contentViewColor = nil
                        contentViewNotifications = nil
                    }) { item in
                        if #available(iOS 15.0, *) {
                            switch item {
                            case .first:
                                InfoView()
                            case .second:
                                AddingView(
                                    addingName: contentViewName ?? "".trimmingCharacters(in: .whitespaces),
                                    addingStart: contentViewStart ?? Date(),
                                    addingEnd: contentViewDeadline ?? Date().addingTimeInterval(86400),
                                    addingNotification: contentViewNotifications ?? [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                                    addingColor: (contentViewColor ?? colors.randomElement())!)
                                    .environment(\.managedObjectContext, self.managedObjectContext)
                                
                            }
                        } else {
                            // Fallback on earlier versions
                        }
                    }
            }
            
            .onOpenURL { url in
                
                if url == URL(string: "deadlineAppWidget://newWidget")  {
                    
                    medium()
                    
                    activeSheet = .second
                    
                } else {
                   
                    if url.scheme == "deadlineApp" {
                        
                            contentViewName = url.valueOf("name")
                            contentViewStart =
                                Date(
                                timeIntervalSince1970: Double(Int(url.valueOf("start")!)!)
                                )
                            contentViewDeadline = Date(timeIntervalSince1970: Double(Int(url.valueOf("deadline")!)!))
                            
                            contentViewColor = Color.init(
                                red: Double(Int(url.valueOf("colorR")!)!)/Double(255),
                                green: Double(Int(url.valueOf("colorG")!)!)/Double(255),
                                blue: Double(Int(url.valueOf("colorB")!)!)/Double(255)
                            )
                    
                            medium()
                            
                            activeSheet = .second
                         
                    }
                }
                
                
            }
            .onChange(of: quickActions.action?.rawValue, perform: { value in
                if quickActions.action?.rawValue != nil {
                    medium()
                    activeSheet = .second
                }
                
            })
            .navigationViewStyle(StackNavigationViewStyle())
            .accentColor(colorScheme == .dark ? .white : Color(white: 32/255))
        
        
    }
    
}


