//
//  Preferences.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 14/09/2025.
//

import Foundation

internal class Preferences: DataAccess {

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func setSelectedNumberOfSets(_ numberOfSets: Int) {
        userDefaults.set(numberOfSets, forKey: Keys.numberOfSets)
    }

    func getSelectedNumberOfSets(_ defaultValue: Int) -> Int {
        return userDefaults.integer(forKey: Keys.numberOfSets) == 0 && !userDefaults.contains(key: Keys.numberOfSets)
            ? defaultValue
            : userDefaults.integer(forKey: Keys.numberOfSets)
    }

    func setTiebreakEnabled(_ enabled: Bool) {
        userDefaults.set(enabled, forKey: Keys.tiebreakEnabled)
    }

    func getTiebreakEnabled(_ defaultValue: Bool) -> Bool {
        return userDefaults.object(forKey: Keys.tiebreakEnabled) as? Bool ?? defaultValue
    }

    private enum Keys {
        static let numberOfSets = "number_of_sets"
        static let tiebreakEnabled = "tiebreak_enabled"
    }
}

private extension UserDefaults {
    func contains(key: String) -> Bool {
        return object(forKey: key) != nil
    }
}
