//
//  Functions.swift
//  Deadline (iOS)
//
//  Created by Егор Мальцев on 16.11.2021.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins
import StoreKit




func showRequest() {
    let value = UserDefaults.standard.integer(forKey: "rateValue")
    if value < 200 {
        UserDefaults.standard.set(value + 1, forKey: "rateValue")
    }
    if value == 10 || value == 30 || value == 100 || value == 150 || value == 200
    {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

#if canImport(UIKit)
import UIKit
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

func raznitsa(deadline: Deadline, type: String) -> Int {
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents(
        [.year, .month, .day, .hour, .minute, .second],
        from: Date(), to: deadline.end ?? Date())
    
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

func createDeadlineURL(deadline: Deadline) -> URL {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "deadlineApp"
        components.host = "share.deadlineApp"
        components.queryItems = [
            URLQueryItem(name: "name", value: deadline.name),
            URLQueryItem(name: "start", value: "\(Int(deadline.start!.timeIntervalSince1970))"),
            URLQueryItem(name: "deadline", value: "\(Int(deadline.end!.timeIntervalSince1970))"),
            URLQueryItem(name: "colorR", value: "\(Int(Color((deadline.color ?? UIColor.init(.accentColor))).components.red * 255))"),
            URLQueryItem(name: "colorG", value: "\(Int(Color((deadline.color ?? UIColor.init(.accentColor))).components.green * 255))"),
            URLQueryItem(name: "colorB", value: "\(Int(Color((deadline.color ?? UIColor.init(.accentColor))).components.blue * 255))")
        ]
        return components.url
    }
    return url!
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

func timeZoneString(date: Date) -> String {
    var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
    var localTimeZoneIdentifier: String { return TimeZone.current.identifier }

    return "\(localTimeZoneAbbreviation) (\(localTimeZoneIdentifier))"
    
}

let context = CIContext()
let filter = CIFilter.qrCodeGenerator()

func generateDeadlineQRCode(from string: String) -> UIImage {
    let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
}

let colors = [
    
    Color.init(red: 238/255, green: 185/255, blue: 176/255),
    Color.init(red: 171/255, green: 172/255, blue: 203/255),
    Color.init(red: 168/255, green: 189/255, blue: 210/255),
    Color.init(red: 164/255, green: 190/255, blue: 179/255),
    Color.init(red: 234/255, green: 202/255, blue: 149/255),
    Color.init(red: 233/255, green: 170/255, blue: 149/255)
    
]

public extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}

public extension ScrollView {
    private typealias PaddedContent = ModifiedContent<Content, _PaddingLayout>
    
    func fixFlickering() -> some View {
        GeometryReader { geo in
            ScrollView<PaddedContent>(axes, showsIndicators: showsIndicators) {
                content.padding(geo.safeAreaInsets) as! PaddedContent
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

public extension Color {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {

        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            return (0, 0, 0, 0)
        }

        return (r, g, b, o)
    }
}

public extension Date {
    var zeroNanoseconds: Date? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return calendar.date(from: dateComponents)
    }
}

public extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPhone13,1":                              return "iPhone 12 mini"
            case "iPhone13,2":                              return "iPhone 12"
            case "iPhone13,3":                              return "iPhone 12 Pro"
            case "iPhone13,4":                              return "iPhone 12 Pro Max"
            
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}

func heavy() {
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.prepare()
    generator.impactOccurred()
}

func medium() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.prepare()
    generator.impactOccurred()
}

func light() {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.prepare()
    generator.impactOccurred()
}
