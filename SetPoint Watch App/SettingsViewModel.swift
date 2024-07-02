//
//  SettingsViewModel.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 02/07/2024.
//

import Foundation

class SettingsViewModel: ObservableObject {

    @Published var tiebreakEnabled = true {
        didSet {
            UserDefaults.standard.setValue(tiebreakEnabled, forKey: "tiebreakEnabled")
        }
    }
    @Published var selectedNumberOfSets = 3

    var numberOfSets = [1, 3, 5]

    init() {
        selectedNumberOfSets = (UserDefaults.standard.object(forKey: "numberOfSets") as? Int) ?? 3
        tiebreakEnabled = (UserDefaults.standard.object(forKey: "tiebreakEnabled") as? Bool) ?? true
    }
    func isSelected(_ numberOfSets: Int) -> Bool {
        numberOfSets == selectedNumberOfSets
    }

    func selectNumberOfSets(_ numberOfSets: Int) {
        selectedNumberOfSets = numberOfSets
        UserDefaults.standard.set(numberOfSets, forKey: "numberOfSets")
    }
}

extension Int: Identifiable {
    public var id: Int { self }
}
