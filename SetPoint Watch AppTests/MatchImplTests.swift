//
//  MatchImplTests.swift
//  SetPoint Watch AppTests
//
//  Created by marrocumarco on 29/06/2024.
//

import XCTest
@testable import SetPoint_Watch_App

final class MatchImplTest: XCTestCase {

    private var match: MatchImpl!
    private var settings: SettingsStub!

    override func setUp() {
        super.setUp()
        settings = SettingsStub()
        settings.tiebreakEnabled = true
        settings.selectedNumberOfSets = 3
        match = MatchImpl(settings: settings)
    }

    func test_resetMatch_shouldResetTheMatch() async {
        await goToDeuce()
        await match.resetMatch()

        XCTAssertEqual(0, match.player1NumberOfSets)
        XCTAssertEqual(0, match.player2NumberOfSets)
        XCTAssertEqual(0, match.endedSets.count)
        XCTAssertFalse(match.matchEnded)
        XCTAssertTrue(match.player1Serves)
        XCTAssertFalse(match.shouldRestartMatch)
        XCTAssertTrue(settings.resetCalled)
    }

    func test_pointWonByPlayerOne_shouldIncrementPlayer1Points() async {
        await match.pointWonByPlayerOne()
        XCTAssertEqual("15", match.player1PointsDescription)
    }

    func test_pointWonByPlayerOne_player1ShouldGoToAdvantage() async {
        await goToDeuce()
        await match.pointWonByPlayerOne()
        XCTAssertEqual("A", match.player1PointsDescription)
    }

    func test_pointWonByPlayerTwo_shouldIncrementPlayer2Points() async {
        await match.pointWonByPlayerTwo()
        XCTAssertEqual("15", match.player2PointsDescription)
    }

    func test_pointWonByPlayerOne_shouldIncrementPlayer1Points_tiebreakMode() async {
        await goToTiebreak()
        await match.pointWonByPlayerOne()
        XCTAssertEqual("1", match.player1PointsDescription)
    }

    func test_undo_shouldDecrementPoints() async throws {
        await match.pointWonByPlayerOne()
        try await match.undo()
        XCTAssertEqual("0", match.player1PointsDescription)
    }

    func test_undo_shouldThrowExceptionIfNoPreviousState() async {
        await XCTAssertThrowsErrorAsync {
            try await self.match.undo()
        }
    }

    func test_canUndo_shouldReturnTrueIfThereArePointsToUndo() async {
        await match.pointWonByPlayerOne()
        XCTAssertTrue(match.canUndo)
    }

    func test_canUndo_shouldReturnFalseIfThereAreNoPointsToUndo() async {
        XCTAssertFalse(match.canUndo)
    }

    func test_player2GameScoreDescription_shouldReturnThePlayer2Points() async {
        await match.pointWonByPlayerTwo()
        XCTAssertEqual("15", match.player2PointsDescription)
    }

    func test_matchWin_shouldSetMatchEnded() async {
        await repeatAsync(24 * 2) { await self.match.pointWonByPlayerOne() }
        XCTAssertTrue(match.matchEnded)
    }

    func test_tiebreakWin_shouldEndSet() async {
        await goToTiebreak()
        await repeatAsync(7) { await self.match.pointWonByPlayerOne() }
        XCTAssertEqual(1, match.player1NumberOfSets)
    }

    func test_deuce_shouldResetScoreToForty() async {
        await repeatAsync(3) { await self.match.pointWonByPlayerOne() }
        await repeatAsync(3) { await self.match.pointWonByPlayerTwo() }
        await match.pointWonByPlayerOne()
        await match.pointWonByPlayerTwo()
        XCTAssertEqual("40", match.player1PointsDescription)
        XCTAssertEqual("40", match.player2PointsDescription)
    }

    func test_advantage_shouldSetAdvantageScore() async {
        await repeatAsync(3) { await self.match.pointWonByPlayerOne() }
        await repeatAsync(3) { await self.match.pointWonByPlayerTwo() }
        await match.pointWonByPlayerOne()
        XCTAssertEqual("A", match.player1PointsDescription)
    }

