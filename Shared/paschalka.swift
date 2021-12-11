//
//  paschalka.swift
//  Deadline (iOS)
//
//  Created by Егор Мальцев on 05.06.2021.
//

import Foundation
import SwiftUI
import UIKit

struct KlimtView: View {
    @State var type: Int
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedView: Int
    
//    @Binding var isPressing: Bool
    var body: some View {
        VStack(spacing: 30) {
            
            switch type {
            case 2:
                Image("a")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 265)
                    .padding(5)
                    .background(
                        Rectangle()
                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                    )
                
                
                
//                    .onLongPressGesture(
//                        minimumDuration: 100,
//                        maximumDistance: 0,
//                        pressing: { value in
//                            isPressing = value
//                        },
//                        perform: {
//
//                        }
//                        )
//
//
                
                
                
                
                VStack(spacing: 5) {
                    Text("The Kiss")
                        .foregroundColor(colorScheme == .dark ? Color.white : Color(white: 32/255))
                        .fontWeight(.bold)
                        
                    Text("Gustav Klimt")
                        .foregroundColor(colorScheme == .dark ? Color.white : Color(white: 32/255))
                        .fontWeight(.light)
                }
            case 1:
                Image("b")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 265)
                    .padding(5)
                    .background(
                        Rectangle()
                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                    )
                
                VStack(spacing: 5) {
                    Text("Bouteilles")
                        .foregroundColor(colorScheme == .dark ? Color.white : Color(white: 32/255))
                        .fontWeight(.bold)
                        
                    Text("Le Corbusier")
                        .foregroundColor(colorScheme == .dark ? Color.white : Color(white: 32/255))
                        .fontWeight(.light)
                }
            case 3:
                Image("d")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 265)

                    .padding(5)
                    .background(
                        Rectangle()
                            .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
                    )
                
                VStack(spacing: 5) {
                    Text("PROUN «CITY»")
                        .foregroundColor(colorScheme == .dark ? Color.white : Color(white: 32/255))
                        .fontWeight(.bold)
                        
                    Text("El Lissitzky")
                        .foregroundColor(colorScheme == .dark ? Color.white : Color(white: 32/255))
                        .fontWeight(.light)
                }
            case 4:
                ZStack {
                    Color(red: 114/255, green: 206/255, blue: 200/255)
                    VStack {
                        
                        Spacer()
                        
                        Text("""
2D326636 34326537
32202D32 66346532
66343220 2D326634
64326537 34203230
64313831 6431202D
37643266 34313330
202D3437 32653764
6530202D 32653764
32663432 202D3266
34633266 34322032
63323064 31383720
2d326537 64326634
32202D32 66346532
65373520 32306430
62366430 202D3462
32663466 3266202D
37643265 37343030
""")
                            .font(.custom("Courier New", size: 20))
                            .foregroundColor(.white)
                        Spacer()
//                        VStack(spacing: 0) {
//
//                            Text("Deadline App")
//                                .foregroundColor(.white)
//                        }
                    }
//                            .padding(.bottom, 50)
                }
            default:
                RoundedRectangle(cornerRadius: 20, style: .continuous)
            }
            
        }
        
        
    }
}




struct PaschalkaView: View {
    @State private var selectedTab = 0
    private let colors: [Color] = [.red, .blue, .green, .yellow]

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("paschalkaController") private var showingPaschalka: Bool = false
//    @State var isBlur = false
    
