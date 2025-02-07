//
//  SearchSettingsView.swift
//  CodeEdit
//
//  Created by Esteban on 12/10/23.
//

import SwiftUI

struct SearchSettingsView: View {
    @State private var sectionIDS: SectionIDs = .init([1])

    var body: some View {
        SettingsForm {
            Section {
                ExcludedGlobPatternList()
            } header: {
                Text("Exclude")
                Text(
                    "Add glob patterns to exclude matching files and folders from searches and open quickly. " +
                    "This will inherit glob patterns from the Exclude from Project setting."
                )
            }
            .id(sectionIDS[0])
        }
        .autoScrollToSection(name: .search, sectionIDS)
    }
}

struct ExcludedGlobPatternList: View {
    @ObservedObject private var model: SearchSettingsModel = .shared

    var body: some View {
        GlobPatternList(
            patterns: $model.ignoreGlobPatterns,
            selection: $model.selection,
            addPattern: model.addPattern,
            removePatterns: model.removePatterns,
            emptyMessage: "No excluded glob patterns"
        )
    }
}
