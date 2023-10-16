//
//  NetworkClientTests.swift
//  dogtimeTests
//
//  Created by Chris Petimezas on 16/10/23.
//

import XCTest
@testable import dogtime

class NetworkClientTests: XCTestCase {

    var jsonDecoder: JSONDecoder!

    override func setUpWithError() throws {
        try super.setUpWithError()
        jsonDecoder = JSONDecoder()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        jsonDecoder = nil
    }

    func testFetchAllBreeds() async throws {
        let mockData = MockGenerator.getBreeds()
        let expectedResponse = try! jsonDecoder.decode(ApiBreedsList.self, from: mockData)

        let mockSession = MockNetworkSession(mockData)
        let networkClient = NetworkClient(session: mockSession)
        let result = try await networkClient.fetchData(ApiBreedsList.self, target: BreedRouter.getAllBreeds)
        guard case let .success(items) = result
        else {
            XCTFail()
            return
        }
        XCTAssertEqual(expectedResponse, items)
    }

    func testFetchBreedData() async throws {
        let mockData = MockGenerator.getBreedData()
        let expectedResponse = try! jsonDecoder.decode(ApiBreedImages.self, from: mockData)

        let mockSession = MockNetworkSession(mockData)
        let networkClient = NetworkClient(session: mockSession)
        let result = try await networkClient.fetchData(
            ApiBreedImages.self,
            target: BreedRouter.getBreedImagesBy("")
        )
        guard case let .success(items) = result
        else {
            XCTFail()
            return
        }
        XCTAssertEqual(expectedResponse, items)
    }

    func testCorruptedData() async throws {
        let mockData = MockGenerator.getBreeds()
        let mockSession = MockNetworkSession(mockData)
        let networkClient = NetworkClient(session: mockSession)
        let result = try await networkClient.fetchData([ApiBreedsList].self, target: BreedRouter.getAllBreeds)
        guard case let .failure(error) = result
        else {
            XCTFail()
            return
        }
        XCTAssertEqual(error.message, NetworkError.corruptedData.message)
    }
}
