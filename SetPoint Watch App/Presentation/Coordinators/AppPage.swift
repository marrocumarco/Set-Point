//
//  AppPage.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 12/10/2025.
//

import Foundation

enum AppPage: Hashable {
    case match
    case settings
}

enum Sheet: Identifiable, Hashable {
    var id: String {
        self.hashValue.description
    }

    case numberOfSetsSelection([SelectableNumberOfSets])
}

enum FullScreenCover: Identifiable, Hashable {
    var id: String {
        self.hashValue.description
    }

    case confirmSettings
}
