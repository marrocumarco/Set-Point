//
//  DataAccess.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 14/09/2025.
//

protocol DataAccess {
    func setSelectedNumberOfSets(_ numberOfSets: Int)
    func getSelectedNumberOfSets(_ defaultValue: Int) -> Int
    func setTiebreakEnabled(_ enabled: Bool)
    func getTiebreakEnabled(_ defaultValue: Bool) -> Bool
}
