//
//  MockMatch.swift
//  SetPoint Watch AppTests
//
//  Created by marrocumarco on 17/09/2025.
//

import Foundation
@testable import SetPoint_Watch_App

final class MockMatch: Match {
    // Proprietà lette dai test
    var canUndo: Bool = false
    var player1PointsDescription: String = "0"
    var player2PointsDescription: String = "0"
    var player1NumberOfSets: Int = 0
    var player2NumberOfSets: Int = 0
    var player1NumberOfGames: Int = 0
    var player2NumberOfGames: Int = 0
    var winnerDescription: String = ""
    var matchEnded: Bool = false
    var endedSets: [EndedSet] = []
    var player1Serves: Bool = true
    var shouldRestartMatch: Bool = false

    // Flag per "verify(...)"
    private(set) var pointWonByPlayerOneCalled = false
    private(set) var pointWonByPlayerTwoCalled = false
    private(set) var resetMatchCalled = false
    private(set) var undoCalled = false

    // Metodi invocati dai test
    func pointWonByPlayerOne() { pointWonByPlayerOneCalled = true }
    func pointWonByPlayerTwo() { pointWonByPlayerTwoCalled = true }
    func resetMatch() { resetMatchCalled = true }
    func undo() { undoCalled = true }
}
