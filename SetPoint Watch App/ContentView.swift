//
//  ContentView.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 29/06/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var match: Match
    @State var showRestartAlert = false

    var body: some View {
        NavigationStack {
            VStack {
                let alignment: VerticalAlignment = match.player1Serves ? .firstTextBaseline : .lastTextBaseline
                HStack(alignment: alignment) {
                    Image(systemName: "tennisball.fill")
                        .resizable()
                        .foregroundStyle(.accent)
                        .frame(width: 12, height: 12)
                        .animation(Animation.easeInOut(duration: 0.5).delay(0), value: match.player1Serves)
                    Group {
                        VStack {
                            Text("P1")
                            Text("P2")
                        }.bold()
                        ForEach(match.endedSets) { set in
                            ScoreStack(
                                player1Score: set.player1Score.description,
                                player2Score: set.player2Score.description
                            )
                        }
                        if match.showCurrentSetScore {
                            ScoreStack(
                                player1Score: match.player1.games.description,
                                player2Score: match.player2.games.description
                            )
                        }
                    }.font(.title3)
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
                Spacer()
            }.toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingsView(settingsViewModel: match.settings)) {
                        Image(systemName: "gear")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Text("Restart").foregroundStyle(.accent)
                        .onTapGesture {
                            showRestartAlert = true
                        }
                        .alert("resetAlert", isPresented: $showRestartAlert) {
                            Button("Ok", role: .destructive) { match.resetMatch() }
                            Button("cancel", role: .cancel) {  }
                    }
                }
            }.alert("gameSetMatch \(match.winner?.name ?? "")", isPresented: $match.showEndedMatchAlert) {
                Button("Ok", role: .destructive) { match.resetMatch() }
                Button("cancel", role: .cancel) {  }
            }
        }
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
