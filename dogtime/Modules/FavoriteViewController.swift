//
//  FavoriteViewController.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import UIKit

class FavoriteViewController: BaseViewController<FavoriteViewModel> {

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
        configureNavItems()
        view.addSubview(collectionView)
        super.viewDidLoad()
    }

    override func bindViewModel() {
        viewModel?.$items
            .sink { [weak self] items in
                self?.configureDataSource(items)
                self?.applySnapshot(items)
            }
            .store(in: &cancellables)

        viewModel?.$breedCategories
            .sink { [weak self] categories in
                if categories.count > 1 {
                    self?.navigationItem.rightBarButtonItem = UIBarButtonItem(
                        image: UIImage(systemName: "line.3.horizontal.decrease.circle.fill"),
                        menu: self?.filtersMenu(with: categories)
                    )
                }
                else {
                    self?.navigationItem.rightBarButtonItem = nil
                }

            }
            .store(in: &cancellables)

        viewModel?.$selectedCategory
            .sink { [weak self] category in
                guard let actions = self?.navigationItem.rightBarButtonItem?.menu?.children as? [UIAction]
                else { return }
                let items = actions.extract({ $0.title == category })
                items.extractedElements.first?.state = .on
                items.remainingElements.forEach { $0.state = .off }
            }
            .store(in: &cancellables)

        viewModel?.$errorMessage
            .compactMap{ $0 }
            .sink { [weak self] message in
                self?.showErrorAlert(message)
            }
            .store(in: &cancellables)
    }

    private func filtersMenu(with breedCategories: NSOrderedSet) -> UIMenu? {
        guard let viewModel else { return nil }

        var actions = breedCategories.compactMap { $0 as? String }.map {
            return UIAction(title: $0) { [weak self] action in
                guard let self, var snapshot = self.dataSource?.snapshot() else { return }
                // We should always delete the rest of the items and insert or not the filteredItems depending
                // on the current state of snapshot.
                let filteredItems = viewModel.items.extract({ $0.breed == action.title })
                snapshot.deleteItems(filteredItems.remainingElements)
                if !snapshot.itemIdentifiers.contains(filteredItems.extractedElements) {
                    snapshot.appendItems(filteredItems.extractedElements)
                }
                self.dataSource?.apply(snapshot, animatingDifferences: true)
                self.viewModel?.selectedCategory = action.title
            }
        }
        actions.insert(
            UIAction(title: "All", handler: { [weak self] action in
                self?.applySnapshot(viewModel.items)
                self?.viewModel?.selectedCategory = action.title
            }),
            at: 0
        )

        return UIMenu(title: "Filter by breed category", children: actions)
    }
}

extension FavoriteViewController {
    private func configureNavItems() {
        navigationItem.title = "Favorite Images"
        navigationItem.largeTitleDisplayMode = .always
    }

    private func createImagesLayout() -> UICollectionViewLayout {
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

    private func configureDataSource(_ items: [BreedImage]) {
        dataSource = UICollectionViewDiffableDataSource<Int, BreedImage>(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DogCell.identifier,
                    for: indexPath
                ) as? DogCell
                let dataModel = DogCell.DataModel(breedImage: itemIdentifier, showBreedIndicator: true)
                cell?.configureLayout(dataModel)
                cell?.delegate = self
                return cell
            }
        )
    }

    private func applySnapshot(_ images: [BreedImage]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, BreedImage>()
        snapshot.appendSections([0])
        snapshot.appendItems(images, toSection: 0)
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
}

// MARK: - DogCellDelegate
extension FavoriteViewController: DogCellDelegate {
    func favoriteStatusChanged(_ view: DogCell) {
        guard let indexPath = collectionView.indexPath(for: view),
              let identifier = dataSource?.itemIdentifier(for: indexPath)
        else { return }

        viewModel?.removeDogEntry(with: identifier)
    }
}
