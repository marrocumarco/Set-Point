//
//  SettingsUseCaseTests.swift
//  SetPoint Watch AppTests
//
//  Created by marrocumarco on 17/09/2025.
//

import XCTest
@testable import SetPoint_Watch_App

final class SettingsUseCaseTest: XCTestCase {

    private var settings: (any Settings)!
    private var dataAccess: (any DataAccess)!
    private var localizationRepository: (any LocalizationRepository)!
    private var settingsUseCase: SettingsUseCaseImpl!

    final class MockDataAccess: DataAccess {
        // Valori di ritorno configurabili
        var getSelectedNumberOfSetsReturn: Int = 0
        var getTiebreakEnabledReturn: Bool = false

        // Tracciamento chiamate
        private(set) var setSelectedNumberOfSetsArgs: [Int] = []
        private(set) var setTiebreakEnabledArgs: [Bool] = []
        private(set) var getSelectedNumberOfSetsDefaultsPassed: [Int] = []
        private(set) var getTiebreakEnabledDefaultsPassed: [Bool] = []

        // API usate nei test
        func setSelectedNumberOfSets(_ numberOfSets: Int) { setSelectedNumberOfSetsArgs.append(numberOfSets) }
        func setTiebreakEnabled(_ enabled: Bool) { setTiebreakEnabledArgs.append(enabled) }

        func getSelectedNumberOfSets(_ defaultValue: Int) -> Int {
            getSelectedNumberOfSetsDefaultsPassed.append(defaultValue)
            return getSelectedNumberOfSetsReturn
        }
        func getTiebreakEnabled(_ defaultValue: Bool) -> Bool {
            getTiebreakEnabledDefaultsPassed.append(defaultValue)
            return getTiebreakEnabledReturn
        }
    }

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        settings = MockSettings()
        dataAccess = MockDataAccess()
        localizationRepository = MockLocalizationRepository()
        settingsUseCase = try? SettingsUseCaseImpl(
            settings: settings,
            dataAccess: dataAccess,
            localizationRepository: localizationRepository
        )
    }

    // MARK: - Test

    func test_getSelectableNumberOfSets() {
         (settings as? MockSettings)?.selectableNumberOfSetsReturn = [3, 5]

        let result = settingsUseCase.getSelectableNumberOfSets()

        XCTAssertEqual([3, 5], result)
        XCTAssertTrue( (settings as? MockSettings)?.getSelectableNumberOfSetsCalled ?? false)
    }

    func test_setSelectedNumberOfSets() throws {
        let numberOfSets = 3

        try settingsUseCase.setSelectedNumberOfSets(numberOfSets)

        let calls = (settings as? MockSettings)?.setSelectedNumberOfSetsArgs
        XCTAssertEqual(2, calls?.count)
        XCTAssertEqual(3, calls?.last?.0)
        XCTAssertTrue(calls?.last?.1 ?? false) // fromUser == true
    }

    func test_getSelectedNumberOfSets() {
         (settings as? MockSettings)?.selectedNumberOfSets = 3

        let result = settingsUseCase.getSelectedNumberOfSets()

        XCTAssertEqual(3, result)
    }

    func test_setTiebreakEnabled() {
        let enabled = true

        settingsUseCase.setTiebreakEnabled(enabled)

        let calls =  (settings as? MockSettings)?.setTiebreakEnabledArgs
        XCTAssertEqual(2, calls?.count)
        XCTAssertEqual(true, calls?[1].0)
        XCTAssertTrue(calls?[1].1 ?? false) // fromUser == true
    }

    func test_getTiebreakEnabled() {
         (settings as? MockSettings)?.tiebreakEnabled = true

        let result = settingsUseCase.getTiebreakEnabled()

        XCTAssertTrue(result)
    }

    func test_confirmSettings_savesCurrentSettings() {
         (settings as? MockSettings)?.selectedNumberOfSets = 3
         (settings as? MockSettings)?.tiebreakEnabled = true

        settingsUseCase.confirmSettings()

        let dataAccess = dataAccess as? MockDataAccess
        XCTAssertEqual([3], dataAccess?.setSelectedNumberOfSetsArgs)
        XCTAssertEqual([true], dataAccess?.setTiebreakEnabledArgs)
    }

    func test_resetToLastSavedSettings_resetsToSavedValues() throws {
        let settings =  (settings as? MockSettings)
        let dataAccess = (dataAccess as? MockDataAccess)

        settings?.defaultNumberOfSets = 3
        settings?.defaultTiebreakEnabled = true

        dataAccess?.getSelectedNumberOfSetsReturn = 5
        dataAccess?.getTiebreakEnabledReturn = false

        try settingsUseCase.resetToLastSavedSettings()

        // verify(settings).setSelectedNumberOfSets(5, false)
        XCTAssertEqual(2, settings?.setSelectedNumberOfSetsArgs.count)
        XCTAssertEqual(5, settings?.setSelectedNumberOfSetsArgs.last?.0)
        XCTAssertFalse(settings?.setSelectedNumberOfSetsArgs.last?.1 ?? true)

        // verify(settings, times(2)).setTiebreakEnabled(false, false)
        XCTAssertEqual(2, settings?.setTiebreakEnabledArgs.count)
        XCTAssertEqual(false, settings?.setTiebreakEnabledArgs[0].0)
        XCTAssertFalse(settings?.setTiebreakEnabledArgs[0].1 ?? true)
        XCTAssertEqual(false, settings?.setTiebreakEnabledArgs[1].0)
        XCTAssertFalse(settings?.setTiebreakEnabledArgs[1].1 ?? true)

        // verify(settings).resetSettingsStatus()
        XCTAssertTrue(settings?.resetSettingsStatusCalled ?? false)
    }

    func test_showConfirmSettingsAlert_settingsChanged_returnsTrue() {
         (settings as? MockSettings)?.settingsChanged = true

        let result = settingsUseCase.showConfirmSettingsAlert()

        XCTAssertTrue(result)
    }

    func test_showConfirmSettingsAlert_settingsNotChanged_returnsFalse() {
         (settings as? MockSettings)?.settingsChanged = false

        let result = settingsUseCase.showConfirmSettingsAlert()

        XCTAssertFalse(result)
    }
}
