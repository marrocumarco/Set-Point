//
//  EndedSet.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 29/06/2024.
//

import Foundation

struct EndedSet: Hashable, Identifiable {
    var id: Int { hashValue }
    let player1Score: Int
    let player2Score: Int
}
