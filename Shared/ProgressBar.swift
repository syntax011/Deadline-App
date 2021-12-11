//
//  ProgressBar.swift
//  Deadline (iOS)
//
//  Created by Егор Мальцев on 24.05.2021.
//


import Foundation
import SwiftUI

struct ProgressBarBeta: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    let controller = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @ObservedObject var deadline: Deadline
    
    @Environment(\.colorScheme) var colorScheme
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
                        Float((deadline.end ?? Date()).timeIntervalSince(Date())) <= 0 ? 0.5 : 0
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
                            withAnimation(.linear(duration: 1)) {
                                ProgressValue = Double((deadline.end ?? Date()).timeIntervalSince(Date())/(deadline.end ?? Date()).timeIntervalSince(deadline.start ?? Date()))
                            }
                        }
                    
                    }
                })
            }.clipShape(RoundedRectangle(cornerRadius: CGFloat(cornerRadius), style: .continuous))
        }
            
        
    }
}


