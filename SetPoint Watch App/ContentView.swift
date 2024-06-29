//
//  ContentView.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 29/06/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var match: Match
    var body: some View {
        VStack {
            HStack {
                ForEach(match.endedSets) {
                    set in
                    ScoreStack(player1Score: set.player1Score.description, player2Score: set.player2Score.description)
                }
                ScoreStack(player1Score: match.player1.games.description, player2Score: match.player2.games.description)
                Spacer()
            }
            VStack {
                Button(match.player1GameScoreDescription) {
                    match.pointWonBy(player: match.player1)
                }
                Button(match.player2GameScoreDescription) {
                    match.pointWonBy(player: match.player2)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView(match: Match(player1Name: "1", player2Name: "2"))
}


struct ScoreStack: View {
    var player1Score: String
    var player2Score: String
    var body: some View {
        VStack {
            Text(player1Score)
            Text(player2Score)
        }
    }
}
