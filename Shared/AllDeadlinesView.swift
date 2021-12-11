//
//  AllDeadlinesView.swift
//  Deadline (iOS)
//
//  Created by Егор Мальцев on 25.11.2021.
//

import SwiftUI
import CoreData

struct AllDeadlinesView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.colorScheme) var colorScheme
    
    
    @FetchRequest(entity: Deadline.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Deadline.end, ascending: true)], animation: .linear)
    var allDeadlines: FetchedResults<Deadline>
    
    var body: some View {
        
        VStack(spacing: 14) {
            ForEach(allDeadlines.filter { $0.done == false && $0.isPinned == true }, id: \.self) { deadline in
                DeadlineItem(
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
            
            ForEach(allDeadlines.filter { $0.done == false && $0.isPinned == false }, id: \.self) { deadline in
                DeadlineItem(
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
}

/*
struct AllDeadlinesView_Previews: PreviewProvider {
    static var previews: some View {
        AllDeadlinesView()
    }
}
*/
