//
//  Array+Extension.swift
//  dogtime
//
//  Created by Chris Petimezas on 16/10/23.
//

extension Array {

    func extract(
        _ predicate: (Element) -> Bool
    ) -> (extractedElements: [Element], remainingElements: [Element]) {
        var extractedElements: [Element] = []
        var remainingElements: [Element] = []

        for element in self {
            if predicate(element) {
                extractedElements.append(element)
            }
            else {
                remainingElements.append(element)
            }
        }

        return (extractedElements, remainingElements)
    }
}
