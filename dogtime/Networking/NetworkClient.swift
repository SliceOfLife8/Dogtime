//
//  NetworkClient.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import Foundation

enum NetworkError: Error {
    case corruptedData

    var message: String {
        switch self {
        case .corruptedData:
            return "Something went wrong. Please try again!"
        }
    }
}

/// Class responsible for fetching data from api through a `NetworkTarget`.
class NetworkClient {
    private let session: NetworkSession

    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }

    func fetchData<T: Decodable>(
        _ objectType: T.Type,
        target: NetworkTarget
    ) async throws -> Result<T, NetworkError> {
        let request = URLRequest(
            url: target.pathAppendedURL,
            timeoutInterval: 30
        )
        let responseData = try await session.loadData(for: request)

        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: responseData)
            return .success(decodedObject)
        }
        catch {
            return .failure(.corruptedData)
        }
    }
}
