//
//  MatchImpl.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 14/09/2025.
//

import Foundation

internal class MatchImpl: Match {

    let settings: Settings

    private var playerScore1 = PlayerScore("P1")
    private var playerScore2 = PlayerScore("P2")
    private var statesStack: [MatchState] = []

    private(set) var player1Serves: Bool = true
    private(set) var endedSets: [EndedSet] = []
    private(set) var matchEnded: Bool = false
    private(set) var player1PointsDescription: String = String(Point.ZERO.rawValue)
    var shouldRestartMatch: Bool { settings.getSettingsChanged() }
    private(set) var player2PointsDescription: String = String(Point.ZERO.rawValue)
    var player1NumberOfGames: Int { playerScore1.games }
    var player2NumberOfGames: Int { playerScore2.games }
    var player1NumberOfSets: Int { playerScore1.sets }
    var player2NumberOfSets: Int { playerScore2.sets }
    private var isTiebreak: Bool = false
    private var winner: PlayerScore?
    var winnerDescription: String { winner?.name ?? "" }
    private var isTiebreakEnabled: Bool { settings.getTiebreakEnabled() }
    private var numberOfSetsNeededToWin: Int { (settings.getSelectedNumberOfSets() / 2) + 1 }
    var canUndo: Bool { !statesStack.isEmpty }

    init(settings: Settings) {
        self.settings = settings
    }

    func pointWonByPlayerOne() async {
        pointWonBy(playerScore1, opponent: playerScore2)
    }

    func pointWonByPlayerTwo() async {
        pointWonBy(playerScore2, opponent: playerScore1)
    }

    func undo() async throws {
        guard let state = getPreviousState() else {
            throw MatchImplError.noPreviousState
        }
        apply(state)
    }

    private func apply(_ state: MatchState) {
        playerScore1 = PlayerScore("P1", state.player1Points, state.player1Games, state.player1Sets)
        playerScore2 = PlayerScore("P2", state.player2Points, state.player2Games, state.player2Sets)
        player1Serves = state.player1Serves
        endedSets.removeAll()
        endedSets.append(contentsOf: state.endedSets)
        matchEnded = state.matchEnded
        player1PointsDescription = state.player1GameScoreDescription
        player2PointsDescription = state.player2GameScoreDescription
        isTiebreak = state.isTiebreak
        winner = state.winner
    }

    private func getPreviousState() -> MatchState? {
        return statesStack.popLast()
    }

    private func pointWonBy(_ playerScore: PlayerScore, opponent: PlayerScore) {
        saveOldState()
        if isTiebreakMode {
            addPointInTiebreakMode(playerScore, opponent: opponent)
        } else if needToResetScoreToDeuce(playerScore, opponent: opponent) {
            resetScoreToForty(opponent)
        } else {
            addPointTo(playerScore)
            checkGameWin(playerScore, opponent: opponent)
        }
        updateScoreDescriptions()
    }

    private var isTiebreakMode: Bool {
        isTiebreakEnabled && isTiebreak
    }

    private func addPointInTiebreakMode(_ playerScore: PlayerScore, opponent: PlayerScore) {
        playerScore.points += 1
        checkSetWin(playerScore, opponent: opponent)
        if needToSwitchPlayerOnServiceDuringTiebreak(playerScore, opponent: opponent) {
            switchPlayerOnService()
        }
    }

    private func needToSwitchPlayerOnServiceDuringTiebreak(_ playerScore: PlayerScore,
                                                           opponent: PlayerScore) -> Bool {
        return ((playerScore.points + opponent.points) % 2) == 1
    }

    private func needToResetScoreToDeuce(_ playerScore: PlayerScore,
                                         opponent: PlayerScore) -> Bool {
        return playerScore.points + 1 == Point.ADVANTAGE.rawValue &&
               opponent.points == Point.ADVANTAGE.rawValue
    }

    private func resetScoreToForty(_ opponent: PlayerScore) {
        opponent.points = Point.FORTY.rawValue
    }

    private func addPointTo(_ playerScore: PlayerScore) {
        playerScore.points = (playerScore.points + 1) % 6
    }

    private func checkGameWin(_ playerScore: PlayerScore, opponent: PlayerScore) {
        if gameEnded(playerScore, opponent: opponent) {
            increaseGamesCounter(playerScore)
            resetGameScore(playerScore, opponent: opponent)
            switchPlayerOnService()
            updateScoreDescriptions()
            checkSetWin(playerScore, opponent: opponent)
        }
    }

    private func switchPlayerOnService() {
        player1Serves.toggle()
    }

    private func increaseGamesCounter(_ playerScore: PlayerScore) {
        playerScore.games += 1
    }

    private func gameEnded(_ playerScore: PlayerScore,
                           opponent: PlayerScore) -> Bool {
        return playerScore.points >= 4 && playerScore.points >= opponent.points + 2
    }

