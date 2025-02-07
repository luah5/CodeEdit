//
//  SourceControlSettingsView.swift
//  CodeEdit
//
//  Created by Raymond Vleeshouwer on 02/04/23.
//

import SwiftUI

struct SourceControlSettingsView: View {
    @AppSettings(\.sourceControl.general)
    var settings

    @State var sectionIDS: SectionIDs = .init([100, 100])
    @State var selectedTab: String = "general"

    var body: some View {
        SettingsForm {
            Section {
                sourceControlIsEnabled
            } footer: {
                if settings.sourceControlIsEnabled {
                    Picker("", selection: $selectedTab) {
                        Text("General").tag("general")
                        Text("Git").tag("git")
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    .padding(.top, 10)
                }
            }
            .id(sectionIDS[0])
            if settings.sourceControlIsEnabled {
                switch selectedTab {
                case "general":
                    SourceControlGeneralView()
                        .id(sectionIDS[1])
                case "git":
                    SourceControlGitView()
                        .id(sectionIDS[2])
                default:
                    SourceControlGeneralView()
                }
            }
        }
        .autoScrollToSection(name: .sourceControl, sectionIDS)
        .onAppear {
            let searchKeys = Settings.shared.preferences.sourceControl.searchKeys
            let gitIndex = searchKeys.firstIndex(of: "Git") ?? 2

            print(gitIndex)

            sectionIDS = .init(
                [
                    .init(ids: [0]),
                    .init(
                        ids: Array(1...gitIndex),
                        action: { selectedTab = "general" }
                    ),
                    .init(
                        ids: Array(gitIndex...(searchKeys.count - 1)),
                        action: { selectedTab = "git" }
                    )
                ]
            )
            print(sectionIDS)
        }
    }

    private var sourceControlIsEnabled: some View {
        Toggle(
            isOn: $settings.sourceControlIsEnabled
        ) {
            Label {
                Text("Source Control")
                Text("""
                 Back up your files, collaborate with others, and tag your releases. \
                 [Learn more...](https://developer.apple.com/documentation/xcode/source-control-management)
                 """)
                .font(.callout)
             } icon: {
                FeatureIcon(symbol: Image(symbol: "vault"), color: Color(.systemBlue), size: 26)
            }
        }
        .controlSize(.large)
    }

}
