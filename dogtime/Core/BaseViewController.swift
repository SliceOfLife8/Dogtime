//
//  BaseViewController.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import UIKit
import Combine

class BaseViewController<VM: BaseViewModel>: UIViewController {
    var viewModel: VM?
    var cancellables = Set<AnyCancellable>()

    deinit {
        cancellables.removeAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.startFetchingData()
        bindViewModel()
    }

    func bindViewModel() {}

    func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Error detected", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
        navigationController?.present(alert, animated: true)
    }
}
