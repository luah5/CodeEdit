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
                    if name == newPage.name, let sectionID = sectionIDS.find(Int(String(describing: newPage.settingNumber)) ?? -1) {
                            withAnimation {
                                print("scrolling")
                                // proxy.scrollTo(sectionID)
                            }
                        }
                    }
        }
    }
}
