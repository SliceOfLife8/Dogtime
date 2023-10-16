//
//  FavoriteOperationsProtocol.swift
//  dogtime
//
//  Created by Chris Petimezas on 16/10/23.
//

protocol FavoriteOperationsProtocol {
    func addNewRecord(_ breedImage: BreedImage)
    func removeRecord(_ breedImage: BreedImage)
    func fetchAllRecords() -> [FavoriteEntity]
    func fetchRecord(for id: String) -> FavoriteEntity?
}
