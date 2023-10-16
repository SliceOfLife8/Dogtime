//
//  MockNetworkSession.swift
//  dogtimeTests
//
//  Created by Chris Petimezas on 16/10/23.
//

import Foundation
@testable import dogtime

class MockNetworkSession: NetworkSession {
    let data: Data

    init(_ data: Data = .init()) {
        self.data = data
    }

    func loadData(for request: URLRequest) async throws -> Data {
        return data
    }
}
