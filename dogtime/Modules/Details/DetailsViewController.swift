//
//  DetailsViewController.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import UIKit

class DetailsViewController: BaseViewController<DetailsViewModel> {

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: self.createImagesLayout()
        )
        collectionView.register(DogCell.self, forCellWithReuseIdentifier: DogCell.identifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemGroupedBackground
        return collectionView
    }()

    private var dataSource: UICollectionViewDiffableDataSource<Int, BreedImage>?

    override func viewDidLoad() {
        view.addSubview(collectionView)
        super.viewDidLoad()
    }

    override func bindViewModel() {
        viewModel?.$category
            .sink { [weak self] title in
                self?.navigationItem.title = "\(title) 🐾"
            }
            .store(in: &cancellables)

        viewModel?.$items
            .dropFirst()
            .sink { [weak self] items in
                guard let self else { return }
                if dataSource == nil {
                    self.configureDataSource(items)
                }
                self.applySnapshot(items)
            }
            .store(in: &cancellables)

        viewModel?.$errorMessage
            .compactMap{ $0 }
            .sink { [weak self] message in
                self?.showErrorAlert(message)
            }
            .store(in: &cancellables)
    }
}

extension DetailsViewController {
    func createImagesLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {(
            sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment
        ) -> NSCollectionLayoutSection in

            // Create layout for Item
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            // Create layout for Group
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(250)
            )

            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )

            // Create layout for Section
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 16,
                bottom: 0,
                trailing: 16
            )

            return section
        }
        return layout
    }

    func configureDataSource(_ items: [BreedImage]) {
        dataSource = UICollectionViewDiffableDataSource<Int, BreedImage>(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DogCell.identifier,
                    for: indexPath
                ) as? DogCell
                let dataModel = DogCell.DataModel(breedImage: itemIdentifier)
                cell?.configureLayout(dataModel)
                cell?.delegate = self
                return cell
            }
        )
    }

    func applySnapshot(_ images: [BreedImage]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, BreedImage>()
        snapshot.appendSections([0])
        snapshot.appendItems(images, toSection: 0)
        dataSource?.apply(snapshot)
    }
}

// MARK: - DogCellDelegate
extension DetailsViewController: DogCellDelegate {
    func favoriteStatusChanged(_ view: DogCell) {
        guard let indexPath = collectionView.indexPath(for: view) else { return }
        viewModel?.modifyFavoriteStatus(at: indexPath.row)
    }
}
