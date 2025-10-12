//
//  MatchUseCaseTest.swift
//  SetPoint Watch AppTests
//
//  Created by marrocumarco on 17/09/2025.
//

import XCTest
@testable import SetPoint_Watch_App

final class MatchUseCaseTest: XCTestCase {

    private var match: (any Match)!
    private var localizationRepository: (any LocalizationRepository)!
    private var matchUseCase: MatchUseCaseImpl!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        match = MockMatch()
        localizationRepository = MockLocalizationRepository()
        matchUseCase = MatchUseCaseImpl(match: match, localizationRepository: localizationRepository)
    }

    // MARK: - Test

    func test_getCanUndo() {
        (match as? MockMatch)?.canUndo = true
        XCTAssertTrue(matchUseCase.canUndo)
    }

    func test_getPlayer1PointsDescription() {
        (match as? MockMatch)?.player1PointsDescription = "15"
        XCTAssertEqual("15", matchUseCase.player1PointsDescription)
    }

    func test_getPlayer2PointsDescription() {
        (match as? MockMatch)?.player2PointsDescription = "15"
        XCTAssertEqual("15", matchUseCase.player2PointsDescription)
    }

    func test_getPlayer1NumberOfSets() {
        (match as? MockMatch)?.player1NumberOfSets = 1
        XCTAssertEqual(1, matchUseCase.player1NumberOfSets)
    }

    func test_getPlayer2NumberOfSets() {
        (match as? MockMatch)?.player2NumberOfSets = 1
        XCTAssertEqual(1, matchUseCase.player2NumberOfSets)
    }

    func test_getPlayer1NumberOfGames() {
        (match as? MockMatch)?.player1NumberOfGames = 1
        XCTAssertEqual(1, matchUseCase.player1NumberOfGames)
    }

    func test_getPlayer2NumberOfGames() {
        (match as? MockMatch)?.player2NumberOfGames = 1
        XCTAssertEqual(1, matchUseCase.player2NumberOfGames)
    }

    func test_getWinnerDescription() {
        (match as? MockMatch)?.winnerDescription = "P1"
        (localizationRepository as? MockLocalizationRepository)?.endedMatchMessage = "Game, set, match"
        XCTAssertEqual("Game, set, match P1", matchUseCase.winnerDescription)
    }

    func test_getMatchEnded() {
        (match as? MockMatch)?.matchEnded = true
        XCTAssertTrue(matchUseCase.matchEnded)
    }

    func test_getEndedSets() {
        let ended = [EndedSet(player1Score: 1, player2Score: 6)]
        (match as? MockMatch)?.endedSets = ended
        XCTAssertEqual(ended, matchUseCase.endedSets)
    }

    func test_getPlayer1Serves() {
        (match as? MockMatch)?.player1Serves = true
        XCTAssertTrue(matchUseCase.player1Serves)
    }

    func test_pointWonByPlayerOne() async throws {
        try await matchUseCase.pointWonByPlayerOne()
        XCTAssertTrue((match as? MockMatch)?.pointWonByPlayerOneCalled ?? false)
    }

    func test_pointWonByPlayerTwo() async throws {
        try await matchUseCase.pointWonByPlayerTwo()
        XCTAssertTrue((match as? MockMatch)?.pointWonByPlayerTwoCalled ?? false)
    }

    func test_resetMatch() async {
        await matchUseCase.resetMatch()
        XCTAssertTrue((match as? MockMatch)?.resetMatchCalled ?? false)
    }

    func test_undo() async throws {
        try await matchUseCase.undo()
        XCTAssertTrue((match as? MockMatch)?.undoCalled ?? false)
    }

    func test_shouldShowResetMatchAlert_true() {
        (match as? MockMatch)?.shouldRestartMatch = true
        XCTAssertTrue(matchUseCase.shouldShowResetMatchAlert())
    }

    func test_shouldShowResetMatchAlert_false() {
        (match as? MockMatch)?.shouldRestartMatch = false
        XCTAssertFalse(matchUseCase.shouldShowResetMatchAlert())
    }

    func test_showConfirmSettingsAlert_true() {
        (match as? MockMatch)?.shouldRestartMatch = true
        XCTAssertTrue(matchUseCase.showConfirmSettingsAlert)
    }

    func test_showConfirmSettingsAlert_false() {
        (match as? MockMatch)?.shouldRestartMatch = false
        XCTAssertFalse(matchUseCase.showConfirmSettingsAlert)
    }

    func test_player1FinalScoreDescription_correctFormat() {
        let ended = [EndedSet(player1Score: 6, player2Score: 4), EndedSet(player1Score: 7, player2Score: 5)]
        (match as? MockMatch)?.endedSets = ended
        XCTAssertEqual("6 7", matchUseCase.player1FinalScoreDescription)
    }

    func test_player2FinalScoreDescription_correctFormat() {
        let ended = [EndedSet(player1Score: 6, player2Score: 4), EndedSet(player1Score: 7, player2Score: 5)]
        (match as? MockMatch)?.endedSets = ended
        XCTAssertEqual("4 5", matchUseCase.player2FinalScoreDescription)
    }
}
