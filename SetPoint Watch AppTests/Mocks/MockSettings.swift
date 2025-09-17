//
//  MockSettings.swift
//  SetPoint Watch AppTests
//
//  Created by marrocumarco on 17/09/2025.
//

import Foundation
@testable import SetPoint_Watch_App

final class MockSettings: Settings {
    // Stato configurabile/ritornato dai getter
    var selectableNumberOfSetsReturn: [Int] = []
    var selectedNumberOfSets: Int = 0
    var tiebreakEnabled: Bool = false
    var defaultNumberOfSets: Int = 3
    var defaultTiebreakEnabled: Bool = true
    var settingsChanged: Bool = false

    // Tracciamento chiamate per "verify(...)"
    private(set) var getSelectableNumberOfSetsCalled = false
    private(set) var setSelectedNumberOfSetsArgs: [(Int, Bool)] = []
    private(set) var setTiebreakEnabledArgs: [(Bool, Bool)] = []
    private(set) var resetSettingsStatusCalled = false

    // API usate nei test
    func getSelectableNumberOfSets() -> [Int] {
        getSelectableNumberOfSetsCalled = true
        return selectableNumberOfSetsReturn
    }
    func setSelectedNumberOfSets(_ numberOfSets: Int, fromUser: Bool) {
        setSelectedNumberOfSetsArgs.append((numberOfSets, fromUser))
        selectedNumberOfSets = numberOfSets
    }
    func getSelectedNumberOfSets() -> Int { selectedNumberOfSets }

    func setTiebreakEnabled(_ enabled: Bool, fromUser: Bool) {
        setTiebreakEnabledArgs.append((enabled, fromUser))
        tiebreakEnabled = enabled
    }
    func getTiebreakEnabled() -> Bool { tiebreakEnabled }

    func getDefaultNumberOfSets() -> Int { defaultNumberOfSets }
    func getDefaultTiebreakEnabled() -> Bool { defaultTiebreakEnabled }

    func getSettingsChanged() -> Bool { settingsChanged }
    func resetSettingsStatus() { resetSettingsStatusCalled = true }
}
