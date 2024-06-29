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

    init?(rawValue: Int) {
        switch rawValue {
        case 0:
            self = Point.zero
        case 1:
            self = Point.fifteen
        case 2:
            self = Point.thirty
        case 3:
            self = Point.forthy
        case 4:
            self = Point.advantage
        case 5:
            self = Point.gameWon
        default:
            self = Point.zero
        }
    }
}

class Player {
    var points: Point = .zero
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
