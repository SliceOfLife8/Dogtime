//
//  Url+Extension.swift
//  dogtime
//
//  Created by Chris Petimezas on 17/11/23.
//

import UIKit

extension URL {

    func loadImageUsingCache() async -> UIImage? {
        if let cachedImage = await ImageCacheManager.shared.retrieve(forKey: self) {
            return cachedImage
        }

        guard let data = try? await URLSession.shared.data(from: self).0,
              let image = UIImage(data: data)
        else { return nil }

        await ImageCacheManager.shared.store(image: image, withUrl: self)
        return image
    }
}
