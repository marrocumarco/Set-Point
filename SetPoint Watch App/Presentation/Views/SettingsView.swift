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

    var body: some View {
        Form {
            HStack {
                Toggle("Tiebreak", isOn: $settingsViewModel.tiebreakEnabled)
            }
            Button(
                action: {

                },
                label: {
                    HStack {
                        Text("Number of sets")
                        Spacer()
                        Text("3")
                    }.contentShape(Rectangle())
                        .onTapGesture {
                            coordinator.present(.numberOfSetsSelection(settingsViewModel.selectableNumberOfSets))
                        }
                }
            )

        }
    }
}

struct SelectNumberOfSetsView: View {
    @State var selectableNumberOfSets: [String]
    var body: some View {
        Form {
            ForEach(selectableNumberOfSets, id: \.self) { numberOfSets in
                Button(action: {}) {
                    Text(numberOfSets)
                }
            }
        }
    }
}

//#Preview {
//    SettingsView()
//}
