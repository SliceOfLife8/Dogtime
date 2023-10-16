//
//  NetworkSession.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import Foundation

protocol NetworkSession {
    func loadData(
        for request: URLRequest
    ) async throws -> Data
}

extension URLSession: NetworkSession {
    func loadData(
        for request: URLRequest
    ) async throws -> Data {
        return try await data(for: request).0
    }
}
