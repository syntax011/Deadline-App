//
//  File.swift
//  Deadline
//
//  Created by Егор Мальцев on 05.03.2021.
//

import Foundation
import SwiftUI
import CoreData

import WidgetKit

import UserNotifications



func areNotificationsEnabled() -> Bool {
    guard let settings = UIApplication.shared.currentUserNotificationSettings else {
        return false
    }
    return settings.types.intersection([.alert, .badge, .sound]).isEmpty != true
}

struct ColorsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @Binding var choosenColor: Color
    var body: some View {
        NavigationView {
            
            ZStack {
                if colorScheme == .dark {
                    Color(white: 32/255)
                        .edgesIgnoringSafeArea(.all)
                }
                VStack(spacing: 20) {
                    Spacer()
                    HStack(spacing: 20) {
                        Spacer()
                        Button(action: {
                            light()
                            choosenColor = Color.init(red: 246/255, green: 150/255, blue: 104/255)
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Circle()
                                .foregroundColor(Color.init(red: 246/255, green: 150/255, blue: 104/255))
                                .frame(width: 85, height: 85)
                        })
                        Button(action: {
                            light()
                            choosenColor = Color.init(red: 101/255, green: 159/255, blue: 235/255)
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Circle()
                                .foregroundColor(Color.init(red: 101/255, green: 159/255, blue: 235/255))
                                .frame(width: 85, height: 85)
                        })
                        Button(action: {
                            light()
                            choosenColor = Color.init(red: 106/255, green: 183/255, blue: 141/255)
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Circle()
                                .foregroundColor(Color.init(red: 106/255, green: 183/255, blue: 141/255))
                                .frame(width: 85, height: 85)
                        })
                        
                        Spacer()
                    }
                    HStack(spacing: 20) {
                        Spacer()
                        Button(action: {
                            light()
                            choosenColor = Color.init(red: 202/255, green: 223/255, blue: 115/255)
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Circle()
                                .foregroundColor(Color.init(red: 202/255, green: 223/255, blue: 115/255))
                                .frame(width: 85, height: 85)
                        })
                        
                        Button(action: {
                            light()
                            choosenColor = Color.init(red: 255/255, green: 140/255, blue: 190/255)
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Circle()
                                .foregroundColor(Color.init(red: 255/255, green: 140/255, blue: 190/255))
                                .frame(width: 85, height: 85)
                        })
                        
                        Button(action: {
                            light()
                            choosenColor = Color.init(red: 232/255, green: 204/255, blue: 124/255)
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Circle()
                                .foregroundColor(Color.init(red: 232/255, green: 204/255, blue: 124/255))
                                .frame(width: 85, height: 85)
                        })
                        Spacer()
                    }
                    HStack(spacing: 20) {
                        Spacer()
                        
                       
                        
                        Button(action: {
                            light()
                            choosenColor = Color.init(red: 203/255, green: 151/255, blue: 132/255)
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Circle()
                                .foregroundColor(Color.init(red: 203/255, green: 151/255, blue: 132/255))
    //                            .foregroundColor(Color.init(#colorLiteral(red: 0, green: 0.4509803922, blue: 0.6666666667, alpha: 1)))
                                .frame(width: 85, height: 85)
                        })
                        
                        Button(action: {
                            light()
                            choosenColor = Color.init(red: 114/255, green: 206/255, blue: 200/255)
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Circle()
                                .foregroundColor(Color.init(red: 114/255, green: 206/255, blue: 200/255))
                                .frame(width: 85, height: 85)
                        })
                        Button(action: {
                            light()
                            choosenColor = Color.init(red: 192/255, green: 171/255, blue: 212/255)
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Circle()
                                .foregroundColor(Color.init(red: 192/255, green: 171/255, blue: 212/255))
                                .frame(width: 85, height: 85)
                        })
                        Spacer()
                    }
                    Spacer()
                }
            }
            
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        light()

                        presentationMode.wrappedValue.dismiss()
                        
                    }, label: {
                        Text(LocalizedStringKey("Done"))
                    })
                }
            })
            .navigationTitle(Text(LocalizedStringKey("Color")))
           
        } .accentColor(colorScheme == .dark ? .white : Color(white: 32/255))
    }
}

struct NotificationView: View {
    
