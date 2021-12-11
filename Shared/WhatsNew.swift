//
//  WhatsNew.swift
//  Deadline (iOS)
//
//  Created by Егор Мальцев on 11.06.2021.
//

import SwiftUI

struct NewView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        
        ZStack {
            if colorScheme == .dark {
                Color(red: 32/255, green: 32/255, blue: 32/255)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color.init(red: 0.95, green: 0.95, blue: 0.95)
                    .edgesIgnoringSafeArea(.all)
            }
            
            GeometryReader { geometry in
                ZStack {
                    if colorScheme == .dark {
                        Color(red: 32/255, green: 32/255, blue: 32/255)
                            .edgesIgnoringSafeArea(.all)
                    } else {
                        Color.init(red: 0.95, green: 0.95, blue: 0.95)
                            .edgesIgnoringSafeArea(.all)
                    }
                   
                    VStack {
                        Spacer()
                        
                        
                        Text("Welcome to\nDeadline v 2.0.4")
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                        Spacer()
                        newFeatures().padding(.leading, (geometry.size.width - 285)/2)
                        Spacer()
                        Button(action: {
                            DispatchQueue.main.async {
                                medium()
                                UserDefaults.standard.set(true, forKey: "whatsNew2")
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }, label: {
                            Text("OK")
                                .foregroundColor(
                                    colorScheme == .light ?
                                    Color(white: 32/255) :
                                        Color.white)
                                .padding()
                                .padding(.horizontal, 20)
                                .background(
                                    Capsule(style: .continuous)
                                        .foregroundColor(
                                            colorScheme == .light ?
                                            Color(white: 235/255) :
                                                Color(white: 40/255)
                                        )
                                )
                        })
                        
                    }
                }.padding(.bottom, 75)
            }
        }
        
        .onAppear(perform: {
            heavy()
        })
        
       
       
    }
}

struct newFeatures: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        
            HStack {
                VStack(spacing: 30) {
                    
                    
                    HStack(spacing: 30) {
                        Image(systemName: "note.text")
                            .font(.system(size: 40))
                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Quick notes")
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                            Text("Add quick notes for deadlines")
                                .font(.callout).fontWeight(.light)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    
                    HStack(spacing: 30) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 40))
                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Sharing")
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                            Text("Share links to your deadlines with your contacts")
                                .font(.callout)
                                .fontWeight(.light)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    
                    HStack(spacing: 30) {
                        Image(systemName: "qrcode")
                            .font(.system(size: 40))
                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                        VStack(alignment: .leading, spacing: 3) {
                            Text("QR codes")
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                            Text("Share your deadlines via QR codes")
                                .font(.callout).fontWeight(.light)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    
                    
                    
                }.frame(width: 320)
                Spacer()
            }
                
        
        
    }
}
