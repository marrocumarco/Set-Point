//
//  Player.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 29/06/2024.
//

import Foundation

enum Point: Int {
    case zero = 0
    case fifteen = 1
    case thirty = 2
    case forthy = 3
    case advantage = 4
    case gameWon = 5
}

class Player {
    var points = 0
    var games: Int = 0
    var sets: Int = 0
    let name: String

    init(name: String) {
        self.name = name
    }

    func resetPoints() {
        self.points = .zero
    }

    func resetGames() {
        self.games = 0
    }

    func resetSets() {
        self.sets = 0
    }
}
