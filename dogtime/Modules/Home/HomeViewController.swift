//
//  HomeViewController.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import UIKit

class HomeViewController: BaseViewController<HomeViewModel> {

    private var collectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<Int, AvailableBreed>?

    override func bindViewModel() {
        viewModel?.$items
            .dropFirst()
            .sink { [weak self] items in
                self?.applySnapshot(items)
            }
            .store(in: &cancellables)

        viewModel?.$errorMessage
            .compactMap{ $0 }
            .sink { [weak self] message in
                self?.showErrorAlert(message)
            }
            .store(in: &cancellables)
    }

    override func viewDidLoad() {
        configureNavItems()
        configureCollectionView()
        configureDataSource()
        super.viewDidLoad()
    }

    @objc private func heartDidTap() {
        let favoriteViewController = FavoriteViewController()
        favoriteViewController.viewModel = FavoriteViewModel()
        navigationController?.pushViewController(favoriteViewController, animated: true)
    }
}

extension HomeViewController {

    private func configureNavItems() {
        navigationItem.title = "Breed Explorer 🐕"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart.fill"),
            style: .plain,
            target: self,
            action: #selector(heartDidTap)
        )
    }

    private func configureCollectionView() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView?.backgroundColor = .systemGroupedBackground
        collectionView?.delegate = self
        view.addSubview(collectionView!)
    }

    private func configureDataSource() {
        guard let collectionView else { return }

        // list cell
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, AvailableBreed> { (cell, _, breed) in
            var contentConfiguration = UIListContentConfiguration.valueCell()
            contentConfiguration.text = breed.text
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.disclosureIndicator()]
        }

        // data source
        dataSource = UICollectionViewDiffableDataSource<Int, AvailableBreed>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }

    private func applySnapshot(_ breeds: [AvailableBreed]) {
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<AvailableBreed>()
        sectionSnapshot.append(breeds)
        dataSource?.apply(sectionSnapshot, to: 0)
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let breed = self.dataSource?.itemIdentifier(for: indexPath)?.text else { return }

        let detailsViewController = DetailsViewController()
        detailsViewController.viewModel = DetailsViewModel(breedCategory: breed)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
