//
//  NavigationSettingsView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 3/4/24.
//

import SwiftUI

struct NavigationSettingsView: View {
    @State private var sectionIDS: SectionIDs = .init([1])

    @AppSettings(\.navigation)
    var settings

    var body: some View {
        SettingsForm {
            Section {
                navigationStyle
            }
            .id(sectionIDS[0])
        }
        .autoScrollToSection(name: .navigation, sectionIDS)
    }
}

private extension NavigationSettingsView {
    private var navigationStyle: some View {
        Picker("Navigation Style", selection: $settings.navigationStyle) {
            Text("Open in Tabs")
                .tag(SettingsData.NavigationStyle.openInTabs)
            Text("Open in Place")
                .tag(SettingsData.NavigationStyle.openInPlace)
        }
    }
}