    let title = NSLocalizedString("Notifications", comment: "")
    @Binding var notifications: [Bool]
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @State var notificationsEnabled: Bool
    let notificationControllerEnabled = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        
        NavigationView {
            ZStack {
                if colorScheme == .dark {
                    Color(red: 32/255, green: 32/255, blue: 32/255)
                        .edgesIgnoringSafeArea(.all)
                }
            
                VStack {
                    if !notificationsEnabled {
                        VStack {
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
                        }
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 11) {
                                VStack(spacing: 11) {
                                    Button(action: {
                                        light()
                                        notifications[0].toggle()
                                    }, label: {
                                        ZStack {
                                           
                                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                                .frame(height: 45)
                                            HStack {
                                                Text(LocalizedStringKey("at time"))
                                                Spacer()
                                                Image(systemName: notifications[0] ? "checkmark.circle.fill" : "plus.circle")
                                                    .font(.system(size: 25, weight: .thin))
                                                    
                                            }.padding()
                                            
                                                
                                        }.frame(height: 45)
                                    })
                                    
                                    Button(action: {
                                        light()
                                        notifications[1].toggle()
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                                .frame(height: 45)
                                            HStack {
                                                Text(LocalizedStringKey("1 month"))
                                                Spacer()
                                                Image(systemName: notifications[1] ? "checkmark.circle.fill" : "plus.circle")
                                                    .font(.system(size: 25, weight: .thin))
                                                    
                                            }.padding()
                                            
                                                
                                        }.frame(height: 45)
                                    })
                                    
                                    Button(action: {
                                        light()
                                        notifications[2].toggle()
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                                .frame(height: 45)
                                            HStack {
                                                Text(LocalizedStringKey("2 weeks"))
                                                Spacer()
                                                Image(systemName: notifications[2] ? "checkmark.circle.fill" : "plus.circle")
                                                    .font(.system(size: 25, weight: .thin))
                                                    
                                            }.padding()
                                            
                                                
                                        }.frame(height: 45)
                                    })
                                    
                                    Button(action: {
                                        light()
                                        notifications[3].toggle()
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                                .frame(height: 45)
                                            HStack {
                                                Text(LocalizedStringKey("7 days"))
                                                Spacer()
                                                Image(systemName: notifications[3] ? "checkmark.circle.fill" : "plus.circle")
                                                    .font(.system(size: 25, weight: .thin))
                                                    
                                            }.padding()
                                            
                                                
                                        }.frame(height: 45)
                                    })
                                    
                                    Button(action: {
                                        light()
                                        notifications[4].toggle()
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                                .frame(height: 45)
                                            HStack {
                                                Text(LocalizedStringKey("3 days"))
                                                Spacer()
                                                Image(systemName: notifications[4] ? "checkmark.circle.fill" : "plus.circle")
                                                    .font(.system(size: 25, weight: .thin))
                                                    
                                            }.padding()
                                            
                                                
                                        }.frame(height: 45)
                                    })
                                    
                                    Button(action: {
                                        light()
                                        notifications[5].toggle()
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                                .frame(height: 45)
                                            HStack {
                                                Text(LocalizedStringKey("2 days"))
                                                Spacer()
                                                Image(systemName: notifications[5] ? "checkmark.circle.fill" : "plus.circle")
                                                    .font(.system(size: 25, weight: .thin))
                                                    
                                            }.padding()
                                            
                                                
                                        }.frame(height: 45)
                                    })
                                    