    private func checkSetWin(_ playerScore: PlayerScore, opponent: PlayerScore) {
        var setEnded = false
        if isTiebreakMode {
            if tiebreakEnded(playerScore, opponent: opponent) {
                setEnded = true
                increaseGamesCounter(playerScore)
                resetGameScore(playerScore, opponent: opponent)
            }
        } else {
            setEnded = setEndedFunc(playerScore, opponent: opponent)
        }
        handleEndedSet(setEnded, playerScore: playerScore, opponent: opponent)
    }

    private func handleEndedSet(_ setEnded: Bool,
                                playerScore: PlayerScore,
                                opponent: PlayerScore) {
        if setEnded {
            increaseSetsCounter(playerScore)
            archiveEndedSet()
            resetPlayersGames(playerScore, opponent: opponent)
            isTiebreak = false
            checkMatchWin(playerScore)
        } else {
            if shouldEnableTiebreak(playerScore, opponent: opponent) {
                isTiebreak = true
                resetGameScore(playerScore, opponent: opponent)
            }
        }
    }

    private func archiveEndedSet() {
        endedSets.append(
            EndedSet(
                player1Score: playerScore1.games,
                player2Score: playerScore2.games
            )
        )
    }

    private func shouldEnableTiebreak(_ playerScore: PlayerScore,
                                      opponent: PlayerScore) -> Bool {
        return isTiebreakEnabled &&
               !isTiebreak &&
               playerScore.games == 6 &&
               opponent.games == 6
    }

    private func resetPlayersGames(_ playerScore: PlayerScore,
                                   opponent: PlayerScore) {
        playerScore.resetGames()
        opponent.resetGames()
    }

    private func increaseSetsCounter(_ playerScore: PlayerScore) {
        playerScore.sets += 1
    }

    private func setEndedFunc(_ playerScore: PlayerScore,
                              opponent: PlayerScore) -> Bool {
        return playerScore.games >= 6 && playerScore.games >= opponent.games + 2
    }

    private func tiebreakEnded(_ playerScore: PlayerScore,
                               opponent: PlayerScore) -> Bool {
        return playerScore.points >= 7 && playerScore.points >= opponent.points + 2
    }

    private func resetGameScore(_ playerScore: PlayerScore,
                                opponent: PlayerScore) {
        playerScore.resetPoints()
        opponent.resetPoints()
    }

    private func checkMatchWin(_ playerScore: PlayerScore) {
        if playerScore.sets == numberOfSetsNeededToWin {
            winner = playerScore
            matchEnded = true
        }
    }

    private func saveOldState() {
        let state = createNewState()
        store(state)
    }

    private func createNewState() -> MatchState {
        return MatchState(
            player1Points: playerScore1.points,
            player1Games: playerScore1.games,
            player1Sets: playerScore1.sets,
            player2Points: playerScore2.points,
            player2Games: playerScore2.games,
            player2Sets: playerScore2.sets,
            endedSets: endedSets,
            matchEnded: matchEnded,
            player1GameScoreDescription: player1PointsDescription,
            player2GameScoreDescription: player2PointsDescription,
            isTiebreak: isTiebreak,
            winner: winner,
            player1Serves: player1Serves
        )
    }

    private func store(_ state: MatchState) {
        statesStack.append(state)
    }

    func resetMatch() async {
        resetGameScore(playerScore1, opponent: playerScore2)
        resetSetScore()
        resetMatchScore()
        resetFlags()
        updateScoreDescriptions()
        resetStatesStack()
        resetSettingsStatus()
    }

    private func resetFlags() {
        isTiebreak = false
        matchEnded = false
        player1Serves = true
    }

    private func resetMatchScore() {
        playerScore1.resetSets()
        playerScore2.resetSets()
        endedSets.removeAll()
    }

    private func resetSetScore() {
        playerScore1.resetGames()
        playerScore2.resetGames()
    }

    private func updateScoreDescriptions() {
        player1PointsDescription = calculatePointDescription(playerScore1)
        player2PointsDescription = calculatePointDescription(playerScore2)
    }

    private func resetStatesStack() {
        statesStack.removeAll()
    }

    private func resetSettingsStatus() {
        settings.resetSettingsStatus()
    }

    private func calculatePointDescription(_ playerScore: PlayerScore) -> String {
        if isTiebreak {
            return String(playerScore.points)
        } else {
            switch playerScore.points {
            case Point.ZERO.rawValue:     return "0"
            case Point.FIFTEEN.rawValue:  return "15"
            case Point.THIRTY.rawValue:   return "30"
            case Point.FORTY.rawValue:    return "40"
            case Point.ADVANTAGE.rawValue:
                return "A"
            default:                   return ""
            }
        }
    }

    enum MatchImplError: Error {
        case noPreviousState
    }
}
