//
//  DeadlineAppWidgetD.swift
//  DeadlineAppWidgetD
//
//  Created by Егор Мальцев on 30.03.2021.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            deadline: deadline(for: ConfigurationIntent())
        )
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        if context.isPreview {
            let entry = SimpleEntry(
                date: Date(),
                deadline: DeadlineStruct.previewDeadline
            )
            completion(entry)
        } else {
            let entry = SimpleEntry(
                date: Date(),
                deadline: deadline(for: configuration)
            )
            completion(entry)
        }
    }
    
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        for offset in 0 ..< 24 * 4 {
            _ = Calendar.current.date(byAdding: .minute, value: 15 * offset, to: Date())!
            let entry = SimpleEntry(
                date: Date(),
                deadline: deadline(for: configuration)
            )
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
 
    
    func deadline(for configuration: ConfigurationIntent) -> DeadlineStruct? {
        
        if let id = configuration.deadline?.identifier, let deadline = DeadlineStruct.fromId(id: id) {
            return deadline
        }
        return nil
    }
    
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    var deadline: DeadlineStruct?
}

struct DeadlineAppWidgetDEntryView: View {
    var entry: Provider.Entry
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            if colorScheme == .dark {
                Color(white: 32/255)
                    .edgesIgnoringSafeArea(.all)
            }
            if entry.deadline == nil || entry.deadline?.idD == -1001  {
                    VStack {
                        Spacer()
                        Text(LocalizedStringKey("widgetDeadlineCreate"))
                        Spacer()
                        Image(systemName: "plus")
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 15)
                
                .widgetURL(URL(string: "deadlineAppWidget://newWidget")!)
            } else {
                WidgetView(deadline: entry.deadline!, dateD: entry.date)
            }
        }
        
    }
}

struct WidgetView: View {
    @Environment(\.widgetFamily) var widgetFamily
    
    let deadline: DeadlineStruct
    var dateD: Date
    
    @ViewBuilder
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            SmallView(
                year: raznitsaStruct(deadline: deadline, type: "year", date: dateD),
                month: raznitsaStruct(deadline: deadline, type: "month", date: dateD),
                day: raznitsaStruct(deadline: deadline, type: "day", date: dateD),
                hour: raznitsaStruct(deadline: deadline, type: "hour", date: dateD),
                minute: raznitsaStruct(deadline: deadline, type: "minute", date: dateD),
                second: raznitsaStruct(deadline: deadline, type: "second", date: dateD),
                deadline: deadline, dateD: dateD)
        case .systemMedium:
            MediumView(
                year: raznitsaStruct(deadline: deadline, type: "year", date: dateD),
                month: raznitsaStruct(deadline: deadline, type: "month", date: dateD),
                day: raznitsaStruct(deadline: deadline, type: "day", date: dateD),
                hour: raznitsaStruct(deadline: deadline, type: "hour", date: dateD),
                minute: raznitsaStruct(deadline: deadline, type: "minute", date: dateD),
                second: raznitsaStruct(deadline: deadline, type: "second", date: dateD),
                deadline: deadline, dateD: dateD)
        default:
            Text("")
        }
    }
}

func raznitsaStruct(deadline: DeadlineStruct, type: String, date: Date) -> Int {
    
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents(
        [.year, .month, .day, .hour, .minute, .second],
        from: date, to: deadline.end )
    
    switch type {
    case "year":
        return dateComponents.year!
    case "month":
        return dateComponents.month!
    case "day":
        return dateComponents.day!
    case "hour":
        return dateComponents.hour!
    case "minute":
        return dateComponents.minute!
    case "second":
        return dateComponents.second!
    default:
        return -1
    }
}

struct ProgressBar: View {
    
    let controller = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var deadline: DeadlineStruct
    
    var dateD: Date
    
    @Environment(\.colorScheme) var colorScheme
    @State var ProgressValue: Float
    @State var cornerRadius: Float
    @State var deadlineColor: Color
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                
                
            Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                .foregroundColor(
                    self.colorScheme == .dark ? Color.init(white: 44/255) : Color.init(white: 245/255)
                
                )
            Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
            
                .foregroundColor(
                    deadlineColor
                )
                
                .opacity(
                    Float((deadline.end ).timeIntervalSince(Date())) <= 0 ? 0.2 : 0
                )
                
                HStack(spacing: -5) {
                    
                    Rectangle()
                        .foregroundColor((
                    colorScheme == .dark ? Color.init(white: 44/255) : Color.init(white: 245/255)
                ))
                        .frame(width: min(CGFloat(self.ProgressValue)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                        .opacity(0)
                    Rectangle()
                        .frame(width: 4.5)
                        .foregroundColor(deadlineColor)
                }
            }
        }
        
        .widgetURL(URL(string: "deadlineAppWidget://\(deadline.idD)")!)
    }
}

struct SmallView: View {
    
    
    var year: Int
    var month: Int
    var day: Int
    var hour: Int
    var minute: Int
    var second: Int
    
    let deadline: DeadlineStruct
    
