//
//  SettingsUseCaseImpl.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 14/09/2025.
//

import Foundation

internal class SettingsUseCaseImpl: SettingsUseCase {

    private let settings: any Settings
    private let dataAccess: any DataAccess
    private let localizationRepository: any LocalizationRepository

    var settingsTitle: String {
        localizationRepository.getSettingsTitle()
    }

    var tiebreakText: String {
        localizationRepository.getTiebreakText()
    }

    var numberOfSetsText: String {
        localizationRepository.getNumberOfSetsText()
    }

    var confirmTileText: String {
        localizationRepository.getConfirmTileText()
    }

    init(settings: any Settings,
         dataAccess: any DataAccess,
         localizationRepository: any LocalizationRepository) throws {
        self.settings = settings
        self.dataAccess = dataAccess
        self.localizationRepository = localizationRepository

        try settings.setSelectedNumberOfSets(
            dataAccess.getSelectedNumberOfSets(settings.getDefaultNumberOfSets()),
            fromUser: false
        )
        settings.setTiebreakEnabled(
            dataAccess.getTiebreakEnabled(settings.getDefaultTiebreakEnabled()),
            fromUser: false
        )
    }

    func getSelectableNumberOfSets() -> [Int] {
        return settings.getSelectableNumberOfSets()
    }

    func setSelectedNumberOfSets(_ numberOfSets: Int) throws {
        try settings.setSelectedNumberOfSets(numberOfSets, fromUser: true)
    }

    func getSelectedNumberOfSets() -> Int {
        return settings.getSelectedNumberOfSets()
    }

    func setTiebreakEnabled(_ enabled: Bool) {
        settings.setTiebreakEnabled(enabled, fromUser: true)
    }

    func getTiebreakEnabled() -> Bool {
        return settings.getTiebreakEnabled()
    }

    func confirmSettings() {
        dataAccess.setSelectedNumberOfSets(settings.getSelectedNumberOfSets())
        dataAccess.setTiebreakEnabled(settings.getTiebreakEnabled())
    }

    func resetToLastSavedSettings() throws {
        try settings.setSelectedNumberOfSets(
            dataAccess.getSelectedNumberOfSets(settings.getDefaultNumberOfSets()),
            fromUser: false
        )
        settings.setTiebreakEnabled(
            dataAccess.getTiebreakEnabled(settings.getDefaultTiebreakEnabled()),
            fromUser: false
        )
        settings.resetSettingsStatus()
    }

    func showConfirmSettingsAlert() -> Bool {
        return settings.getSettingsChanged()
    }
}
