//
//  NotesView.swift
//  Deadline (iOS)
//
//  Created by Егор Мальцев on 18.11.2021.
//

import Foundation
import SwiftUI


//стоит делиться по ссылке и qr заметкой


struct NotesView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var showNotesEditor = false
    
    @ObservedObject var deadline: Deadline
    
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            
            HStack(spacing: 0) {
                Text(LocalizedStringKey("Note"))
                    
                Text(":")
                Spacer()
                
            }.padding(.leading, 20)
            
            Group {
                if deadline.note.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                light()
                                showNotesEditor.toggle()
                            }, label: {
                                Text(LocalizedStringKey("Add a note"))
                                //перевести на русский
                                    .padding(.horizontal, 15)
                                    .foregroundColor(colorScheme == .dark ? Color(white: 32/255) : Color.white)
                                    .background(
                                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                                            .frame(height: 32)
                                            .foregroundColor(colorScheme == .dark ? Color.white : Color(white: 32/255))
                                    )
                            })
                            Spacer()
                        }.padding()
                    }
                
                } else {
                    HStack {
                        Spacer()
                        Text(deadline.note)
                        Spacer()
                    }.padding(.horizontal, 20)
                        .onTapGesture(perform: {
                            light()
                            showNotesEditor.toggle()
                        })
                }
            }
            .sheet(isPresented: $showNotesEditor, onDismiss: {
                
            }, content: {
                if #available(iOS 15.0, *) {
                    CreateNoteView(deadline: deadline, note: deadline.note)
                        .environment(\.managedObjectContext, managedObjectContext)
                } else {
                    // Fallback on earlier versions
                }
            })
            
            
            
        }.padding([.horizontal, .top])
    }
}



@available(iOS 15.0, *)
struct CreateNoteView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var deadline: Deadline
    
    @State var note: String
    
    @FocusState private var isFocued: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                if colorScheme == .dark {
                    Color(white: 32/255)
                        .edgesIgnoringSafeArea(.all)
                }
                VStack {
                    Spacer()
                    TextEditor(text: $note)
                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder(colorScheme == .dark ? Color.white : Color(white: 32/255), lineWidth: 0.55)
                        )
                        .focused($isFocued)
                        .onAppear(perform: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                            isFocued = true
                            }
                        })
                    Spacer()
                    Button(action: {
                        light()
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                            Text(LocalizedStringKey("Done"))
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(colorScheme == .dark ? Color(white: 32/255) : .white)
                        }.frame(width: 250, height: 50)
                    })
                        .padding(.top, 30)
                }
            }
            .padding()
            .padding(.bottom, 25)
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
                .navigationTitle(LocalizedStringKey("Note"))
                .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: note, perform: { value in
            DispatchQueue.main.async {
                deadline.note = note
                do {
                    try managedObjectContext.save()
                } catch {
                    print("OOPS…")
                }
            }
        })
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(colorScheme == .dark ? .white : Color(white: 32/255))
    }
}
