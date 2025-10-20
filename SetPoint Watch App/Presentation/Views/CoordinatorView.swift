//
//  CoordinatorView.swift
//  SetPoint Watch App
//
//  Created by marrocumarco on 12/10/2025.
//

import SwiftUI

struct CoordinatorView: View {
    @State private(set) var coordinator: Coordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .match)
                .navigationDestination(for: AppPage.self) { page in
                    coordinator.build(page: page)
                }.sheet(item: $coordinator.sheet) { sheet in
                    coordinator.buildSheet(sheet: sheet)
                }.fullScreenCover(
                    item: $coordinator.fullScreenCover,
                    onDismiss: {
                        coordinator.onDismissCover?()
                    },
                    content: { cover in
                        coordinator.buildCover(cover: cover)
                    }
                )
        }.environment(coordinator)
    }
}
