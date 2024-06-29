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
            let alignment: VerticalAlignment = match.player1Serves ? .firstTextBaseline : .lastTextBaseline
            HStack(alignment: alignment) {
                Circle().frame(width: 10, height: 10)
                        .animation(Animation.easeInOut(duration: 0.5).delay(0), value: match.player1Serves)
                VStack {
                    Text("P1")
                    Text("P2")
                }
                ForEach(match.endedSets) { set in
                    ScoreStack(player1Score: set.player1Score.description, player2Score: set.player2Score.description)
                }
                if match.showCurrentSetScore {
                    ScoreStack(
                        player1Score: match.player1.games.description,
                        player2Score: match.player2.games.description
                    )
                }
                Spacer()
            }
            HStack {
                Spacer()
                VStack {
                    Button(match.player1GameScoreDescription) {
                        match.pointWonBy(player: match.player1)
                    }
                    Button(match.player2GameScoreDescription) {
                        match.pointWonBy(player: match.player2)
                    }
                }.font(.title)
                Spacer()
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
