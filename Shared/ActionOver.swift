//
//  ActionOver.swift
//  Deadline (iOS)
//
//  Created by Егор Мальцев on 22.04.2021.
//

import SwiftUI

import UIKit

struct ActionOver: ViewModifier {

    @Binding var presented: Bool

    let title: String
    let message: String?
    let buttons: [ActionOverButton]
    let ipadAndMacConfiguration: IpadAndMacConfiguration
    let normalButtonColor: UIColor
    let defaultButtonColor: UIColor = UIColor(white: 32/255, alpha: 1)
    private var sheetButtons: [ActionSheet.Button] {
        
        var actionButtons: [ActionSheet.Button] = []

        for button in buttons {
            switch button.type {
            case .cancel:
                let button: ActionSheet.Button = .cancel()
                actionButtons.append(button)
            case .normal:
                
                UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = defaultButtonColor
                let button: ActionSheet.Button = .default(
                    Text(button.title ?? ""),
                    action: button.action
                )
                
                
                
                actionButtons.append(button)
               
            case .destructive:
                UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = normalButtonColor
                let button: ActionSheet.Button = .default(
                    Text(button.title ?? ""),
                    action: button.action
                )
                
                actionButtons.append(button)
           
            }
        }
        return actionButtons
    }

    @Environment(\.colorScheme) var colorScheme
    
    private var popoverButtons: [Button<Text>] {
        var actionButtons: [Button<Text>] = []

        
        for button in buttons {
            switch button.type {
            case .cancel:
                break
            case .normal:
                let button = Button(
                    action: {
                        self.presented = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            button.action?()
                        }
                    },
                    label: {
                        Text(button.title ?? "")
                            .foregroundColor(colorScheme == .dark ? Color.white : Color(white: 32/255))
                    }
                )
                actionButtons.append(button)
            case .destructive:
                let button = Button(
                    action: {
                        self.presented = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            button.action?()
                        }
                },
                    label: {
                        Text(button.title ?? "")
                            .foregroundColor(Color(self.normalButtonColor))
                })
                actionButtons.append(button)
            }
        }
        return actionButtons
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            
            
            .iPhone {
                $0
                    .actionSheet(isPresented: $presented) {
                        ActionSheet(
                            title: Text(self.title),
//                            message: Text(self.message ?? ""),
                            buttons: sheetButtons
                        )
                }
        }
        .iPadAndMac {
            
        
            return ipadAndMacConfiguration.anchor != nil ?
                $0.popover(
                    isPresented: $presented,
                    attachmentAnchor: PopoverAttachmentAnchor.point(ipadAndMacConfiguration.anchor ?? .topTrailing),
                    arrowEdge: (ipadAndMacConfiguration.arrowEdge ?? .top),
                    content: popContent
                )
                :
                $0.popover(isPresented: $presented, content: popContent)
        }
        
    }

    // MARK: - Private Methods

    private func popContent() -> some View {
        return VStack(alignment: .center, spacing: 10) {
            Text(self.title)
                .font(.headline)
                .foregroundColor(Color(UIColor.secondaryLabel))
                .padding(.top)

            ForEach((0..<self.popoverButtons.count), id: \.self) { index in
                Group {
                    Divider()
                    self.popoverButtons[index]
                        .padding(.all, 10)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(10)
    }
}

public struct IpadAndMacConfiguration {

    let anchor: UnitPoint?

    let arrowEdge: Edge?

    public init(anchor: UnitPoint?, arrowEdge: Edge?) {
        self.anchor = anchor
        self.arrowEdge = arrowEdge
    }
}

extension View {
    
    public func actionOver(
        presented: Binding<Bool>,
        title: String,
        message: String?,
        buttons: [ActionOverButton],
        ipadAndMacConfiguration: IpadAndMacConfiguration,
        normalButtonColor: UIColor
    ) -> some View {
        return self.modifier(
            ActionOver(
                presented: presented,
                title: title,
                message: message,
                buttons: buttons,
                ipadAndMacConfiguration: ipadAndMacConfiguration,
                normalButtonColor: normalButtonColor
            )
        )
    }
    
}

public struct ActionOverButton {
    public enum ActionType {
        case destructive, cancel, normal
    }
    let title: String?
    let type: ActionType
    let action: (() -> Void)?

    public init(title: String?, type: ActionType, action: (() -> Void)?) {
        self.title = title
        self.type = type
        self.action = action
    }
}

internal enum DeviceType {
    case iphone
    case ipad
    case mac
}

internal var deviceType: DeviceType = {
    #if targetEnvironment(macCatalyst)
    return .mac
    #else
    if UIDevice.current.userInterfaceIdiom == .pad {
        return .ipad
    } else {
        return .iphone
    }
    #endif
}()

internal extension View {

    @ViewBuilder func ifIs<T>(_ condition: Bool, transform: (Self) -> T) -> some View where T: View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder func iPhone<T>(_ transform: (Self) -> T) -> some View where T: View {
        if deviceType == .iphone {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder func iPad<T>(_ transform: (Self) -> T) -> some View where T: View {
        if deviceType == .ipad {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder func mac<T>(_ transform: (Self) -> T) -> some View where T: View {
        if deviceType == .mac {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder func iPadAndMac<T>(_ transform: (Self) -> T) -> some View where T: View {
        if deviceType == .mac || deviceType == .ipad {
            transform(self)
        } else {
            self
        }
    }
}

