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
    private(set) var canUndo: Bool = false
    private(set) var matchUseCase: any MatchUseCase

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
            await matchUseCase.pointWonByPlayerOne()
            updateView()
        }
    }

    func player2Scored() {
        Task {
            await matchUseCase.pointWonByPlayerTwo()
            updateView()
        }
    }

    func resetMatch() {
        Task {
            await matchUseCase.resetMatch() //TODO: - show alert before reset
            updateView()
        }
    }

    func openSettings() {
        
    }

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
    }
}
