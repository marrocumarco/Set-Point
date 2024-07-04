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
}
