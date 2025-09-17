//
//  MockLocalizationRepository.swift
//  SetPoint Watch AppTests
//
//  Created by marrocumarco on 17/09/2025.
//

import Foundation
@testable import SetPoint_Watch_App

final class MockLocalizationRepository: LocalizationRepository {
    func getPlayer1Name() -> String {
        ""
    }

    func getPlayer2Name() -> String {
        ""
    }

    func getConfirmMatchRestartMessage() -> String {
        ""
    }

    func getConfirmSettingsMessage() -> String {
        ""
    }

    func getGamesCaption() -> String {
        ""
    }

    func getSetsCaption() -> String {
        ""
    }

    func getSettingsTitle() -> String {
        ""
    }

    func getTiebreakText() -> String {
        ""
    }

    func getNumberOfSetsText() -> String {
        ""
    }

    func getConfirmTileText() -> String {
        ""
    }

    func getConfirmCaption() -> String {
        ""
    }

    func getCancelCaption() -> String {
        ""
    }

    var endedMatchMessage: String = ""
    func getEndedMatchMessage() -> String { endedMatchMessage }
}
