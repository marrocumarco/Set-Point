//
//  SettingsView.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 30/06/2024.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @Environment(Coordinator.self) private var coordinator: Coordinator

    @State var settingsViewModel: SettingsViewModel
    @State var isPresented: Bool = false

    var body: some View {
        Form {
            HStack {
                Toggle("tiebreak", isOn: $settingsViewModel.tiebreakEnabled)
            }
            Button(
                action: {
                    coordinator.present(.numberOfSetsSelection(settingsViewModel.selectableNumberOfSets))
                },
                label: {
                    HStack {
                        Text("Number of sets")
                        Spacer()
                        Text(settingsViewModel.selectedNumberOfSets)
                    }.contentShape(Rectangle())
                }
            )
        }.onChange(of: settingsViewModel.tiebreakEnabled) {
            settingsViewModel.setTiebreakEnabled(settingsViewModel.tiebreakEnabled)
        }.navigationTitle(settingsViewModel.settingsTitle)
            .onDisappear {
                if settingsViewModel.showConfirmSettingsAlert {
                    coordinator.fullScreenCover = .confirmSettings
                }
            }
    }
}

struct SelectNumberOfSetsView: View {
    @State var settingsViewModel: SettingsViewModel
    var selectableNumberOfSets: [SelectableNumberOfSets]
    var body: some View {
        Form {
            ForEach(selectableNumberOfSets) { numberOfSets in
                Button(
                    action: {
                        settingsViewModel.setSelectedNumberOfSets(numberOfSets.numberOfSets)
                    },
                    label: {
                        HStack {
                            Text(numberOfSets.numberOfSets)
                            if numberOfSets.numberOfSets == settingsViewModel.selectedNumberOfSets {
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }
                    }
                )
            }
        }
    }
}

struct ConfirmSettings: View {
    @State var matchViewModel: MatchViewModel
    @State var settingsViewModel: SettingsViewModel

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        ScrollView {
            VStack {
                Text(settingsViewModel.settingsConfirmationMessage)
                Button("ok", role: .destructive) {
                    settingsViewModel.confirmSettings()
                    matchViewModel.resetMatch()
                    presentationMode.wrappedValue.dismiss()
                }
                Button("cancel") {
                    settingsViewModel.resetToLastSavedSettings()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}
