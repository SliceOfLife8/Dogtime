//
//  HomeViewModel.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import Foundation

class HomeViewModel: BaseViewModel {

    private var client: NetworkClient

    /// Inputs
    @Published private(set) var items: [AvailableBreed] = []
    @Published private(set) var errorMessage: String?

    required init(_ client: NetworkClient = NetworkClient()) {
        self.client = client
        super.init()
    }

    override func startFetchingData() {
        Task(priority: .userInitiated) {
            let result = try await client.fetchData(
                ApiBreedsList.self,
                target: BreedRouter.getAllBreeds
            )
            switch result {
            case .success(let list):
                // Convert api model to domain.
                let availableBreeds = list.message
                    .map { String($0.key) }
                    .sorted(by: <)
                    .map { AvailableBreed(text: $0) }
                if availableBreeds.isEmpty {
                    errorMessage = "No data available."
                }
                else {
                    items = availableBreeds
                }
            case .failure(let error):
                errorMessage = error.message
            }
        }
    }
}
