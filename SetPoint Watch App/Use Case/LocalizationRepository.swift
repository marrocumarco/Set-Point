//
//  LocalizationRepository.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 14/09/2025.
//

protocol LocalizationRepository {
    func getPlayer1Name() -> String
    func getPlayer2Name() -> String
    func getConfirmMatchRestartMessage() -> String
    func getConfirmSettingsMessage() -> String
    func getEndedMatchMessage() -> String
    func getGamesCaption() -> String
    func getSetsCaption() -> String
    func getSettingsTitle() -> String
    func getTiebreakText() -> String
    func getNumberOfSetsText() -> String
    func getConfirmTileText() -> String
    func getConfirmCaption() -> String
    func getCancelCaption() -> String
}
