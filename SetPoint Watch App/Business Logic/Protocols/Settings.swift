//
//  Settings.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 14/09/2025.
//

import Foundation

protocol Settings {
    func setSelectedNumberOfSets(_ numberOfSets: Int, fromUser: Bool) throws
    func getSelectedNumberOfSets() -> Int
    func getDefaultNumberOfSets() -> Int
    func getSelectableNumberOfSets() -> [Int]
    func setTiebreakEnabled(_ enabled: Bool, fromUser: Bool)
    func getTiebreakEnabled() -> Bool
    func getDefaultTiebreakEnabled() -> Bool
    func getSettingsChanged() -> Bool
    func resetSettingsStatus()
}
