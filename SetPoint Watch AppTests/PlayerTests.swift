//
//  PlayerTests.swift
//  SetPoint Watch AppTests
//
//  Created by marrocumarco on 30/06/2024.
//

import XCTest
@testable import SetPoint_Watch_App

final class PlayerTests: XCTestCase {

    var sut: Player!

    override func setUpWithError() throws {
        sut = Player(name: "Player1")
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_resetPoints() {
        // given
        sut.points = Point.forthy.rawValue

        sut.resetPoints()

        XCTAssertEqual(sut.points, 0)
    }

    func test_reseGames() {
        // given
        sut.games = 4

        sut.resetGames()

        XCTAssertEqual(sut.games, 0)
    }

    func test_reseSets() {
        // given
        sut.sets = 4

        sut.resetSets()

        XCTAssertEqual(sut.sets, 0)
    }
}
