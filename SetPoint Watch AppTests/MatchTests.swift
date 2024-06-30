//
//  MatchTests.swift
//  SetPoint Watch AppTests
//
//  Created by marrocumarco on 29/06/2024.
//

import XCTest
@testable import SetPoint_Watch_App

final class MatchTests: XCTestCase {

    var sut: Match!

    override func setUpWithError() throws {
        sut = Match(player1Name: "Player 1", player2Name: "Player 2")
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_pointWonBy_tiebreak() {
        //given
        sut.player1.points = 0
        sut.isTiebreak = true

        sut.pointWonBy(player: sut.player1)
        XCTAssertFalse(sut.player1Serves)
        XCTAssertEqual(sut.player1GameScoreDescription, "1")
    }

    func test_pointWonBy_player1() {
        //given
        sut.player1.points = 0

        sut.pointWonBy(player: sut.player1)

        XCTAssertEqual(sut.player1GameScoreDescription, "15")
        XCTAssertEqual(sut.player2GameScoreDescription, "0")
    }

    func test_pointWonBy_player2() {
        //given
        sut.player2.points = 2

        sut.pointWonBy(player: sut.player2)

        XCTAssertEqual(sut.player1GameScoreDescription, "0")
        XCTAssertEqual(sut.player2GameScoreDescription, "40")
    }

    func test_pointWonBy_deuce() {
        //given
        sut.player1.points = Point.forthy.rawValue
        sut.player2.points = Point.advantage.rawValue

        sut.pointWonBy(player: sut.player1)

        XCTAssertEqual(sut.player1GameScoreDescription, "40")
        XCTAssertEqual(sut.player2GameScoreDescription, "40")
    }

    func test_checkGameWin_player1() {
        //given
        sut.player1.points = Point.gameWon.rawValue

        sut.checkGameWin(for: sut.player1)

        XCTAssertFalse(sut.player1Serves)
        XCTAssertEqual(sut.player1.games, 1)
        XCTAssertEqual(sut.player2.games, 0)
        XCTAssertEqual(sut.player1GameScoreDescription, "0")
        XCTAssertEqual(sut.player2GameScoreDescription, "0")
    }

    func test_checkGameWin_player2() {
        //given
        sut.player2.points = Point.gameWon.rawValue

        sut.checkGameWin(for: sut.player2)

        XCTAssertFalse(sut.player1Serves)
        XCTAssertEqual(sut.player1.games, 0)
        XCTAssertEqual(sut.player2.games, 1)
        XCTAssertEqual(sut.player1GameScoreDescription, "0")
        XCTAssertEqual(sut.player2GameScoreDescription, "0")
    }

    func test_checkSetWin_player1() {
        //given
        sut.player1.games = 6
        
        sut.checkSetWin(for: sut.player1)

        XCTAssertEqual(sut.endedSets.count, 1)
        XCTAssertEqual(sut.endedSets.first!.id, 1)
        XCTAssertEqual(sut.endedSets.first!.player1Score, 6)
        XCTAssertEqual(sut.endedSets.first!.player2Score, 0)
        XCTAssertEqual(sut.player1.sets, 1)
        XCTAssertEqual(sut.player2.sets, 0)
        XCTAssertEqual(sut.player1.games, 0)
        XCTAssertEqual(sut.player2.games, 0)
        XCTAssertEqual(sut.player1GameScoreDescription, "0")
        XCTAssertEqual(sut.player2GameScoreDescription, "0")
        XCTAssertFalse(sut.isTiebreak)

    }

    func test_checkSetWin_tiebreak_end() {
        //given
        sut.isTiebreak = true
        sut.player1.points = 7

        sut.checkSetWin(for: sut.player1)

        XCTAssertEqual(sut.endedSets.count, 1)
        XCTAssertEqual(sut.endedSets.first!.id, 1)
        XCTAssertEqual(sut.endedSets.first!.player1Score, 1)
        XCTAssertEqual(sut.endedSets.first!.player2Score, 0)
        XCTAssertEqual(sut.player1.sets, 1)
        XCTAssertEqual(sut.player2.sets, 0)
        XCTAssertEqual(sut.player1.games, 0)
        XCTAssertEqual(sut.player2.games, 0)
        XCTAssertEqual(sut.player1GameScoreDescription, "0")
        XCTAssertEqual(sut.player2GameScoreDescription, "0")
        XCTAssertFalse(sut.isTiebreak)

    }

    func test_checkSetWin_tiebreak_start() {
        //given
        sut.player1.games = 6
        sut.player2.games = 6

        sut.checkSetWin(for: sut.player1)

        XCTAssertEqual(sut.endedSets.count, 0)
        XCTAssertEqual(sut.player1.sets, 0)
        XCTAssertEqual(sut.player2.sets, 0)
        XCTAssertEqual(sut.player1.games, 6)
        XCTAssertEqual(sut.player2.games, 6)
        XCTAssertEqual(sut.player1GameScoreDescription, "0")
        XCTAssertEqual(sut.player2GameScoreDescription, "0")
        XCTAssert(sut.isTiebreak)

    }

    func test_checkSetWin_player2() {
        //given
        sut.player2.games = 6

        sut.checkSetWin(for: sut.player2)

        XCTAssertEqual(sut.endedSets.count, 1)
        XCTAssertEqual(sut.endedSets.first!.id, 1)
        XCTAssertEqual(sut.endedSets.first!.player1Score, 0)
        XCTAssertEqual(sut.endedSets.first!.player2Score, 6)
        XCTAssertEqual(sut.player1.sets, 0)
        XCTAssertEqual(sut.player2.sets, 1)
        XCTAssertEqual(sut.player1.games, 0)
        XCTAssertEqual(sut.player2.games, 0)
        XCTAssertEqual(sut.player1GameScoreDescription, "0")
        XCTAssertEqual(sut.player2GameScoreDescription, "0")
        XCTAssertFalse(sut.isTiebreak)
    }

    func test_checkMatchWin() {
        //given
        sut.player1.sets = 3

        sut.checkMatchWin(for: sut.player1)

        XCTAssertEqual(sut.player1.sets, 0)
        XCTAssertEqual(sut.player2.sets, 0)
        XCTAssertEqual(sut.player1.games, 0)
        XCTAssertEqual(sut.player2.games, 0)
        XCTAssertEqual(sut.player1GameScoreDescription, "0")
        XCTAssertEqual(sut.player2GameScoreDescription, "0")
        XCTAssertFalse(sut.showCurrentSetScore)
    }

    func test_calculatePointDescription() {

        let data = [Point.zero : "0", Point.fifteen : "15", Point.thirty : "30", Point.forthy : "40", Point.advantage : "A", Point.gameWon : "W"]

        data.forEach { points in
            //given
            sut.player1.points = points.key.rawValue

            sut.calculatePointDescription(sut.player1)

            XCTAssertEqual(sut.player1GameScoreDescription, points.value)
        }
    }
}
