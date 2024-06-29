//
//  Match.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 29/06/2024.
//

import Foundation

struct EndedSet: Identifiable {
    let id: Int
    let player1Score: Int
    let player2Score: Int
}

class Match: ObservableObject {
    var player1: Player
    var player2: Player

    @Published var endedSets = [EndedSet]()
    @Published var player1GameScoreDescription = "0"
    @Published var player2GameScoreDescription = "0"

    init(player1Name: String, player2Name: String) {
        self.player1 = Player(name: player1Name)
        self.player2 = Player(name: player2Name)
    }

    func pointWonBy(player: Player) {
        let opponent = player === player1 ? player2 : player1
        if player.points.rawValue + 1 == Point.advantage.rawValue && opponent.points.rawValue == Point.advantage.rawValue {
            //deuce
            opponent.points = Point(rawValue: Point.forthy.rawValue) ?? .zero
        } else {
            player.points = Point(rawValue: player.points.rawValue + 1) ?? .zero
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
            player1GameScoreDescription = "0"
            player2GameScoreDescription = "0"
            checkSetWin(for: player)
        }
    }

    func checkSetWin(for player: Player) {
        let opponent = player === player1 ? player2 : player1
        if player.games >= 6 && player.games >= opponent.games + 2 {
            player.sets += 1
            endedSets.append(EndedSet(id: player1.sets + player2.sets, player1Score: player1.games, player2Score: player2.games))
            player.resetGames()
            opponent.resetGames()
            checkMatchWin(for: player)
        }
    }

    func checkMatchWin(for player: Player) {
        if player.sets == 3 {
            print("\(player.name) wins the match!")
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

    func score() -> String {
        let pointsDescription = ["0", "15", "30", "40", "Advantage"]
        var scoreDescription = "\(player1.name): \(player1.sets) sets, \(player1.games) games, \(pointsDescription[min(player1.points.rawValue, 4)]) points\n"
        scoreDescription += "\(player2.name): \(player2.sets) sets, \(player2.games) games, \(pointsDescription[min(player2.points.rawValue, 4)]) points"
        return scoreDescription
    }
}
