//
//  Match.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 29/06/2024.
//

import Combine

class Match: ObservableObject {

    var settings = SettingsViewModel()
    var player1: Player
    var player2: Player
    var player1Serves = true

    @Published var endedSets = [EndedSet]()
    @Published var player1GameScoreDescription = Point.zero.rawValue.description
    @Published var player2GameScoreDescription = Point.zero.rawValue.description
    @Published var isTiebreak = false
    @Published var showCurrentSetScore = true

    var isTiebreakEnabled = true
    var numberOfSetsNeededToWin = 3
    var cancellables = [AnyCancellable]()
    init(player1Name: String, player2Name: String) {
        self.player1 = Player(name: player1Name)
        self.player2 = Player(name: player2Name)
        cancellables.append(settings.$tiebreakEnabled.sink {
            self.isTiebreakEnabled = $0
        })
        cancellables.append(settings.$selectedNumberOfSets.sink {
            self.numberOfSetsNeededToWin = ($0 / 2) + 1
        })
    }

    func pointWonBy(player: Player) {
        let opponent = player === player1 ? player2 : player1
        if isTiebreakEnabled && isTiebreak {
            player.points += 1
            checkSetWin(for: player)
            if (player.points + opponent.points) % 2 == 1 {
                player1Serves.toggle()
            }
        } else if player.points + 1 == Point.advantage.rawValue &&
                    opponent.points == Point.advantage.rawValue {
            // deuce: score reset to 40 all
            opponent.points = Point.forthy.rawValue
        } else {
            player.points = (player.points + 1) % 6
            checkGameWin(for: player)
        }

        calculatePointDescription(player)
        calculatePointDescription(opponent)
    }

    func checkGameWin(for player: Player) {
        let opponent = player === player1 ? player2 : player1
        if player.points >= 4 && player.points >= opponent.points + 2 {
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
        var setWin = false
        if isTiebreakEnabled && isTiebreak {
            if player.points >= 7 && player.points >= opponent.points + 2 {
                setWin = true
                player.games += 1
                player.resetPoints()
                opponent.resetPoints()
            }
        } else {
            setWin = player.games >= 6 && player.games >= opponent.games + 2
        }
        if setWin {
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
            isTiebreak = false
            checkMatchWin(for: player)
        } else {
            if isTiebreakEnabled && !isTiebreak && player.games == 6 && opponent.games == 6 {
                isTiebreak = true
                player.resetPoints()
                opponent.resetPoints()
            }
        }
    }

    func checkMatchWin(for player: Player) {
        if player.sets == numberOfSetsNeededToWin {
            player1.resetSets()
            player2.resetSets()
            showCurrentSetScore = false
        }
    }

    internal func calculatePointDescription(_ player: Player) {
        var pointsDescription = ""
        if isTiebreak {
            pointsDescription = player.points.description
        } else if let point = Point(rawValue: player.points) {
            switch point {
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
        }

        if player === player1 {
            player1GameScoreDescription = pointsDescription
        } else {
            player2GameScoreDescription = pointsDescription
        }
    }
}
