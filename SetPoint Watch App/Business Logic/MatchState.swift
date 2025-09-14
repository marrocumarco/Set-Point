//
//  MatchState.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 14/09/2025.
//

internal struct MatchState {
    let player1Points: Int
    let player1Games: Int
    let player1Sets: Int
    let player2Points: Int
    let player2Games: Int
    let player2Sets: Int
    let endedSets: [EndedSet]
    let matchEnded: Bool
    let player1GameScoreDescription: String
    let player2GameScoreDescription: String
    let isTiebreak: Bool
    let winner: PlayerScore?
    let player1Serves: Bool
}
