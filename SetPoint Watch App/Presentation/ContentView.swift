//
//  ContentView.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 29/06/2024.
//

import SwiftUI

struct ContentView: View {
    @Environment(MatchViewModel.self) private var matchViewModel: MatchViewModel

    var body: some View {
        VStack(alignment: .center) {
            PlayersRow()
            GamesRow()
            SetsRow()
            ScoreRow()
            SettingsRow()
        }
    }
}

struct PlayersRow: View {
    @Environment(MatchViewModel.self) private var matchViewModel: MatchViewModel
    var body: some View {
        HStack {
            Text(matchViewModel.matchUseCase.player1Name)
            Spacer()
            Text(matchViewModel.matchUseCase.player2Name)
        }
    }
}

struct GamesRow: View {
    var body: some View {
        HStack {
            Text("3")
            Spacer()
            Text("Games")
            Spacer()
            Text("2")
        }
    }
}

struct SetsRow: View {
    var body: some View {
        HStack {
            Text("1")
            Spacer()
            Text("Sets")
            Spacer()
            Text("0")
        }
    }
}

struct ScoreRow: View {
    var body: some View {
        HStack {
            Group {
                Button("10") {}
                Button(action: {}) {
                    Image(systemName: "arrow.uturn.backward")
                }.frame(width: 44)
                Button("20") {}
            }.clipShape(.circle)
        }
    }
}

struct SettingsRow: View {
    var body: some View {
        HStack {
            Group {
                Button(action: {}, label: { Image(systemName: "gear") }).frame(width: 44)
                Button(action: {}, label: { Image(systemName: "restart") }).frame(width: 44)
            }.clipShape(.circle)
        }
    }
}

#Preview {
    ContentView()
}
