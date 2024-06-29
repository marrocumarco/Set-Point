//
//  Match.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 29/06/2024.
//

import Foundation

class Match: ObservableObject {

    var player1: Player
    var player2: Player
    var player1Serves = true

    @Published var endedSets = [EndedSet]()
    @Published var player1GameScoreDescription = Point.zero.rawValue.description
    @Published var player2GameScoreDescription = Point.zero.rawValue.description

    init(player1Name: String, player2Name: String) {
        self.player1 = Player(name: player1Name)
        self.player2 = Player(name: player2Name)
    }

    func pointWonBy(player: Player) {
        let opponent = player === player1 ? player2 : player1
        if player.points.rawValue + 1 == Point.advantage.rawValue &&
            opponent.points.rawValue == Point.advantage.rawValue {
            // deuce
            opponent.points = Point(rawValue: Point.forthy.rawValue) ?? .zero
        } else {
            player.points = Point(rawValue: (player.points.rawValue + 1) % 6) ?? .zero
            checkGameWin(for: player)
        }
        calculatePointDescription(player)
        calculatePointDescription(opponent)
    }

    func checkGameWin(for player: Player) {
        let opponent = player === player1 ? player2 : player1
        if player.points.rawValue >= 4 && player.points.rawValue >= opponent.points.rawValue + 2 {
            player.games += 1
            player.resetPoints()
            opponent.resetPoints()
            player1Serves.toggle()
            calculatePointDescription(player)
            calculatePointDescription(opponent)
            checkSetWin(for: player)
        }
    }

    func checkSetWin(for player: Player) {
        let opponent = player === player1 ? player2 : player1
        if player.games >= 6 && player.games >= opponent.games + 2 {
            player.sets += 1
            endedSets.append(
                EndedSet(
                    id: player1.sets + player2.sets,
                    player1Score: player1.games,
                    player2Score: player2.games
                )
            )
            player.resetGames()
            opponent.resetGames()
            checkMatchWin(for: player)
        }
    }

    func checkMatchWin(for player: Player) {
        if player.sets == 3 {
            player.resetSets()
            player1.resetSets()
            player2.resetSets()
        }
    }

    private func calculatePointDescription(_ player: Player) {
        var pointsDescription = ""
        switch player.points {
        case .zero:
            pointsDescription  = "0"
        case .fifteen:
            pointsDescription  = "15"
        case .thirty:
            pointsDescription  = "30"
        case .forthy:
            pointsDescription  = "40"
        case .advantage:
            pointsDescription  = "A"
        case .gameWon:
            pointsDescription  = "W"
        }
        if player === player1 {
            player1GameScoreDescription = pointsDescription
        } else {
            player2GameScoreDescription = pointsDescription
        }
    }
}
