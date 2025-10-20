//
//  SettingsUseCase.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 25/09/2025.
//

import Foundation

protocol SettingsUseCase {
    var settingsTitle: String { get }
    var tiebreakText: String { get }
    var numberOfSetsText: String { get }
    var confirmSettingsCaption: String { get }

    func getSelectableNumberOfSets() -> [Int]
    func setSelectedNumberOfSets(_ numberOfSets: Int) throws
    func getSelectedNumberOfSets() -> Int
    func setTiebreakEnabled(_ enabled: Bool)
    func getTiebreakEnabled() -> Bool
    func confirmSettings()
    func resetToLastSavedSettings() throws
    func showConfirmSettingsAlert() -> Bool
}
