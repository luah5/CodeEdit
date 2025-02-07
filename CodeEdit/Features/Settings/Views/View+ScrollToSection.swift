//
//  View+ScrollToSection.swift
//  CodeEdit
//
//  Created by Raymond Vleeshouwer on 25/01/25.
//

import SwiftUI

extension View {
    func autoScrollToSection(name: SettingsPage.Name, _ sectionIDS: SectionIDs) -> some View {
        modifier(AutoScrollToSectionModifier(name: name, sectionIDS: sectionIDS))
    }
}

struct AutoScrollToSectionModifier: ViewModifier {
    let name: SettingsPage.Name
    let sectionIDS: SectionIDs

    func body(content: Content) -> some View {
        ScrollViewReader { proxy in
            content
                .onReceive(SettingsViewModel.shared.$selectedPage) { newPage in
                    if name == newPage.name, let sectionID = sectionIDS.find(newPage.settingNumber) {
                            withAnimation {
                                proxy.scrollTo(sectionID/*, anchor: sectionID.getAnchor(for: newPage.settingNumber)*/)
                                sectionID.performAction()
                            }
                        }
                    }
        }
        // To not interfere with the existing SettingsForm scroll implementation
        .scrollIndicators(.hidden)
    }
}
