//
//  SettingsImplTest.swift
//  SetPoint Watch AppTests
//
//  Created by marrocumarco on 04/07/2024.
//

import XCTest
@testable import SetPoint_Watch_App

final class SettingsImplTest: XCTestCase {

    private var settings: SettingsImpl!

    override func setUp() {
        super.setUp()
        settings = SettingsImpl()
    }

    func test_setSelectedNumberOfSets_validNumberOfSets_fromUser_success() throws {
        try settings.setSelectedNumberOfSets(5, fromUser: true)
        XCTAssertEqual(5, settings.getSelectedNumberOfSets())
        XCTAssertTrue(settings.getSettingsChanged())
    }

    func test_setSelectedNumberOfSets_validNumberOfSets_notFromUser_success() throws {
        try settings.setSelectedNumberOfSets(3, fromUser: false)
        XCTAssertEqual(3, settings.getSelectedNumberOfSets())
        XCTAssertFalse(settings.getSettingsChanged())
    }

    func test_setSelectedNumberOfSets_invalidNumberOfSets_throwsException() {
        XCTAssertThrowsError(try settings.setSelectedNumberOfSets(2, fromUser: true))
    }

    func test_getSelectedNumberOfSets_defaultValue() {
        XCTAssertEqual(SettingsImpl.defaultNumberOfSets, settings.getSelectedNumberOfSets())
    }

    func test_setTiebreakEnabled_notFromUser_true() {
        settings.setTiebreakEnabled(true, fromUser: false)
        XCTAssertTrue(settings.getTiebreakEnabled())
        XCTAssertFalse(settings.getSettingsChanged())
    }

    func test_setTiebreakEnabled_fromUser_true() {
        settings.setTiebreakEnabled(false, fromUser: true)
        XCTAssertFalse(settings.getTiebreakEnabled())
        XCTAssertTrue(settings.getSettingsChanged())
    }

    func test_setTiebreakEnabled_false() {
        settings.setTiebreakEnabled(false, fromUser: true)
        XCTAssertFalse(settings.getTiebreakEnabled())
    }

    func test_getSettingsChanged_selectedNumberOfSets_fromUser_true() throws {
        try settings.setSelectedNumberOfSets(5, fromUser: true)
        XCTAssertTrue(settings.getSettingsChanged())
    }

    func test_getSettingsChanged_selectedNumberOfSets_notFromUser_true() throws {
        try settings.setSelectedNumberOfSets(3, fromUser: false)
        let result = settings.getSettingsChanged()
        XCTAssertFalse(result)
    }

    func test_getSettingsChanged_tiebreakEnabled_fromUser_true() {
        settings.setTiebreakEnabled(false, fromUser: true)
        let result = settings.getSettingsChanged()
        XCTAssertTrue(result)
    }

    func test_getSettingsChanged_tiebreakEnabled_fromUser_false() {
        let tiebreakEnabled = settings.getTiebreakEnabled()
        settings.setTiebreakEnabled(tiebreakEnabled, fromUser: true)
        let result = settings.getSettingsChanged()
        XCTAssertFalse(result)
    }

    func test_getSettingsChanged_tiebreakEnabled_notFromUser_false() {
        let tiebreakEnabled = settings.getTiebreakEnabled()
        settings.setTiebreakEnabled(tiebreakEnabled, fromUser: true)
        let result = settings.getSettingsChanged()
        XCTAssertFalse(result)
    }

    func test_getSettingsChanged_selectedNumberOfSets_fromUser_false() throws {
        let selected = settings.getSelectedNumberOfSets()
        try settings.setSelectedNumberOfSets(selected, fromUser: true)
        let result = settings.getSettingsChanged()
        XCTAssertFalse(result)
    }

    func test_getSettingsChanged_selectedNumberOfSets_notFromUser_false() throws {
        let selected = settings.getSelectedNumberOfSets()
        try settings.setSelectedNumberOfSets(selected, fromUser: true)
        let result = settings.getSettingsChanged()
        XCTAssertFalse(result)
    }

    func test_resetSettingsStatus_fromUser_success() {
        let tiebreak = settings.getTiebreakEnabled()
        settings.setTiebreakEnabled(!tiebreak, fromUser: true)
        settings.resetSettingsStatus()
        let result = settings.getSettingsChanged()
        XCTAssertFalse(result)
    }

    func test_resetSettingsStatus_notFromUser_success() {
        let tiebreak = settings.getTiebreakEnabled()
        settings.setTiebreakEnabled(!tiebreak, fromUser: false)
        settings.resetSettingsStatus()
        let result = settings.getSettingsChanged()
        XCTAssertFalse(result)
    }

    func test_setSelectedNumberOfSets_invalidNumberOfSets_notFromUser_throwsException() {
        XCTAssertThrowsError(try settings.setSelectedNumberOfSets(23, fromUser: false))
    }

    func test_setTiebreakEnabled_notFromUser_false() {
        settings.setTiebreakEnabled(false, fromUser: false)
        XCTAssertFalse(settings.getTiebreakEnabled())
        XCTAssertFalse(settings.getSettingsChanged())
    }

    func test_resetSettingsStatus_afterChange_success() throws {
        try settings.setSelectedNumberOfSets(3, fromUser: true)
        settings.resetSettingsStatus()
        XCTAssertFalse(settings.getSettingsChanged())
    }

    func test_resetSettingsStatus_noChange_success() {
        settings.resetSettingsStatus()
        XCTAssertFalse(settings.getSettingsChanged())
    }

    func test_getSelectableNumberOfSets_containsValidNumbers() {
        let selectable = settings.getSelectableNumberOfSets()
        XCTAssertEqual([1, 3, 5], selectable)
    }

    func test_getSelectableNumberOfSets_notEmpty() {
        let selectable = settings.getSelectableNumberOfSets()
        XCTAssertFalse(selectable.isEmpty)
    }

    func test_getSelectableNumberOfSets_containsDefaultNumberOfSets() {
        let selectable = settings.getSelectableNumberOfSets()
        XCTAssertTrue(selectable.contains(SettingsImpl.defaultNumberOfSets))
    }

    func test_getDefaultNumberOfSets_returnsDefaultValue() {
        XCTAssertEqual(SettingsImpl.defaultNumberOfSets, settings.getDefaultNumberOfSets())
    }

    func test_getDefaultNumberOfSets_isPositive() {
        XCTAssertTrue(settings.getDefaultNumberOfSets() > 0)
    }

    func test_getDefaultTiebreakEnabled_returnsDefaultValue() {
        XCTAssertEqual(SettingsImpl.defaultTiebreakEnabled, settings.getDefaultTiebreakEnabled())
    }
}