                                    Button(action: {
                                        light()
                                        notifications[6].toggle()
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                                .frame(height: 45)
                                            HStack {
                                                Text(LocalizedStringKey("24 hours"))
                                                Spacer()
                                                Image(systemName: notifications[6] ? "checkmark.circle.fill" : "plus.circle")
                                                    .font(.system(size: 25, weight: .thin))
                                                    
                                            }.padding()
                                            
                                                
                                        }.frame(height: 45)
                                    })
                                    
                                    Button(action: {
                                        light()
                                        notifications[7].toggle()
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                                .frame(height: 45)
                                            HStack {
                                                Text(LocalizedStringKey("12 hours"))
                                                Spacer()
                                                Image(systemName: notifications[7] ? "checkmark.circle.fill" : "plus.circle")
                                                    .font(.system(size: 25, weight: .thin))
                                                    
                                            }.padding()
                                            
                                                
                                        }.frame(height: 45)
                                    })
                                    
                                    Button(action: {
                                        light()
                                        notifications[8].toggle()
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                                .frame(height: 45)
                                            HStack {
                                                Text(LocalizedStringKey("6 hours"))
                                                Spacer()
                                                Image(systemName: notifications[8] ? "checkmark.circle.fill" : "plus.circle")
                                                    .font(.system(size: 25, weight: .thin))
                                                    
                                            }.padding()
                                            
                                                
                                        }.frame(height: 45)
                                    })
                                    Button(action: {
                                        light()
                                        notifications[9].toggle()
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                                .frame(height: 45)
                                            HStack {
                                                Text(LocalizedStringKey("3 hours"))
                                                Spacer()
                                                Image(systemName: notifications[9] ? "checkmark.circle.fill" : "plus.circle")
                                                    .font(.system(size: 25, weight: .thin))
                                                    
                                            }.padding()
                                            
                                                
                                        }.frame(height: 45)
                                    })
                                    
                                }
                                Button(action: {
                                    light()
                                    notifications[10].toggle()
                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                            .frame(height: 45)
                                        HStack {
                                            Text(LocalizedStringKey("2 hours"))
                                            Spacer()
                                            Image(systemName: notifications[10] ? "checkmark.circle.fill" : "plus.circle")
                                                .font(.system(size: 25, weight: .thin))
                                                
                                        }.padding()
                                    }.frame(height: 45)
                                })
                                Button(action: {
                                    light()
                                    notifications[11].toggle()
                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                            .frame(height: 45)
                                        HStack {
                                            Text(LocalizedStringKey("1 hour"))
                                            Spacer()
                                            Image(systemName: notifications[11] ? "checkmark.circle.fill" : "plus.circle")
                                                .font(.system(size: 25, weight: .thin))
                                                
                                        }.padding()
                                    }.frame(height: 45)
                                })
                                Button(action: {
                                    light()
                                    notifications[12].toggle()
                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                            .frame(height: 45)
                                        HStack {
                                            Text(LocalizedStringKey("30 minutes"))
                                            Spacer()
                                            Image(systemName: notifications[12] ? "checkmark.circle.fill" : "plus.circle")
                                                .font(.system(size: 25, weight: .thin))
                                                
                                        }.padding()
                                        
                                            
                                    }.frame(height: 45)
                                })
                                Button(action: {
                                    light()
                                    notifications[13].toggle()
                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                            .frame(height: 45)
                                        HStack {
                                            Text(LocalizedStringKey("15 minutes"))
                                            Spacer()
                                            Image(systemName: notifications[13] ? "checkmark.circle.fill" : "plus.circle")
                                                .font(.system(size: 25, weight: .thin))
                                                
                                        }.padding()
                                        
                                            
                                    }.frame(height: 45)
                                })
                                Button(action: {
                                    light()
                                    notifications[14].toggle()
                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                            .frame(height: 45)
                                        HStack {
                                            Text(LocalizedStringKey("10 minutes"))
                                            Spacer()
                                            Image(systemName: notifications[14] ? "checkmark.circle.fill" : "plus.circle")
                                                .font(.system(size: 25, weight: .thin))
                                                
                                        }.padding()
                                    }.frame(height: 45)
                                })
                                Button(action: {
                                    light()
                                    notifications[15].toggle()
                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                            .frame(height: 45)
                                        HStack {
                                            Text(LocalizedStringKey("5 minutes"))
                                            Spacer()
                                            Image(systemName: notifications[15] ? "checkmark.circle.fill" : "plus.circle")
                                                .font(.system(size: 25, weight: .thin))
                                                
                                        }.padding()
                                    }.frame(height: 45)
                                })
                                Button(action: {
                                    light()
                                    notifications[16].toggle()
                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                            .frame(height: 45)
                                        HStack {
                                            Text(LocalizedStringKey("1 minute"))
                                            Spacer()
                                            Image(systemName: notifications[16] ? "checkmark.circle.fill" : "plus.circle")
                                                .font(.system(size: 25, weight: .thin))
                                                
                                        }.padding()
                                        
                                            
                                    }.frame(height: 45)
                                })
                                Spacer()
                            }.padding()
                        }
                    }
                }
            }
            .onReceive(notificationControllerEnabled, perform: { _ in
                
//                UIView.appearance().tintColor = UIColor(named: "AccentColor")
                
                DispatchQueue.main.async {
                notificationsEnabled = areNotificationsEnabled()
                }
            })
            .toolbar(content: {
                     Button(action: {
                         
                         light()
                         
                         self.presentationMode.wrappedValue.dismiss()
                     }, label: {
                         Text(LocalizedStringKey("Done"))
                     })
                 })
            .navigationTitle("\(title) (\(notifications.filter { $0 == true }.count))")
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(colorScheme == .dark ? Color.white : Color(white: 32/255))
        
    }
}

