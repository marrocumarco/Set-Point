//
//  LocalizationRepositoryImpl.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 14/09/2025.
//

import Foundation

class LocalizationRepositoryImpl: LocalizationRepository {

    func getPlayer1Name() -> String {
        String(localized: "player1")
    }

    func getPlayer2Name() -> String {
        String(localized: "player2")
    }

    func getConfirmMatchRestartMessage() -> String {
        String(localized: "confirm_match_reset")
    }

    func getConfirmSettingsMessage() -> String {
        String(localized: "confirm_settings")
    }

    func getEndedMatchMessage() -> String {
        String(localized: "ended_match")
    }

    func getPlayAgainMessage() -> String {
        String(localized: "play_again")
    }

    func getGamesCaption() -> String {
        String(localized: "games")
    }

    func getSetsCaption() -> String {
        String(localized: "sets")
    }

    func getSettingsTitle() -> String {
        String(localized: "settings_title")
    }

    func getTiebreakText() -> String {
        String(localized: "tiebreak")
    }

    func getNumberOfSetsText() -> String {
        String(localized: "sets")
    }

    func getConfirmCaption() -> String {
        String(localized: "yes")
    }

    func getCancelCaption() -> String {
        String(localized: "no")
    }
}
