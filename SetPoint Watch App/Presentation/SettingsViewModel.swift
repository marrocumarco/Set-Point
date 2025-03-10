//
//  SettingsViewModel.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 02/07/2024.
//

import Foundation

class SettingsViewModel: ObservableObject {

    @Published var tiebreakEnabled = true
    @Published var selectedNumberOfSets = 3
    @Published var showAlert = false
    @Published var requireMatchRestart = false

    var numberOfSets = [1, 3, 5]
    let defaults: Defaults

    init(defaults: Defaults) {
        self.defaults = defaults
        selectedNumberOfSets = (defaults.object(forKey: "numberOfSets") as? Int) ?? 3
        tiebreakEnabled = (defaults.object(forKey: "tiebreakEnabled") as? Bool) ?? true
    }

    func isSelected(_ numberOfSets: Int) -> Bool {
        numberOfSets == selectedNumberOfSets
    }

    func selectNumberOfSets(_ numberOfSets: Int) {
        selectedNumberOfSets = numberOfSets
    }

    func checkValuesChanged() -> Bool {
        if tiebreakEnabled != defaults.object(forKey: "tiebreakEnabled") as? Bool ||
            selectedNumberOfSets != defaults.object(forKey: "numberOfSets") as? Int {
            showAlert = true
            return true
        }
        return false
    }

    func saveValues() {
        defaults.setValue(tiebreakEnabled, forKey: "tiebreakEnabled")
        defaults.set(selectedNumberOfSets, forKey: "numberOfSets")
        requireMatchRestart = true
    }

    func discardValues() {
        selectedNumberOfSets = (defaults.object(forKey: "numberOfSets") as? Int) ?? 3
        tiebreakEnabled = (defaults.object(forKey: "tiebreakEnabled") as? Bool) ?? true
    }
}

extension Int: @retroactive Identifiable {
    public var id: Int { self }
}

protocol Defaults {
    func object(forKey defaultName: String) -> Any?
    func setValue(_ value: Any?, forKey key: String)
    func set(_ value: Int, forKey defaultName: String)
}

extension UserDefaults: Defaults {}

struct MockUserDefaults: Defaults {
    func set(_ value: Int, forKey defaultName: String) {}
    func object(forKey defaultName: String) -> Any? {
        guard valueFound else { return nil }
        switch defaultName {
        case "numberOfSets":
            return 1
        case "tiebreakEnabled":
            return false
        default:
            return nil
        }
    }
    func setValue(_ value: Any?, forKey key: String) {}

    let valueFound: Bool
}
