//
//  SettingsView.swift
//  CodeEdit
//
//  Created by Raymond Vleeshouwer on 26/03/23.
//

import SwiftUI
import CodeEditSymbols

/// A struct for settings
struct SettingsView: View {
    @StateObject var model = SettingsViewModel()
    @Environment(\.colorScheme)
    private var colorScheme

    @State private var selectedPage: SettingsPage = SettingsPage(.general)

    @Environment(\.presentationMode)
    var presentationMode

    static var pages: [PageAndSettings] = [
        .init(
            SettingsPage(
                .general,
                baseColor: .gray,
                icon: .system("gear")
            )
        ),
        .init(
            SettingsPage(
                .accounts,
                baseColor: .blue,
                icon: .system("at")
            )
        ),
        .init(
            SettingsPage(
                .theme,
                baseColor: .pink,
                icon: .system("paintbrush.fill")
            )
        ),
        .init(
            SettingsPage(
                .textEditing,
                baseColor: .blue,
                icon: .system("pencil.line")
            )
        ),
        .init(
            SettingsPage(
                .terminal,
                baseColor: .blue,
                icon: .system("terminal.fill")
            )
        ),
        .init(
            SettingsPage(
                .sourceControl,
                baseColor: .blue,
                icon: .symbol("vault")
            )
        ),
        .init(
            SettingsPage(
                .location,
                baseColor: .green,
                icon: .system("externaldrive.fill")
            )
        ),
        .init(
            SettingsPage(
                .featureFlags,
                baseColor: .cyan,
                icon: .system("flag.2.crossed.fill")
            )
        )
    ]

    @ObservedObject private var settings: Settings = .shared

    let updater: SoftwareUpdater

    /// Searches through an array of pages to check if a page name exists in the array
    private func resultFound(_ page: SettingsPage, pages: [SettingsPage]) -> SettingsSearchResult {
        let lowercasedSearchText = model.searchText.lowercased()
        var returnedPages: [SettingsPage] = []
        var foundPage = false

        for item in pages where item.name == page.name {
            if item.isSetting && item.settingName.lowercased().contains(lowercasedSearchText) {
                returnedPages.append(item)
            } else if item.name.rawValue.contains(lowercasedSearchText) && !item.isSetting {
                foundPage = true
            }
        }

        return SettingsSearchResult(pageFound: foundPage, pages: returnedPages)
    }

    /// Gets search results from a settings page and an array of settings
    @ViewBuilder
    private func resultsView(_ page: SettingsPage, _ settings: [SettingsPage]) -> (some View)? {
        if !model.searchText.isEmpty {
            let results: SettingsSearchResult = resultFound(page, pages: settings)

            if !results.pages.isEmpty && !page.isSetting {
                SettingsPageView(page)

                ForEach(results.pages, id: \.settingName) { setting in
                    NavigationLink(value: setting) {
                        setting.settingName.highlightOccurrences(model.searchText)
                            .padding(.leading, 22)
                    }
                }
            }
        }
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedPage) {
                Section {
                    ForEach(Self.pages) { pageAndSettings in
                        let page = pageAndSettings.page
                        let settings = pageAndSettings.settings

                        // Required for there to be a default visual selection
                        if let results = resultsView(page, settings) {
                            results
                        } else if
                            page.name.rawValue.contains(model.searchText.lowercased()) &&
                            !page.isSetting
                        {
                            SettingsPageView(page)
                        } else {
                            SettingsPageView(page)
                        }
                    }
                }
            }
            .navigationSplitViewColumnWidth(215)
            .safeAreaInset(edge: .top, spacing: 0) {
                List {}
                    .frame(height: 35)
                    .searchable(text: $model.searchText, placement: .sidebar, prompt: "Search")
                    .scrollDisabled(true)
            }
        } detail: {
            Group {
                switch selectedPage.name {
                case .general:
                    GeneralSettingsView().environmentObject(updater)
                case .accounts:
                    AccountsSettingsView()
                case .theme:
                    ThemeSettingsView()
                case .textEditing:
                    TextEditingSettingsView()
                case .terminal:
                    TerminalSettingsView()
                case .sourceControl:
                    SourceControlSettingsView()
                case .location:
                    LocationsSettingsView()
                case .featureFlags:
                    FeatureFlagsSettingsView()
                default:
                    Text("Implementation Needed").frame(alignment: .center)
                }
            }
            .navigationSplitViewColumnWidth(500)
            .hideSidebarToggle()
            .onAppear {
                model.backButtonVisible = false
            }
        }
        .navigationTitle(selectedPage.name.rawValue)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                if !model.backButtonVisible {
                    Rectangle()
                        .frame(width: 10)
                        .opacity(0)
                } else {
                    EmptyView()
                }
            }
        }
        .environmentObject(model)
        .onAppear {
            selectedPage = Self.pages[0].page
        }
    }
}

class SettingsViewModel: ObservableObject {
    @Published var backButtonVisible: Bool = false
    @Published var scrolledToTop: Bool = false
    @Published var searchText: String = ""
}
