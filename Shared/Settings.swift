//
//  Settings.swift
//  Deadline (iOS)
//
//  Created by Егор Мальцев on 24.11.2021.
//

import SwiftUI

struct Settings: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("alert") private var alertBeforeDelete: Bool = false
    var body: some View {
        HStack(alignment: .top) {
            Text(LocalizedStringKey("Спрашивать перед удалением"))
                .foregroundColor(colorScheme == .dark ? .white : Color(white: 32/255))
            Spacer()
            Toggle("", isOn: $alertBeforeDelete)
            
        }.padding(.horizontal, 35)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
