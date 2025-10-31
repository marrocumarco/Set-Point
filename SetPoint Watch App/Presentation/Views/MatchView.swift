//
//  MatchView.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 29/06/2024.
//

import SwiftUI

struct MatchView: View {
    @State var matchViewModel: MatchViewModel
    @State var selection = 0
    var body: some View {
        TabView(selection: $selection) {

            VStack(alignment: .center, spacing: 5) {
                Spacer()
                PlayersRow(matchViewModel: matchViewModel)
                    .fontWeight(.medium)
                    .foregroundStyle(.cyan)
                VStack {
                    GamesRow(matchViewModel: matchViewModel)
                    SetsRow(matchViewModel: matchViewModel)
                }.fontWeight(.medium)
                ScoreRow(matchViewModel: matchViewModel)
            }.tag(0)
                .padding(12)
                .font(.title2)
                .alert(
                    matchViewModel.matchEndedCaption,
                    isPresented: $matchViewModel.matchEnded,
                    actions: {
                        Button("ok") {
                            matchViewModel.resetMatch()
                        }
                        Button("cancel", role: .cancel) {}
                    }
                )

            SettingsRow(matchViewModel: matchViewModel, selection: $selection)
                .tag(1)

        }.tabViewStyle(.carousel)
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
                    .frame(width: 15, height: 15)
            }
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
                .foregroundStyle(.accent)
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
                .foregroundStyle(.accent)
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
                .buttonStyle(.borderedProminent)
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
                )
                .buttonStyle(.plain)
                //                .frame(width: 30)
                .disabled(!matchViewModel.canUndo)
                Button(matchViewModel.player2PointsDescription) {
                    matchViewModel.player2Scored()
                }
                .fontWeight(.medium)
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.black)
            }.clipShape(.circle)
        }
    }
}

struct SettingsRow: View {
    @Environment(Coordinator.self) private var coordinator: Coordinator
    @State var matchViewModel: MatchViewModel
    @State var isPresented: Bool = false
    @State var selection: Binding<Int>
    var body: some View {
        VStack {
            HStack {
                Group {
                    VStack {
                        Button(
                            action: {
                                coordinator.push(page: .settings)
                            },
                            label: {
                                Image(systemName: "gear")
                            }
                        )
                        Text("settings_title")
                    }
                    VStack {
                        Button(
                            action: {
                                isPresented = true
                            },
                            label: { Image(systemName: "restart") }
                        )
                        .foregroundStyle(.red)
                        Text("Restart")
                    }
                }
                .alert(
                    matchViewModel.resetAlertCaption,
                    isPresented: $isPresented,
                    actions: {
                        Button(
                            "ok",
                            role: .destructive,
                            action: {
                                matchViewModel.resetMatch()
                                selection.wrappedValue = 0
                            }
                        )
                        Button("cancel", role: .cancel) {}
                    }
                )
            }
            Spacer()
        }.padding()
    }
}
