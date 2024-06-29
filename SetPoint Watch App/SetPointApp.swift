//
//  SetPointApp.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 29/06/2024.
//

import SwiftUI

@main
struct SetPointWatchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(match: Match(player1Name: "Player 1", player2Name: "Player 2"))
        }
    }
}
