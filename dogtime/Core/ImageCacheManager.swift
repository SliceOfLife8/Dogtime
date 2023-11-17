//
//  ImageCacheManager.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import UIKit

@globalActor
actor ImageCacheManager {

    static let shared = ImageCacheManager()

    private let cache = NSCache<NSString, UIImage>()

    func store(image: UIImage, withUrl url: URL) {
        cache.setObject(
            image,
            forKey: NSString(string: url.absoluteString)
        )
    }

    func retrieve(forKey url: URL) -> UIImage? {
        let key = NSString(string: url.absoluteString)

        return cache.object(forKey: key)
    }
}
