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
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false

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
                    }.contentShape(Rectangle())
                        .onTapGesture {
                        if !settingsViewModel.isSelected(numberOfSets) {
                            settingsViewModel.selectNumberOfSets(numberOfSets)
                        }
                    }
                }
            }
        }.toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("", systemImage: "chevron.backward") {
                    if settingsViewModel.checkValues() {
                        dismiss()
                    }
                }.foregroundStyle(.accent)
            }
        }
        .navigationTitle("Settings")
        .navigationBarBackButtonHidden(true)
        .alert("settingsAlert", isPresented: $settingsViewModel.showAlert, actions: {
            Button("Ok", role: .destructive) { settingsViewModel.saveValues()
            dismiss()}
            Button("cancel", role: .cancel) { settingsViewModel.discardValues()
                dismiss() }
        })
    }
}

#Preview {
    SettingsView(settingsViewModel: SettingsViewModel(defaults: MockUserDefaults(valueFound: true)))
}
