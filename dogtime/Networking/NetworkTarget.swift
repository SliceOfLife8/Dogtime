//
//  NetworkTarget.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import Foundation

public protocol NetworkTarget {
    var baseURL: URL { get }
    var path: String { get }
}

public extension NetworkTarget {
    var pathAppendedURL: URL {
        var url = baseURL
        url.appendPathComponent(path)
        return url
    }
}
