//
//  FavoriteViewModel.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import Foundation

class FavoriteViewModel: BaseViewModel { 

    private(set) var coreDataManager: CoreDataManager

    /// Inputs
    @Published private(set) var items: [BreedImage] = []
    @Published private(set) var breedCategories = NSOrderedSet()
    @Published private(set) var errorMessage: String?

    /// Outputs
    @Published var selectedCategory: String

    required init(
        coreDataManager: CoreDataManager = CoreDataManager()
    ) {
        self.coreDataManager = coreDataManager
        self.selectedCategory = "All"
        super.init()
    }

    override func startFetchingData() {
        let breedImages = coreDataManager.fetchAllRecords()
            .compactMap { $0.toModel() }
        if breedImages.isEmpty {
            errorMessage = "No data available."
        }
        else {
            items = breedImages
            breedCategories = NSOrderedSet(array: breedImages.map { $0.breed }.sorted(by: <))
        }
    }
    
    /// • Remove breedImage from CoreData.
    /// • Filter out the entry from our current datasource.
    /// • Recreate breedCategories in case where the deleted item was the last of its category.
    /// • Reset selectCategory to default value when the deleted item was the last of its category.
    func removeDogEntry(with identifier: BreedImage) {
        coreDataManager.removeRecord(identifier)
        items = items.filter { $0 != identifier }
        breedCategories = NSOrderedSet(array: items.map { $0.breed }.sorted(by: <))
        if !items.map({ $0.breed }).contains(identifier.breed) {
            selectedCategory = "All"
        }
    }
}
