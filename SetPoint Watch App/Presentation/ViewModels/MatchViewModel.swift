//
//  Match.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 29/06/2024.
//

import Combine
import Foundation

@Observable
@MainActor
class MatchViewModel {

    internal init(matchUseCase: any MatchUseCase) {
        self.matchUseCase = matchUseCase
        updateView()
    }

    private(set) var player1Name: String = ""
    private(set) var player2Name: String = ""
    private(set) var player1PointsDescription: String = ""
    private(set) var player2PointsDescription: String = ""
    private(set) var player1NumberOfGames: String = ""
    private(set) var player2NumberOfGames: String = ""
    private(set) var player1NumberOfSets: String = ""
    private(set) var player2NumberOfSets: String = ""
    private(set) var gamesCaption: String = ""
    private(set) var setsCaption: String = ""
    private(set) var player1Serves = true

    var matchEndedCaption: String {
        matchUseCase.matchEndedCaption
    }
    private(set) var canUndo: Bool = false

    var matchEnded: Bool = false

    private(set) var matchUseCase: any MatchUseCase

    var resetAlertCaption: String {
        matchUseCase.confirmMatchResetCaption
    }

    func undo() async {
        do {
            try await matchUseCase.undo()
            updateView()
        } catch {
            print(error)
        }
    }

    func player1Scored() {
        Task {
            do {
                try await matchUseCase.pointWonByPlayerOne()
                updateView()
            } catch {
                print(error)
            }
        }
    }

    func player2Scored() {
        Task {
            do {
                try await matchUseCase.pointWonByPlayerTwo()
                updateView()
            } catch {
                print(error)
            }
        }
    }

    func resetMatch() {
        Task {
            await matchUseCase.resetMatch()
            updateView()
        }
    }

    func openSettings() {}

    private func updateView() {
        player1Name = matchUseCase.player1Name
        player2Name = matchUseCase.player2Name
        player1PointsDescription = matchUseCase.player1PointsDescription
        player2PointsDescription = matchUseCase.player2PointsDescription
        player1NumberOfGames = matchUseCase.player1NumberOfGames.description
        player2NumberOfGames = matchUseCase.player2NumberOfGames.description
        player1NumberOfSets = matchUseCase.player1NumberOfSets.description
        player2NumberOfSets = matchUseCase.player2NumberOfSets.description
        gamesCaption = matchUseCase.gamesCaption
        setsCaption = matchUseCase.setsCaption
        canUndo = matchUseCase.canUndo
        matchEnded = matchUseCase.matchEnded
        player1Serves = matchUseCase.player1Serves
    }
}
