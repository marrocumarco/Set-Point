//
//  SettingsTest.swift
//  SetPoint Watch AppTests
//
//  Created by marrocumarco on 04/07/2024.
//

import XCTest
@testable import SetPoint_Watch_App
final class SettingsTest: XCTestCase {

    var sut: SettingsViewModel!

    override func setUpWithError() throws {
        sut = SettingsViewModel(defaults: MockUserDefaults(valueFound: true))
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_init_valuesFoundInDefaults() throws {
        XCTAssert(sut.selectedNumberOfSets == 1)
        XCTAssertFalse(sut.tiebreakEnabled)
    }

    func test_init_valuesNotFoundInDefaults() throws {
        sut = SettingsViewModel(defaults: MockUserDefaults(valueFound: false))

        XCTAssert(sut.selectedNumberOfSets == 3)
        XCTAssert(sut.tiebreakEnabled)
    }

    func test_isSelected_true() throws {
        //given
        sut.selectedNumberOfSets = 3

        XCTAssert(sut.isSelected(3))
    }

    func test_isSelected_false() throws {
        //given
        sut.selectedNumberOfSets = 1

        XCTAssertFalse(sut.isSelected(3))
    }

    func test_selectNumberOfSets() throws {
        //given
        sut.selectedNumberOfSets = 1

        sut.selectNumberOfSets(5)

        XCTAssertEqual(sut.selectedNumberOfSets, 5)
    }

    func test_checkValuesChanges_true_tiebreak() {
        sut.tiebreakEnabled = true

        XCTAssert(sut.checkValuesChanged())
    }

    func test_checkValuesChanges_true_numberOfSets() {
        sut.selectedNumberOfSets = 3

        XCTAssert(sut.checkValuesChanged())
    }

    func test_checkValuesChanges_false() {
        sut.selectedNumberOfSets = 1
        sut.tiebreakEnabled = false

        XCTAssertFalse(sut.checkValuesChanged())
    }

    func test_saveValues() {
        sut.saveValues()

        XCTAssert(sut.requireMatchRestart)
    }

    func test_discardValues() {
        sut.selectedNumberOfSets = 3
        sut.tiebreakEnabled = true

        sut.discardValues()

        XCTAssertEqual(sut.selectedNumberOfSets, 1)
        XCTAssertFalse(sut.tiebreakEnabled)
    }
    
    func test_discardValues_valuesNotFoundInDefaults() {
        sut = SettingsViewModel(defaults: MockUserDefaults(valueFound: false))
        sut.selectedNumberOfSets = 1
        sut.tiebreakEnabled = false

        sut.discardValues()

        XCTAssertEqual(sut.selectedNumberOfSets, 3)
        XCTAssert(sut.tiebreakEnabled)
    }
}
