//
//  MatchView.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 29/06/2024.
//

import SwiftUI

struct MatchView: View {
    @State var matchViewModel: MatchViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            PlayersRow(matchViewModel: matchViewModel)
            VStack {
                GamesRow(matchViewModel: matchViewModel)
                SetsRow(matchViewModel: matchViewModel)
            }
            ScoreRow(matchViewModel: matchViewModel)
            SettingsRow(matchViewModel: matchViewModel)
        }.alert(
            matchViewModel.matchEndedCaption,
            isPresented: $matchViewModel.matchEnded,
            actions: {
                Button("ok") {
                    matchViewModel.resetMatch()
                }
                Button("cancel", role: .cancel) {}
            }
        )
    }
}

struct PlayersRow: View {
    @State var matchViewModel: MatchViewModel
    var body: some View {
        HStack(spacing: 10) {
            Text(matchViewModel.player1Name)
            GeometryReader { geometry in
                let player1Serves = matchViewModel.player1Serves
                Image(systemName: "tennisball.fill")
                    .resizable()
                    .foregroundStyle(.accent)
                    .position(CGPoint(x: player1Serves ? 0 : geometry.size.width, y: geometry.size.height / 2))
                    .animation(.easeInOut, value: player1Serves)
                    .frame(width: 10, height: 10)
            }
            Text(matchViewModel.player2Name)
        }.fontWeight(.semibold)
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
        }.fontWeight(.semibold)
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
        }.fontWeight(.semibold)
    }
}

struct ScoreRow: View {
    @State var matchViewModel: MatchViewModel
    var body: some View {
        HStack {
            Group {
                Button(matchViewModel.player1PointsDescription) {
                    matchViewModel.player1Scored()
                }.buttonStyle(.borderedProminent)
                    .foregroundStyle(.black)
                Button(
                    action: {
                        Task {
                            await matchViewModel.undo()
                        }
                    },
                    label: {
                        Image(systemName: "arrow.uturn.backward")
                    }
                ).frame(width: 30)
                    .disabled(!matchViewModel.canUndo)
                Button(matchViewModel.player2PointsDescription) {
                    matchViewModel.player2Scored()
                }.buttonStyle(.borderedProminent)
                    .foregroundStyle(.black)
            }.clipShape(.circle)
                .font(.headline)
        }
    }
}

struct SettingsRow: View {
    @Environment(Coordinator.self) private var coordinator: Coordinator
    @State var matchViewModel: MatchViewModel
    @State var isPresented: Bool = false
    var body: some View {
        HStack {
            Group {
                Button(
                    action: {
                        coordinator.push(page: .settings)
                    },
                    label: { Image(systemName: "gear") }
                ).buttonStyle(.plain)
                    .frame(width: 44)
                Button(
                    action: {
                        isPresented = true
                    },
                    label: { Image(systemName: "restart") }
                ).buttonStyle(.plain)
                    .frame(width: 44)
            }.clipShape(.circle)
                .alert(
                    matchViewModel.resetAlertCaption,
                    isPresented: $isPresented,
                    actions: {
                        Button(
                            "ok",
                            role: .destructive,
                            action: {
                                matchViewModel.resetMatch()
                            }
                        )
                        Button("cancel", role: .cancel) {}
                    }
                )
        }
    }
}
