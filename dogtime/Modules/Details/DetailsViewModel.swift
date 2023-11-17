//
//  DetailsViewModel.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import Foundation

class DetailsViewModel: BaseViewModel {

    @Injected var client: NetworkClient
    @Injected var coreDataManager: CoreDataManager

    private var favoriteIdentifiers: [String] = []

    /// Inputs
    @Published private(set) var category: String
    @Published private(set) var items: [BreedImage] = []
    @Published private(set) var errorMessage: String?

    required init(breedCategory: String) {
        self.category = breedCategory
        super.init()
        self.favoriteIdentifiers = coreDataManager.fetchAllRecords().compactMap { $0.id }
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
