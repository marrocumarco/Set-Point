//
//  SettingsImpl.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 14/09/2025.
//

import Foundation

internal class SettingsImpl: Settings {

    private let selectableNumbersOfSets: [Int] = [1, 3, 5]
    private var selectedNumberOfSets: Int = defaultNumberOfSets
    private var tiebreakEnabled: Bool = defaultTiebreakEnabled
    private var settingsChanged: Bool = false

    func setSelectedNumberOfSets(_ numberOfSets: Int, fromUser: Bool) throws {
        if isValid(numberOfSets) {
            if numberOfSetsChanged(numberOfSets) {
                selectedNumberOfSets = numberOfSets
                if fromUser {
                    settingsChanged = true
                }
            }
        } else {
            throw SettingsImplError.invalidNumberOfSets
        }
    }

    func resetSettingsStatus() {
        settingsChanged = false
    }

    private func numberOfSetsChanged(_ numberOfSets: Int) -> Bool {
        return selectedNumberOfSets != numberOfSets
    }

    private func isValid(_ numberOfSets: Int) -> Bool {
        return selectableNumbersOfSets.contains(numberOfSets)
    }

    func getSettingsChanged() -> Bool {
        return settingsChanged
    }

    func getSelectedNumberOfSets() -> Int {
        return selectedNumberOfSets
    }

    func getDefaultNumberOfSets() -> Int {
        return Self.defaultNumberOfSets
    }

    func getSelectableNumberOfSets() -> [Int] {
        return selectableNumbersOfSets
    }

    func setTiebreakEnabled(_ enabled: Bool, fromUser: Bool) {
        if tiebreakEnabled != enabled {
            tiebreakEnabled = enabled
            if fromUser {
                settingsChanged = true
            }
        }
    }

    func getTiebreakEnabled() -> Bool {
        return tiebreakEnabled
    }

    func getDefaultTiebreakEnabled() -> Bool {
        return Self.defaultTiebreakEnabled
    }

    static let defaultNumberOfSets: Int = 5
    static let defaultTiebreakEnabled: Bool = false

    enum SettingsImplError: Error {
        case invalidNumberOfSets
    }
}
