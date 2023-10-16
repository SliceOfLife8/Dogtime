//
//  DetailsViewModel.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import Foundation

class DetailsViewModel: BaseViewModel {

    private var client: NetworkClient
    private var coreDataManager: CoreDataManager
    private var favoriteIdentifiers: [String]

    /// Inputs
    @Published private(set) var category: String
    @Published private(set) var items: [BreedImage] = []
    @Published private(set) var errorMessage: String?

    required init(
        _ client: NetworkClient = NetworkClient(),
        coreDataManager: CoreDataManager = CoreDataManager(),
        breedCategory: String
    ) {
        self.client = client
        self.coreDataManager = coreDataManager
        self.favoriteIdentifiers = coreDataManager.fetchAllRecords().compactMap { $0.id }
        self.category = breedCategory
        super.init()
    }

    override func startFetchingData() {
        Task(priority: .userInitiated) {
            let result = try await client.fetchData(
                ApiBreedImages.self,
                target: BreedRouter.getBreedImagesBy(category)
            )
            switch result {
            case .success(let apiImages):
                // Convert api model to domain.
                var images = apiImages.message
                    .compactMap { URL(string: $0) }
                    .map { BreedImage(url: $0, breed: category) }
                for (index, element) in images.enumerated() {
                    if favoriteIdentifiers.contains(element.identifier) {
                        images[index].isFavorite = true
                    }
                }
                items = images
            case .failure(let error):
                errorMessage = error.message
            }
        }
    }

    func modifyFavoriteStatus(at index: Int) {
        if items[index].isFavorite {
            coreDataManager.removeRecord(items[index])
        }
        else {
            coreDataManager.addNewRecord(items[index])
        }
        items[index].isFavorite.toggle()
    }
}