    var dateD: Date
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(deadline.name)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 20, weight: .medium))
                    .lineLimit(3)
                Spacer()
                VStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        if Float((deadline.end).timeIntervalSince(dateD)) <= 0 {
                            Text(LocalizedStringKey("expired"))
                        } else {
                            Text(deadline.end, style: .relative)
                        }
                    }
                    Text(LocalizedStringKey("Time left"))
                        .font(.system(size: 14.5, weight: .regular))
                        .foregroundColor(
                            Float((deadline.end ).timeIntervalSince(Date())) <= 0 ?
                                Color.init(red: Double(deadline.colorR)/Double(255), green: Double(deadline.colorG)/Double(255), blue: Double(deadline.colorB)/Double(255)) : Color.gray)
                }
            }.padding()
            Spacer()
        }
        .background(
            ProgressBar(deadline: deadline, dateD: dateD,
                        ProgressValue: Float((deadline.end).timeIntervalSince(dateD)/(deadline.end).timeIntervalSince(deadline.start)),
                        cornerRadius: 20,
                        deadlineColor:
                        Color.init(red: Double(deadline.colorR)/Double(255), green: Double(deadline.colorG)/Double(255), blue: Double(deadline.colorB)/Double(255)))
        )
    }
}

struct MediumView: View {
    var year: Int
    var month: Int
    var day: Int
    var hour: Int
    var minute: Int
    var second: Int
    
    let deadline: DeadlineStruct
    
    var dateD: Date
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(deadline.name)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 20, weight: .medium))
                    .lineLimit(3)
                Spacer()
                VStack(alignment: .trailing, spacing: 0) {
                    Text(LocalizedStringKey("Time left"))
                        .font(.system(size: 14.5, weight: .regular))
                        .foregroundColor(
                            Float((deadline.end ).timeIntervalSince(Date())) <= 0 ?
                                Color.init(red: Double(deadline.colorR)/Double(255), green: Double(deadline.colorG)/Double(255), blue: Double(deadline.colorB)/Double(255))
                                
                                     : Color.gray
                    )
                    HStack(spacing: 0) {
                        if Float((deadline.end).timeIntervalSince(dateD)) <= 0 {
                            HStack {
                                Spacer()
                                Text(LocalizedStringKey("expired"))
                            }
                        } else {
                            Text(deadline.end, style: .relative)
                                .multilineTextAlignment(.trailing)
                        }
                    }.frame(width: 130)
                }
            }
            Spacer()
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    if Text(dateString(date: deadline.end)) == Text(dateString(date: deadline.start)) {
                        Text(timeString(date: deadline.start))
                    } else {
                        Text(dateString(date: deadline.start))
                    }
                    Text(LocalizedStringKey("Start"))
                        .font(.system(size: 14.5, weight: .regular))
                        .foregroundColor(
                            Float((deadline.end ).timeIntervalSince(Date())) <= 0 ?
                                Color.init(red: Double(deadline.colorR)/Double(255), green: Double(deadline.colorG)/Double(255), blue: Double(deadline.colorB)/Double(255)) : Color.gray)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 0) {
                    if (Text(dateString(date: deadline.end)) == Text(dateString(date: deadline.start ))) ||  Text(dateString(date: Date())) == Text(dateString(date: deadline.end)) || Text(dateString(date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)) == Text(dateString(date: deadline.end )) {
                        if Text(dateString(date: Date())) == Text(dateString(date: deadline.end )) {
                            HStack(spacing: 0) {
                                Text(LocalizedStringKey("Today at"))
                                Text("\(timeString(date: deadline.end ))")
                            }
                        } else if Text(dateString(date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)) == Text(dateString(date: deadline.end )) {
                            HStack(spacing: 0) {
                                Text(LocalizedStringKey("Tomorrow at"))
                                Text("\(timeString(date: deadline.end ))")
                            }
                        } else {
                            Text(timeString(date: deadline.end ))
                        }
                    } else {
                        Text(dateString(date: deadline.end))
                    }
                    Text(LocalizedStringKey("deadline"))
                        .font(.system(size: 14.5, weight: .regular))
                        .foregroundColor(
                            Float((deadline.end ).timeIntervalSince(Date())) <= 0 ?
                                Color.init(red: Double(deadline.colorR)/Double(255), green: Double(deadline.colorG)/Double(255), blue: Double(deadline.colorB)/Double(255)) : Color.gray)
                }
            }
        }.padding(20)
        .background(
            ProgressBar(deadline: deadline, dateD: dateD,
                        ProgressValue: Float((deadline.end).timeIntervalSince(dateD)/(deadline.end).timeIntervalSince(deadline.start)),
                        cornerRadius: 20,
                        deadlineColor:
                                Color.init(red: Double(deadline.colorR)/Double(255), green: Double(deadline.colorG)/Double(255), blue: Double(deadline.colorB)/Double(255)))
        )
        
    }
    
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
    
}

@main
struct DeadlineAppWidgetD: Widget {
    let kind: String = "DeadlineAppWidgetD"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: Provider()
        ){ entry in
            DeadlineAppWidgetDEntryView(entry: entry)
        }
        .configurationDisplayName("Deadline Widget")
        .description("Developed with Love.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
