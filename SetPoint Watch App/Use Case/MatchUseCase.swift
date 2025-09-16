//
//  MatchUseCase.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 14/09/2025.
//

import Foundation

internal class MatchUseCase {

    private let match: any Match
    private let localizationRepository: any LocalizationRepository

    init(match: any Match, localizationRepository: any LocalizationRepository) {
        self.match = match
        self.localizationRepository = localizationRepository
    }

    var confirmCaption: String {
        localizationRepository.getConfirmCaption()
    }

    var cancelCaption: String {
        localizationRepository.getCancelCaption()
    }

    var gamesCaption: String {
        localizationRepository.getGamesCaption()
    }

    var setsCaption: String {
        localizationRepository.getSetsCaption()
    }

    var player1Name: String {
        localizationRepository.getPlayer1Name()
    }

    var player2Name: String {
        localizationRepository.getPlayer2Name()
    }

    var showConfirmSettingsAlert: Bool {
        match.shouldRestartMatch
    }

    var canUndo: Bool {
        match.canUndo
    }

    var player1PointsDescription: String {
        match.player1PointsDescription
    }

    var player2PointsDescription: String {
        match.player2PointsDescription
    }

    var player1NumberOfSets: Int {
        match.player1NumberOfSets
    }

    var player2NumberOfSets: Int {
        match.player2NumberOfSets
    }

    var player1NumberOfGames: Int {
        match.player1NumberOfGames
    }

    var player2NumberOfGames: Int {
        match.player2NumberOfGames
    }

    var winnerDescription: String {
        getFormattedWinnerDescription(match.winnerDescription)
    }

    var player1FinalScoreDescription: String {
        match.endedSets.map { "\($0.player1Score)" }.joined(separator: " ")
    }

    var player2FinalScoreDescription: String {
        match.endedSets.map { "\($0.player2Score)" }.joined(separator: " ")
    }

    var matchEnded: Bool {
        match.matchEnded
    }

    var endedSets: [EndedSet] {
        match.endedSets
    }

    var player1Serves: Bool {
        match.player1Serves
    }

    private func getFormattedWinnerDescription(_ winnerName: String) -> String {
        localizationRepository.getEndedMatchMessage() + " " + winnerName
    }

    func pointWonByPlayerOne() async {
        await match.pointWonByPlayerOne()
    }

    func pointWonByPlayerTwo() async {
        await match.pointWonByPlayerTwo()
    }

    func resetMatch() async {
        await match.resetMatch()
    }

    func undo() async throws {
        try await match.undo()
    }

    func shouldShowResetMatchAlert() -> Bool {
        match.shouldRestartMatch
    }
}