struct DeadlineTextField: UIViewRepresentable {
    @Binding public var isFirstResponder: Bool
    @Binding public var text: String
    
    let placeholderTitle = NSLocalizedString("Name", comment: "")

    public var configuration = { (view: UITextField) in }

    public init(text: Binding<String>, isFirstResponder: Binding<Bool>, configuration: @escaping (UITextField) -> () = { _ in }) {
        self.configuration = configuration
        self._text = text
        self._isFirstResponder = isFirstResponder
    }

    public func makeUIView(context: Context) -> UITextField {
        let view = UITextField()
        view.autocorrectionType = UITextAutocorrectionType.no
        view.placeholder = placeholderTitle
        view.addTarget(context.coordinator, action: #selector(Coordinator.textViewDidChange), for: .editingChanged)
        view.delegate = context.coordinator
        return view
    }

    public func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        switch isFirstResponder {
        case true: uiView.becomeFirstResponder()
        case false: uiView.resignFirstResponder()
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator($text, isFirstResponder: $isFirstResponder)
    }

    public class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>
        var isFirstResponder: Binding<Bool>

        init(_ text: Binding<String>, isFirstResponder: Binding<Bool>) {
            self.text = text
            self.isFirstResponder = isFirstResponder
        }

        @objc public func textViewDidChange(_ textField: UITextField) {
            self.text.wrappedValue = textField.text ?? ""
        }

        public func textFieldDidBeginEditing(_ textField: UITextField) {
            self.isFirstResponder.wrappedValue = true
        }

        public func textFieldDidEndEditing(_ textField: UITextField) {
            self.isFirstResponder.wrappedValue = false
        }
    }
}

@available(iOS 15.0, *)
struct AddingView: View {
    @State var addingName: String
    @State var addingStart: Date
    @State var addingEnd: Date
    @State var addingNotification: [Bool]
    
    
    @State var addingColor: Color
    
    @State var showingNotification = false
    @State var showingColor = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.colorScheme) var colorScheme
#if os(iOS)
    @FocusState private var isFocued: Bool
#endif
    @State var isFirstResponder = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if colorScheme == .dark {
                    Color(white: 32/255)
                        .edgesIgnoringSafeArea(.all)
                }
            VStack(spacing: 11) {
                
                if #available(iOS 15.0, *) {
                    TextField(LocalizedStringKey("Name"), text: $addingName)
                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                        .frame(height: 50)

                        )
#if os(iOS)
                        .focused($isFocued)