    func test_gameWin_shouldResetGameScore() async {
        await repeatAsync(4) { await self.match.pointWonByPlayerOne() }
        XCTAssertEqual("0", match.player1PointsDescription)
        XCTAssertEqual("0", match.player2PointsDescription)
    }

    func test_player1NumberOfGames_shouldReturnCorrectValue() async {
        await repeatAsync(4) { await self.match.pointWonByPlayerOne() }
        XCTAssertEqual(1, match.player1NumberOfGames)
    }

    func test_player2NumberOfGames_shouldReturnCorrectValue() async {
        await repeatAsync(4) { await self.match.pointWonByPlayerTwo() }
        XCTAssertEqual(1, match.player2NumberOfGames)
    }

    func test_player1NumberOfSets_shouldReturnCorrectValue() async {
        await repeatAsync(24) { await self.match.pointWonByPlayerOne() }
        XCTAssertEqual(1, match.player1NumberOfSets)
    }

    func test_player2NumberOfSets_shouldReturnCorrectValue() async {
        await repeatAsync(24) { await self.match.pointWonByPlayerTwo() }
        XCTAssertEqual(1, match.player2NumberOfSets)
    }

    func test_winnerDescription_shouldReturnCorrectValue() async {
        await repeatAsync(24 * 2) { await self.match.pointWonByPlayerOne() }
        XCTAssertEqual("P1", match.winnerDescription)
    }

    func test_matchEnded_shouldReturnCorrectValue() async {
        await repeatAsync(24 * 2) { await self.match.pointWonByPlayerOne() }
        XCTAssertTrue(match.matchEnded)
    }

    func test_endedSets_shouldReturnCorrectValue() async {
        await repeatAsync(24) { await self.match.pointWonByPlayerOne() }
        XCTAssertEqual(1, match.endedSets.count)
    }

    func test_player1Serves_shouldReturnCorrectValue() async {
        XCTAssertTrue(match.player1Serves)
    }

    // MARK: - Helpers

    private func goToDeuce() async {
        await match.pointWonByPlayerOne()
        await match.pointWonByPlayerOne()
        await match.pointWonByPlayerOne()
        await match.pointWonByPlayerTwo()
        await match.pointWonByPlayerTwo()
        await match.pointWonByPlayerTwo()
    }

    private func goToTiebreak() async {
        await repeatAsync(4 * 5) { await self.match.pointWonByPlayerOne() }
        await repeatAsync(4 * 5) { await self.match.pointWonByPlayerTwo() }
        await repeatAsync(4) { await self.match.pointWonByPlayerOne() }
        await repeatAsync(4) { await self.match.pointWonByPlayerTwo() }
    }

    private func repeatAsync(_ times: Int, action: @escaping () async -> Void) async {
        for _ in 0..<times { await action() }
    }
}

// MARK: - Stub Settings
private class SettingsStub: Settings {
    var tiebreakEnabled = true
    var selectedNumberOfSets = 3
    var resetCalled = false

    func setSelectedNumberOfSets(_ numberOfSets: Int, fromUser: Bool) { }
    func getSelectedNumberOfSets() -> Int { selectedNumberOfSets }
    func getDefaultNumberOfSets() -> Int { 3 }
    func getSelectableNumberOfSets() -> [Int] { [1, 3, 5] }
    func setTiebreakEnabled(_ enabled: Bool, fromUser: Bool) { }
    func getTiebreakEnabled() -> Bool { tiebreakEnabled }
    func getDefaultTiebreakEnabled() -> Bool { true }
    func getSettingsChanged() -> Bool { false }
    func resetSettingsStatus() { resetCalled = true }
}

// MARK: - Async Throws Helper
extension XCTestCase {
    func XCTAssertThrowsErrorAsync(_ expression: @escaping () async throws -> Void,
                                   _ message: @autoclosure () -> String = "",
                                   file: StaticString = #filePath,
                                   line: UInt = #line) async {
        do {
            try await expression()
            XCTFail(message(), file: file, line: line)
        } catch { /* expected */ }
    }
}
