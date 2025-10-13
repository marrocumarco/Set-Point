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
        selectableNumberOfSets = calculateSelectableNumberOfSets()
        selectedNumberOfSets = settingsUseCase.getSelectedNumberOfSets().description
    }

    var tiebreakEnabled: Bool = false
    var settingsTitle: String { settingsUseCase.settingsTitle }
    
    var selectableNumberOfSets: [SelectableNumberOfSets] = []

    var selectedNumberOfSets: String = ""

    func setTiebreakEnabled(_ isEnabled: Bool) {
        settingsUseCase.setTiebreakEnabled(isEnabled)
    }

    func setSelectedNumberOfSets(_ numberOfSets: String) {
        do {
            if let numberOfSetsInt = Int(numberOfSets) {
                try settingsUseCase.setSelectedNumberOfSets(numberOfSetsInt)
                selectableNumberOfSets = calculateSelectableNumberOfSets()
                selectedNumberOfSets = settingsUseCase.getSelectedNumberOfSets().description
            }
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