#endif
                        
                    
                        .disableAutocorrection(true)
                        
                } else {
                    GeometryReader { geometry in
                        DeadlineTextField(text: $addingName, isFirstResponder: $isFirstResponder)
                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                            .frame(height: 50)

                            )
                            .frame(height: 50)

                    }
                }
                
                
               
                
                
                
                
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                    .frame(height: 50)
                DatePicker(selection: $addingStart, in: ...Date(), label: {
                    Text(LocalizedStringKey("Start"))
                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                }).accentColor(colorScheme == .dark ? Color.secondary : Color.primary)
                .padding()
            }.frame(height: 50)
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                    .frame(height: 50)
                DatePicker(selection: $addingEnd, in: Date().addingTimeInterval(60)..., label: {
                    Text(LocalizedStringKey("deadline"))
                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                }).accentColor(colorScheme == .dark ? Color.secondary : Color.primary)
                .padding()
            }.frame(height: 50)
            HStack(spacing: 11) {
                Button(action: {
                    hideKeyboard()
                    showingColor.toggle()
                }, label: {
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                            .frame(width: 135, height: 45)
                        
                        HStack {
                            Text(LocalizedStringKey("Color"))
                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                            Spacer()
                            
                            Image(systemName: "circle.fill")
                                .font(.system(size: 25, weight: .thin))
//                            Circle()
//                                .frame(width: 25, height: 25)
                                .foregroundColor(addingColor)
                            
                                
                            
                        }.padding()

                    }.frame(width: 135, height: 45)
                })
                .sheet(isPresented: $showingColor, content: {
                    ColorsView(choosenColor: $addingColor)
                })
                
                Button(action: {
                    hideKeyboard()
                    showingNotification.toggle()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                            .frame(height: 45)
                        HStack {
                            Text(LocalizedStringKey("Notifications"))
                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                            Spacer()
                            if addingNotification.filter { $0 == true }.count == 0 {
                                Image(systemName:  "plus.circle")
                                    .font(.system(size: 25, weight: .thin))
                                    .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                            } else {
                                Image(systemName:  "\(addingNotification.filter { $0 == true }.count).circle.fill")
                                    .font(.system(size: 25, weight: .thin))
                                    .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                            }
                        }.padding()
                        

                    }.frame(height: 45)
                })
                .sheet(isPresented: $showingNotification, content: {
                    NotificationView(notifications: $addingNotification, notificationsEnabled: areNotificationsEnabled())
                })
                
            }
            Spacer()
            
            Button(action: {
                
                DispatchQueue.main.async {
                guard !(addingName.trimmingCharacters(in: .whitespaces) == "") else {
                    #if os(iOS)
                    let generator = UIImpactFeedbackGenerator(style: .rigid)
                    generator.prepare()
                    generator.impactOccurred()
                    #endif
                    
                    return
                }
                #if os(iOS)
                medium()
                #endif
                
                hideKeyboard()
                
                let deadline = Deadline(context: managedObjectContext)
                deadline.name = self.addingName.trimmingCharacters(in: .whitespaces)
                deadline.start = addingStart.zeroNanoseconds
                deadline.end = addingEnd.zeroNanoseconds
                deadline.color = UIColor(addingColor)
                
                deadline.notifications = addingNotification
                
                
                let idB = UserDefaults.standard.integer(forKey: "idD")
                deadline.idD = Int32(idB)
                UserDefaults.standard.set(idB + 1, forKey: "idD")
                
                
                
                do {
                    try self.managedObjectContext.save()
                } catch {
                    print("OOPS...")
                }
                
                for item in 0..<17 {
                    if addingNotification[item] == true {
                        var nextTriggerDate = Calendar.current.date(byAdding: .second, value: 0, to: Date())!
                        switch item {
                        case 0:
                            nextTriggerDate = Calendar.current.date(byAdding: .second, value: 0, to: addingEnd.zeroNanoseconds!)!
                        case 1:
                            nextTriggerDate = Calendar.current.date(byAdding: .month, value: -1, to: addingEnd.zeroNanoseconds!)!
                        case 2:
                            nextTriggerDate = Calendar.current.date(byAdding: .day, value: -14, to: addingEnd.zeroNanoseconds!)!
                        case 3:
                            nextTriggerDate = Calendar.current.date(byAdding: .day, value: -7, to: addingEnd.zeroNanoseconds!)!
                        case 4:
                            nextTriggerDate = Calendar.current.date(byAdding: .day, value: -3, to: addingEnd.zeroNanoseconds!)!
                        case 5:
                            nextTriggerDate = Calendar.current.date(byAdding: .day, value: -2, to: addingEnd.zeroNanoseconds!)!
                        case 6:
                            nextTriggerDate = Calendar.current.date(byAdding: .hour, value: -24, to: addingEnd.zeroNanoseconds!)!
                        case 7:
                            nextTriggerDate = Calendar.current.date(byAdding: .hour, value: -12, to: addingEnd.zeroNanoseconds!)!
                        case 8:
                            nextTriggerDate = Calendar.current.date(byAdding: .hour, value: -6, to: addingEnd.zeroNanoseconds!)!
                        case 9:
                            nextTriggerDate = Calendar.current.date(byAdding: .hour, value: -3, to: addingEnd.zeroNanoseconds!)!
                        case 10:
                            nextTriggerDate = Calendar.current.date(byAdding: .hour, value: -2, to: addingEnd.zeroNanoseconds!)!
                        case 11:
                            nextTriggerDate = Calendar.current.date(byAdding: .hour, value: -1, to: addingEnd.zeroNanoseconds!)!
                        case 12:
                            nextTriggerDate = Calendar.current.date(byAdding: .minute, value: -30, to: addingEnd.zeroNanoseconds!)!
                        case 13:
                            nextTriggerDate = Calendar.current.date(byAdding: .minute, value: -15, to: addingEnd.zeroNanoseconds!)!
                        case 14:
                            nextTriggerDate = Calendar.current.date(byAdding: .minute, value: -10, to: addingEnd.zeroNanoseconds!)!
                        case 15:
                            nextTriggerDate = Calendar.current.date(byAdding: .minute, value: -5, to: addingEnd.zeroNanoseconds!)!
                        case 16:
                            nextTriggerDate = Calendar.current.date(byAdding: .minute, value: -1, to: addingEnd.zeroNanoseconds!)!
                        default:
                            nextTriggerDate = Calendar.current.date(byAdding: .minute, value: 0, to: addingEnd.zeroNanoseconds!)!
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
                        
                        
                        content.title = "\(addingName.trimmingCharacters(in: .whitespaces))"


                        let req = UNNotificationRequest(identifier: "\(idB)\(item)", content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
                    }
                }
                
                
                WidgetCenter.shared.reloadAllTimelines()

                self.presentationMode.wrappedValue.dismiss()
                    
                }
                
            }, label: {
                if addingName.trimmingCharacters(in: .whitespaces) == "" {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                        
                        Text(LocalizedStringKey("Add"))
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                    }.frame(width: 250, height: 50)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                        Text(LocalizedStringKey("Add"))
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(colorScheme == .dark ? Color(white: 32/255) : .white)
                    }.frame(width: 250, height: 50)
                }
            })
            
        }
                
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                    isFocued = true
                }
                isFirstResponder = true
            })
            .onDisappear(perform: {
                isFocued = false
                isFirstResponder = false
            })
            .padding()
            .padding(.bottom, 20)
            /*
            .padding(.top, (UIDevice.modelName == "iPhone SE (2nd generation)" || UIDevice.modelName == "iPhone 12 mini" || UIDevice.modelName == "iPod touch (7th generation)" || UIDevice.modelName == "iPhone 8" || UIDevice.modelName == "iPhone 7" || UIDevice.modelName == "iPhone SE" || UIDevice.modelName == "iPhone 6s"
                            //                                                || UIDevice.modelName == "iPhone X"
                     ) ? 10 : 0)
             */
        
        .toolbar(content: {
            Button(action: {
                #if os(iOS)
                light()
                #endif
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text(LocalizedStringKey("Cancel"))
            })
        })
            }
            .navigationTitle(LocalizedStringKey("New deadline"))
            .navigationBarTitleDisplayMode(
                /*
                (UIDevice.modelName == "iPhone SE (2nd generation)" || UIDevice.modelName == "iPhone 12 mini" || UIDevice.modelName == "iPod touch (7th generation)" || UIDevice.modelName == "iPhone 8" || UIDevice.modelName == "iPhone 7" || UIDevice.modelName == "iPhone SE" || UIDevice.modelName == "iPhone 6s"
//                                                || UIDevice.modelName == "iPhone X"
            ) ? .inline :
                 */
                .large)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(colorScheme == .dark ? .white : Color(white: 32/255))
        
        
    
        
        
    }
}