    var body: some View {
        GeometryReader { geometry in
        ZStack {
            
            if colorScheme == .dark {
                Color(red: 32/255, green: 32/255, blue: 32/255)
                    .edgesIgnoringSafeArea(.all)

            } else {
                Color.white
                    .edgesIgnoringSafeArea(.all)

            }
            
            HStack {
                ForEach(1..<10) { _ in
                    Spacer()
                    Divider()
//                    Rectangle()
//                        .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
//                        .frame(width: 0.35)
                    Spacer()
                }
            }
            .padding(.horizontal, 12)
            .edgesIgnoringSafeArea(.all)
           
            if selectedTab == 3 {
                Color(red: 114/255, green: 206/255, blue: 200/255)
                    .animation(.default)
                    .edgesIgnoringSafeArea(.all)
                    
            }
            
            VTabView(selection: $selectedTab) {
                ForEach(0..<4, id: \.self) { index in
                    KlimtView(type: index+1, selectedView: $selectedTab)
                }
            }
            
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.default)
            if selectedTab != 3 {
                HStack {
                    Spacer()
                    VStack {
                        Circle()
                            .foregroundColor(selectedTab == 0 ? (colorScheme == .dark ? .white : Color(white: 32/255)) : .gray)
                            .frame(width: 7, height: 7)
                            .animation(.default)
                        Circle()
                            .foregroundColor(selectedTab == 1 ? (colorScheme == .dark ? .white : Color(white: 32/255)) : .gray)
                            .frame(width: 7, height: 7)
                            .animation(.default)
                        Circle()
                            .foregroundColor(selectedTab == 2 ? (colorScheme == .dark ? .white : Color(white: 32/255)) : .gray)
                            .frame(width: 7, height: 7)
                            .animation(.default)
                    }
                }.padding()
            }
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        medium()
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        ZStack {
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor((
                                    selectedTab == 3 ? Color.init(red: 1, green: 1, blue: 1, opacity: 0.2) :
                                    colorScheme == .dark ? Color.init(red: 44/255, green: 44/255, blue: 44/255) : Color.init(red: 245/255, green: 245/255, blue: 245/255)
                                ))
                            Image(systemName: "xmark")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(selectedTab == 3 ? .white : colorScheme == .dark ? .white : Color(white: 32/255))
                        }
                    })
                    .padding(25)
                }
                Spacer()
            }.edgesIgnoringSafeArea(.all)

        }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }.onChange(of: selectedTab, perform: { value in
            
            if value == 3 {
                heavy()
            } else {
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.prepare()
                generator.impactOccurred()
            }
            
        })
        
            .onAppear(perform: {
                showingPaschalka = true
            })
        
            .onDisappear(perform: {
                showingPaschalka = false
            })
            .statusBar(hidden: true)
        
    }
}



@available(iOS 14.0, *)
public struct VTabView<Content, SelectionValue>: View where Content: View, SelectionValue: Hashable {
    
    private var selection: Binding<SelectionValue>?
    
    private var indexPosition: IndexPosition
    
    private var content: () -> Content
    
    public init(selection: Binding<SelectionValue>?, indexPosition: IndexPosition = .leading, @ViewBuilder content: @escaping () -> Content) {
        self.selection = selection
        self.indexPosition = indexPosition
        self.content = content
    }
    
    private var flippingAngle: Angle {
        switch indexPosition {
        case .leading:
            return .degrees(0)
        case .trailing:
            return .degrees(180)
        }
    }
    
    public var body: some View {
        GeometryReader { proxy in
            TabView(selection: selection) {
                Group {
                    content()
                }
               
                
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .rotationEffect(.degrees(-90))
                .rotation3DEffect(flippingAngle, axis: (x: 1, y: 0, z: 0))
                
                .aspectRatio(contentMode: .fit)
            }
            .frame(width: proxy.size.height, height: proxy.size.width, alignment: .center)
            .rotation3DEffect(flippingAngle, axis: (x: 1, y: 0, z: 0))
            .rotationEffect(.degrees(90), anchor: .topLeading)
            .offset(x: proxy.size.width)
            .frame(width: proxy.size.height, height: proxy.size.width, alignment: .center)
//            .edgesIgnoringSafeArea(.all)
        }
    }
    
    public enum IndexPosition {
        case leading
        case trailing
    }
}

@available(iOS 14.0, *)
extension VTabView where SelectionValue == Int {
    
    public init(indexPosition: IndexPosition = .leading, @ViewBuilder content: @escaping () -> Content) {
        self.selection = nil
        self.indexPosition = indexPosition
        self.content = content
    }
}
