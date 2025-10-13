//
//  SettingsViewModel.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 02/07/2024.
//

import Foundation

@Observable
class SettingsViewModel {
    internal init(settingsUseCase: any SettingsUseCase) {
        self.settingsUseCase = settingsUseCase
    }

    var tiebreakEnabled: Bool = false
    private let settingsUseCase: any SettingsUseCase
    var selectableNumberOfSets: [String] {
        settingsUseCase.getSelectableNumberOfSets().map { $0.description }
    }
}
