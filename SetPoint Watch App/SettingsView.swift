//
//  SettingsView.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 30/06/2024.
//

import Foundation

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsViewModel: SettingsViewModel
    var body: some View {
        List {
            HStack {
                Toggle("Tie-break", isOn: $settingsViewModel.tiebreakEnabled)
            }
            Section("NumberOfSets") {
                ForEach(settingsViewModel.numberOfSets) { numberOfSets in
                    HStack {
                        Text(numberOfSets.description)
                        Spacer()
                        if numberOfSets == settingsViewModel.selectedNumberOfSets {
                            Image(systemName: "checkmark")
                        }
                    }.onTapGesture {
                        if !settingsViewModel.isSelected(numberOfSets) {
                            settingsViewModel.selectNumberOfSets(numberOfSets)
                        }
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView(settingsViewModel: SettingsViewModel())
}
