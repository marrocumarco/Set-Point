//
//  Match.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 29/06/2024.
//

import Combine
import Foundation

@Observable
class MatchViewModel {

    internal init(matchUseCase: any MatchUseCase) {
        self.matchUseCase = matchUseCase
    }
    
    let matchUseCase: any MatchUseCase
}
