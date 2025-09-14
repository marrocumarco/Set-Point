//
//  PlayerScore.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 14/09/2025.
//

internal class PlayerScore {

    let name: String
    var points: Int
    var games: Int
    var sets: Int

    init(_ name: String, _ points: Int = 0, _ games: Int = 0, _ sets: Int = 0) {
        self.name = name
        self.points = points
        self.games = games
        self.sets = sets
    }

    func resetPoints() {
        points = 0
    }

    func resetGames() {
        games = 0
    }

    func resetSets() {
        sets = 0
    }
}
