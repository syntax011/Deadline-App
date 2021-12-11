//
//  InfoView.swift
//  Deadline
//
//  Created by Егор Мальцев on 07.03.2021.
//

import SwiftUI
import UIKit
import StoreKit

struct HeartView: View {
    @State var timeRemaining = 0
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View  {
        Text("♥️")
            .onTapGesture(perform: {
                timeRemaining = 5
                timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            })
            .onReceive(timer, perform: { _ in
                if timeRemaining > 0 {
                    heavy()
                }
                if self.timeRemaining < 0 {
                    self.timer.upstream.connect().cancel()
                    return
                }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timer.upstream.connect().cancel()
                }
            })
    }
}

struct InfoView: View {
    @State var paschalkaController = false
    @Environment(\.openURL) var openURL
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State var showingShare = false
    @State var icon = UserDefaults.standard.bool(forKey: "icon")
    
    var body: some View {
        
            
            NavigationView {
                ZStack {
                    if colorScheme == .dark {
                        Color(white: 32/255)
                            .edgesIgnoringSafeArea(.all)
                    }
                    VStack(spacing: 15) {
                        VStack(spacing: 15) {
                            HStack(spacing: 15) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Telegram")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                    
                                   Text("@syntax_e_rr0r")
                                       .font(.system(size: 22))
                                       .fontWeight(.semibold)
                                       .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                    
                               }
                            Spacer()
                                Button(action: {
                                    
                                    #if os(iOS)
                                    medium()
                                    #endif
                                    openURL(URL(string: "https://t.me/syntax_e_rr0r")!)
                                }, label: {
                                    ZStack {
                                        Circle()
                                            .strokeBorder((colorScheme == .dark ? Color.white : Color(white: 32/255)), lineWidth: 0.5)
                                            .frame(width: 45, height: 45)
                                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                            
                                        
                                        Image(systemName: "paperplane")
                                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                            .font(.system(size: 21, weight: .regular))
                                            .padding([.top, .trailing], 2.25)
                                        
                                    }
                                })
                                
                           }.padding(.horizontal)
                            HStack(alignment: .top) {
                                Text(LocalizedStringKey("Otzivi"))
                                    .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                Spacer()
                                Image(systemName: "arrow.turn.right.up")
                                    .font(.system(size: 22, weight: .light))
                                    .padding(.horizontal, 10)
                                    .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                            }.padding(.horizontal)
                        }.padding()
                        
                        
                        
                        
                        VStack(spacing: 0) {
                            
                            VStack {
                                
                                HStack {
                                    Text(LocalizedStringKey("App icon"))
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                    Spacer()
                                    
                                    Menu {
                                        Picker(selection: $icon, label: Text("Sorting options")) {
                                            
                                            HStack {
                                                Text("Light")
                                                Image("iconLight")
                                                    .cornerRadius(10)
                                            }.tag(false)
                                            
                                            HStack{
                                                Text("Dark")
                                                Image("iconDark")
                                                    .cornerRadius(10)
                                            }.tag(true)
                                            
                                        }
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .strokeBorder((colorScheme == .dark ? Color.white : Color(white: 32/255)), lineWidth: 0.5)
                                                .frame(width: 45, height: 45)
                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                            
                                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                                .strokeBorder((colorScheme == .dark ? Color.white : Color(white: 32/255)), lineWidth: 0.4)
                                                .frame(width: 21, height: 21)
                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
//                                                .cornerRadius(5)
                                            Image(icon ? "iconDark" : "iconLight")
                                                .resizable()
                                                .frame(width: 20.5, height: 20.5)
                                                .clipShape(
                                                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                                                )
                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                        }
                                    }
                                    .onChange(of: icon, perform: { value in
                                        
                                        
                                        medium()
                                        
                                        UIView.appearance().tintColor = UIColor(named: "AccentColor")
                                        
                                        if value == false {
                                            UIApplication.shared.setAlternateIconName("iconLight")
                                            UserDefaults.standard.set(false, forKey: "icon")
                                        } else {
                                            UIApplication.shared.setAlternateIconName("iconDark")
                                            UserDefaults.standard.set(true, forKey: "icon")
                                        }
                                    })
                                    
                                    
                                    
                                }
                                .padding(.horizontal)
                            }.padding()
                            
                            
                            VStack {
                                HStack {
                                    Text(LocalizedStringKey("shareApp"))
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                    Spacer()
                                    Button(action: {
                                        DispatchQueue.main.async {
                                        #if os(iOS)
                                        medium()
                                        #endif
                                        
                                        self.showingShare = true
                                        }
                                        
                                    }, label: {
                                        ZStack {
                                            Circle()
                                                .strokeBorder((colorScheme == .dark ? Color.white : Color(white: 32/255)), lineWidth: 0.5)
                                                .frame(width: 45, height: 45)
                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                
                                            Image(systemName: "square.and.arrow.up")
                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                                .font(.system(size: 21, weight: .regular))
                                                .padding(.bottom, 2.5)
                                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                        }
                                    })
                                    
                                    .sheet(isPresented: $showingShare,
                                           content: {
                                            ZStack {
                                                if colorScheme == .dark {
                                                    Color(white: 32/255)
                                                        .edgesIgnoringSafeArea(.all)
                                                }
                                                ActivityView(
                                                    activityItems: [NSURL(string: "https://apps.apple.com/ru/app/deadline-app/id1557048705")!] as [Any], applicationActivities: nil)
                                                    .edgesIgnoringSafeArea(.all)
                                               }
                                            }
                                        )
                                }
                                .padding(.horizontal)
                            }.padding()
                            
                            
                            
                            
                            
                            Settings()
                        }
                        
                        
                        
                        
                        Spacer()
                        VStack(spacing: 5) {
                            Text("Deadline App. v 2.0.4")
                                .foregroundColor(colorScheme == .dark ? Color.white : Color(white: 32/255))
                                .fontWeight(.bold)
                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                            HStack(spacing: 0) {
                                Text("Developed with ")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(white: 32/255))
                                    .fontWeight(.light)
                                    .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                HeartView()
                                Text(".")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color(white: 32/255))
                                    .fontWeight(.light)
                                    .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                            }
                            .onLongPressGesture(perform: {
                                let generator = UIImpactFeedbackGenerator(style: .rigid)
                                generator.prepare()
                                generator.impactOccurred()
                                paschalkaController.toggle()
                            })
                            
                                
                        }
                    }
                    .padding(.bottom, 25)
                    
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
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .accentColor(colorScheme == .dark ? .white : Color(white: 32/255))
        
            .fullScreenCover(isPresented: $paschalkaController, content: {
                PaschalkaView()
            })
        
        
            
        
        
    }
    
}

struct ActivityView: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        
        /*
        activityViewController.view.tintColor = UIColor(white: 32/255)
        activityViewController.editButtonItem.tintColor = UIColor(white: 32/255)
        activityViewController.editButtonItem.customView?.backgroundColor = UIColor.red
        */
        
//        activityViewController.ap
//        activityViewController.editButtonItem.setValue(UIColor.red, forKey: "titleTextColor")
 
        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                presentationMode.wrappedValue.dismiss()
            }
//            print(success ? "SUCCESS!" : "FAILURE")
        }
        
        return activityViewController
        
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {
        
    }
    
}


