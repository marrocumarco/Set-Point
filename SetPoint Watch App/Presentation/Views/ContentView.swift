//
//  ContentView.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 29/06/2024.
//

import SwiftUI

struct ContentView: View {
    @State var matchViewModel: MatchViewModel
    var body: some View {
        VStack(alignment: .center) {
            PlayersRow(matchViewModel: matchViewModel)
            GamesRow(matchViewModel: matchViewModel)
            SetsRow(matchViewModel: matchViewModel)
            ScoreRow(matchViewModel: matchViewModel)
            SettingsRow(matchViewModel: matchViewModel)
        }
    }
}

struct PlayersRow: View {
    @State var matchViewModel: MatchViewModel
    var body: some View {
        HStack {
            Text(matchViewModel.player1Name)
            Spacer()
            Text(matchViewModel.player2Name)
        }
    }
}

struct GamesRow: View {
    @State var matchViewModel: MatchViewModel
    var body: some View {
        HStack {
            Text(matchViewModel.player1NumberOfGames.description)
            Spacer()
            Text(matchViewModel.gamesCaption)
            Spacer()
            Text(matchViewModel.player2NumberOfGames.description)
        }
    }
}

struct SetsRow: View {
    @State var matchViewModel: MatchViewModel
    var body: some View {
        HStack {
            Text(matchViewModel.player1NumberOfSets.description)
            Spacer()
            Text(matchViewModel.setsCaption)
            Spacer()
            Text(matchViewModel.player2NumberOfSets.description)
        }
    }
}

struct ScoreRow: View {
    @State var matchViewModel: MatchViewModel
    var body: some View {
        HStack {
            Group {
                Button(matchViewModel.player1PointsDescription) {
                    matchViewModel.player1Scored()
                }
                Button(action: {
                    Task {
                        await matchViewModel.undo()
                    }}) {
                    Image(systemName: "arrow.uturn.backward")
                }.frame(width: 44)
                    .disabled(!matchViewModel.canUndo)
                Button(matchViewModel.player2PointsDescription) {
                    matchViewModel.player2Scored()
                }
            }.clipShape(.circle)
        }
    }
}

struct SettingsRow: View {
    @Environment(Coordinator.self) private var coordinator: Coordinator
    @State var matchViewModel: MatchViewModel

    var body: some View {
        HStack {
            Group {
                Button(action: {
                    coordinator.push(page: .settings)
                }, label: { Image(systemName: "gear") }).frame(width: 44)
                Button(action: {
                    matchViewModel.resetMatch()
                }, label: { Image(systemName: "restart") }).frame(width: 44)
            }.clipShape(.circle)
        }
    }
}

#Preview {
}
