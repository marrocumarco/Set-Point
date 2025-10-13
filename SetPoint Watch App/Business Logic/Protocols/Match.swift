//
//  Match.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 14/09/2025.
//

import Foundation

protocol Match {
    func resetMatch() async
    func pointWonByPlayerOne() async throws
    func pointWonByPlayerTwo() async throws

    func undo() async throws

    var shouldRestartMatch: Bool { get }
    var canUndo: Bool { get }
    var player1PointsDescription: String { get }
    var player2PointsDescription: String { get }
    var player1NumberOfGames: Int { get }
    var player2NumberOfGames: Int { get }
    var player1NumberOfSets: Int { get }
    var player2NumberOfSets: Int { get }
    var winnerDescription: String { get }
    var matchEnded: Bool { get }
    var endedSets: [EndedSet] { get }
    var player1Serves: Bool { get }
}
