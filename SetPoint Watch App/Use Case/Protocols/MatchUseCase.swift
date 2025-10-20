//
//  MatchUseCase.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 16/09/2025.
//

import Foundation

protocol MatchUseCase {
    var confirmCaption: String { get }
    var cancelCaption: String { get }
    var gamesCaption: String { get }
    var setsCaption: String { get }
    var player1Name: String { get }
    var player2Name: String { get }
    var showConfirmSettingsAlert: Bool { get }
    var canUndo: Bool { get }
    var player1PointsDescription: String { get }
    var player2PointsDescription: String { get }
    var player1NumberOfSets: Int { get }
    var player2NumberOfSets: Int { get }
    var player1NumberOfGames: Int { get }
    var player2NumberOfGames: Int { get }
    var matchEndedCaption: String { get }
    var confirmMatchResetCaption: String { get }
    var player1FinalScoreDescription: String { get }
    var player2FinalScoreDescription: String { get }
    var matchEnded: Bool { get }
    var endedSets: [EndedSet] { get }
    var player1Serves: Bool { get }

    func pointWonByPlayerOne() async throws
    func pointWonByPlayerTwo() async throws
    func resetMatch() async
    func undo() async throws
    func shouldShowResetMatchAlert() -> Bool
}