@available(iOS 15.0, *)
struct EditView: View {
    @State var addingName: String
    @State var addingStart: Date
    @State var addingEnd: Date
    @State var addingNotifications: [Bool]
    
    @State var addingColor: Color
    
    @State var showingNotification = false
    @State var showingColor = false
    
    @ObservedObject var deadline: Deadline
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var isFirstResponder = false
#if os(iOS)
    @FocusState private var isFocued: Bool
#endif
    
    var body: some View {
       
            
        
        NavigationView {
            ZStack {
                if colorScheme == .dark {
                    Color(white: 32/255)
                        .edgesIgnoringSafeArea(.all)
                }
            
            VStack(spacing: 11) {
                if #available(iOS 15.0, *) {
                    TextField(LocalizedStringKey("Name"), text: $addingName)
                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                        .frame(height: 50)

                        )
                        .focused($isFocued)
                    
                        .disableAutocorrection(true)
                        
                } else {
                    GeometryReader { geometry in
                        DeadlineTextField(text: $addingName, isFirstResponder: $isFirstResponder)
                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                            .frame(height: 50)

                            )
                            .frame(height: 50)

                    }
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                        .frame(height: 50)
                    DatePicker(selection: $addingStart, in: ...Date(), label: {
                        Text(LocalizedStringKey("Start"))
                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                    }).accentColor(colorScheme == .dark ? Color.secondary : Color.primary)
                    .padding()

                }.frame(height: 50)
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                        .frame(height: 50)
                    DatePicker(selection: $addingEnd, in: Date().addingTimeInterval(60)..., label: {
                        Text(LocalizedStringKey("deadline"))
                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                    }).accentColor(colorScheme == .dark ? Color.secondary : Color.primary)
                    .padding()

                }.frame(height: 50)
                HStack(spacing: 11) {
                    Button(action: {
                        hideKeyboard()
                        showingColor.toggle()
                    }, label: {
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                .frame(height: 45)
                            
                            HStack {
                                Text(LocalizedStringKey("Color"))
                                    .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                Spacer()
                                
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 25, weight: .thin))
                                    .foregroundColor(addingColor)
                            }.padding()

                        }.frame(width: 135, height: 45)
                    })
                    .sheet(isPresented: $showingColor, content: {
                        ColorsView(choosenColor: $addingColor)
                    })
                    
                    Button(action: {
                        hideKeyboard()
                        showingNotification.toggle()
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                                .frame(height: 45)
                            HStack {
                                Text(LocalizedStringKey("Notifications"))
                                    .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                Spacer()
                                if addingNotifications.filter { $0 == true }.count == 0 {
                                    Image(systemName:  "plus.circle")
                                        .font(.system(size: 25, weight: .thin))
                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                
                                } else {
                                    Image(systemName:  "\(addingNotifications.filter { $0 == true }.count).circle.fill")
                                        .font(.system(size: 25, weight: .thin))
                                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                                
                                }
                            }.padding()
                            

                        }.frame(height: 45)
                    })
                    .sheet(isPresented: $showingNotification, content: {
                        NotificationView(notifications: $addingNotifications, notificationsEnabled: areNotificationsEnabled())
                    })
                }
            
            Spacer()
            
            
                Button(action: {
                    
                    
                    DispatchQueue.main.async {
                    guard !(addingName.trimmingCharacters(in: .whitespaces) == "" || (addingEnd.zeroNanoseconds == deadline.end?.zeroNanoseconds && addingName.trimmingCharacters(in: .whitespaces) == deadline.name.trimmingCharacters(in: .whitespaces) && addingStart.zeroNanoseconds == deadline.start?.zeroNanoseconds && addingColor == Color(deadline.color!) && addingNotifications == deadline.notifications)) else {
                        #if os(iOS)
                        let generator = UIImpactFeedbackGenerator(style: .rigid)
                        generator.prepare()
                        generator.impactOccurred()
                        #endif
                        
                        return
                    }
                    #if os(iOS)
                    medium()
                    #endif
                    
                    
                    
                    hideKeyboard()
                    
                    
                    deadline.name = self.addingName.trimmingCharacters(in: .whitespaces)
                    deadline.start = addingStart.zeroNanoseconds
                    deadline.end = addingEnd.zeroNanoseconds
                    deadline.color = UIColor(addingColor)
                    deadline.notifications = addingNotifications
                    
                    for item in 0..<17 {
                        
                        

                       UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(deadline.idD)\(item)"])
                        
                        
                        
                        var nextTriggerDate = Calendar.current.date(byAdding: .second, value: 0, to: Date())!
                        if addingNotifications[item] == true {
                            switch item {
                            case 0:
                                nextTriggerDate = Calendar.current.date(byAdding: .second, value: 0, to: addingEnd.zeroNanoseconds!)!
                            case 1:
                                nextTriggerDate = Calendar.current.date(byAdding: .month, value: -1, to: addingEnd.zeroNanoseconds!)!
                            case 2:
                                nextTriggerDate = Calendar.current.date(byAdding: .day, value: -14, to: addingEnd.zeroNanoseconds!)!
                            case 3:
                                nextTriggerDate = Calendar.current.date(byAdding: .day, value: -7, to: addingEnd.zeroNanoseconds!)!
                            case 4:
                                nextTriggerDate = Calendar.current.date(byAdding: .day, value: -3, to: addingEnd.zeroNanoseconds!)!
                            case 5:
                                nextTriggerDate = Calendar.current.date(byAdding: .day, value: -2, to: addingEnd.zeroNanoseconds!)!
                            case 6:
                                nextTriggerDate = Calendar.current.date(byAdding: .hour, value: -24, to: addingEnd.zeroNanoseconds!)!
                            case 7:
                                nextTriggerDate = Calendar.current.date(byAdding: .hour, value: -12, to: addingEnd.zeroNanoseconds!)!
                            case 8:
                                nextTriggerDate = Calendar.current.date(byAdding: .hour, value: -6, to: addingEnd.zeroNanoseconds!)!
                            case 9:
                                nextTriggerDate = Calendar.current.date(byAdding: .hour, value: -3, to: addingEnd.zeroNanoseconds!)!
                            case 10:
                                nextTriggerDate = Calendar.current.date(byAdding: .hour, value: -2, to: addingEnd.zeroNanoseconds!)!
                            case 11:
                                nextTriggerDate = Calendar.current.date(byAdding: .hour, value: -1, to: addingEnd.zeroNanoseconds!)!
                            case 12:
                                nextTriggerDate = Calendar.current.date(byAdding: .minute, value: -30, to: addingEnd.zeroNanoseconds!)!
                            case 13:
                                nextTriggerDate = Calendar.current.date(byAdding: .minute, value: -15, to: addingEnd.zeroNanoseconds!)!
                            case 14:
                                nextTriggerDate = Calendar.current.date(byAdding: .minute, value: -10, to: addingEnd.zeroNanoseconds!)!
                            case 15:
                                nextTriggerDate = Calendar.current.date(byAdding: .minute, value: -5, to: addingEnd.zeroNanoseconds!)!
                            case 16:
                                nextTriggerDate = Calendar.current.date(byAdding: .minute, value: -1, to: addingEnd.zeroNanoseconds!)!
                            default:
                                nextTriggerDate = Calendar.current.date(byAdding: .minute, value: 0, to: addingEnd.zeroNanoseconds!)!
                            }
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
                        
                        
                        content.title = "\(addingName.trimmingCharacters(in: .whitespaces))"
                        
                        let req = UNNotificationRequest(identifier: "\(deadline.idD)\(item)", content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
                    }
                        
                    
                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        print("OOPS...")
                    }

                    
                    WidgetCenter.shared.reloadAllTimelines()
                    
                    
                    self.presentationMode.wrappedValue.dismiss()
                        
                    }
                    
                }, label: {
                    if addingName.trimmingCharacters(in: .whitespaces) == "" || (addingEnd.zeroNanoseconds == deadline.end?.zeroNanoseconds && addingName.trimmingCharacters(in: .whitespaces) == deadline.name.trimmingCharacters(in: .whitespaces) && addingStart.zeroNanoseconds == deadline.start?.zeroNanoseconds && addingColor == Color(deadline.color!) && addingNotifications == deadline.notifications){
                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                            
                            Text(LocalizedStringKey("Save"))
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                        }.frame(width: 250, height: 50)
                        
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                            Text(LocalizedStringKey("Save"))
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(colorScheme == .dark ? Color(white: 32/255) : .white)
                        }.frame(width: 250, height: 50)
                    }
                })
            
        }
            
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                    isFocued = true
                }
                isFirstResponder = true
            })
            .onDisappear(perform: {
                isFirstResponder = false
                isFocued = false
            })
            
            .padding()
            .padding(.bottom, 20)
            
            
            
            
            .padding(.top, 10)
            .toolbar(content: {
            Button(action: {
                #if os(iOS)
                light()
                #endif
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text(LocalizedStringKey("Cancel"))
            })
        })
            }
            .navigationTitle(LocalizedStringKey("Edit"))
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(colorScheme == .dark ? Color.white : Color(white: 32/255))
        
    }
}
