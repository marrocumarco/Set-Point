//
//  Coordinator.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 12/10/2025.
//

import SwiftUI

@Observable
final class Coordinator {

    var path: NavigationPath = NavigationPath()
    var sheet: Sheet?

    private let settings = SettingsImpl()
    private let localizationRepository = LocalizationRepositoryImpl()
    private let settingsViewModel: SettingsViewModel

    internal init(path: NavigationPath = NavigationPath()) {
        self.path = path
        do {
            settingsViewModel = SettingsViewModel(
                settingsUseCase: try SettingsUseCaseImpl(
                    settings: settings,
                    dataAccess: Preferences(),
                    localizationRepository: localizationRepository
                )
            )
        } catch {
            fatalError("Failed to initialize SettingsViewModel")
        }
    }

    func push(page: AppPage) {
        path.append(page)
    }

    func present(_ sheet: Sheet) {
        self.sheet = sheet
    }

    func dismissSheet() {
        sheet = nil
    }

    @MainActor @ViewBuilder
    func build(page: AppPage) -> some View {
        switch page {
        case .match:
            ContentView(
                matchViewModel: MatchViewModel(
                    matchUseCase: MatchUseCaseImpl(
                        match: MatchImpl(settings: settings),
                        localizationRepository: localizationRepository
                    )
                )
            )
        case .settings:
            SettingsView(settingsViewModel: settingsViewModel)
        }
    }

    @MainActor @ViewBuilder
    func buildSheet(sheet: Sheet) -> some View {
        switch sheet {
        case .numberOfSetsSelection(let options):
            SelectNumberOfSetsView(settingsViewModel: settingsViewModel, selectableNumberOfSets: options)
        }
    }
}
