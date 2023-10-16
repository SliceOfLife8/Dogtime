//
//  BaseViewModel.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import Combine

class BaseViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()

    @MainActor
    func startFetchingData() {}

    deinit {
        cancellables.removeAll()
    }
}
