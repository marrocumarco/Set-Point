//
//  SettingsViewModel.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 02/07/2024.
//

import Foundation

@Observable
class SettingsViewModel {
    private let settingsUseCase: any SettingsUseCase

    internal init(settingsUseCase: any SettingsUseCase) {
        self.settingsUseCase = settingsUseCase
        updateState()
    }

    var tiebreakEnabled: Bool = false
    var settingsTitle: String { settingsUseCase.settingsTitle }
    var selectableNumberOfSets: [SelectableNumberOfSets] = []
    var selectedNumberOfSets: String = ""
    var showConfirmSettingsAlert = false

    var settingsConfirmationMessage: String { settingsUseCase.confirmSettingsCaption }

    private func updateState() {
        selectableNumberOfSets = calculateSelectableNumberOfSets()
        selectedNumberOfSets = settingsUseCase.getSelectedNumberOfSets().description
        tiebreakEnabled = settingsUseCase.getTiebreakEnabled()
        showConfirmSettingsAlert = settingsUseCase.showConfirmSettingsAlert()
    }

    func setTiebreakEnabled(_ isEnabled: Bool) {
        settingsUseCase.setTiebreakEnabled(isEnabled)
        updateState()
    }

    func setSelectedNumberOfSets(_ numberOfSets: String) {
        do {
            if let numberOfSetsInt = Int(numberOfSets) {
                try settingsUseCase.setSelectedNumberOfSets(numberOfSetsInt)
                updateState()
            }
        } catch {
            print(error)
        }
    }

    func confirmSettings() {
        settingsUseCase.confirmSettings()
    }

    func resetToLastSavedSettings() {
        do {
            try settingsUseCase.resetToLastSavedSettings()
            updateState()
        } catch {
            print(error)
        }

    }

    private func calculateSelectableNumberOfSets() -> [SelectableNumberOfSets] {
        return settingsUseCase.getSelectableNumberOfSets().map {
            let numberOfSets = settingsUseCase.getSelectedNumberOfSets()
            let isSelected = $0 == numberOfSets
            return SelectableNumberOfSets(numberOfSets: $0.description, isSelected: isSelected)
        }
    }
}

struct SelectableNumberOfSets: Identifiable, Hashable {
    var id: String {
        numberOfSets + isSelected.description
    }

    let numberOfSets: String
    let isSelected: Bool
}
