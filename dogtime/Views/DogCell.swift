//
//  DogCell.swift
//  dogtime
//
//  Created by Chris Petimezas on 14/10/23.
//

import UIKit

protocol DogCellDelegate: AnyObject {
    func favoriteStatusChanged(_ view: DogCell)
}

class DogCell: UICollectionViewCell {

    // MARK: - Properties

    static var identifier = "DogCell"

    weak var delegate: DogCellDelegate?

    private var task: URLSessionTask?

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.addTarget(self, action: #selector(favoriteToggleTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    private lazy var breedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        label.textColor = .white
        label.font = .italicSystemFont(ofSize: 14)
        label.isHidden = true
        return label
    }()

    public override var isHighlighted: Bool {
        didSet {
            onHighlightChanged()
        }
    }

    // MARK: - Constructors

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    // MARK: - Methods

    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
        imageView.image = nil
    }

    func configureLayout(_ dataModel: DataModel) {
        favoriteButton.isHidden = true
        favoriteButton.tintColor = dataModel.isFavorite ? .red : .white
        loadImageUsingCache(dataModel.imageUrl)

        guard dataModel.showBreedIndicator else { return }
        imageView.addSubview(breedLabel)
        breedLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16).isActive = true
        breedLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16).isActive = true
        breedLabel.isHidden = false
        breedLabel.text = dataModel.breed
    }

    // MARK: - Private Methods

    private func setupViews() {
        addSubview(imageView)
        addSubview(favoriteButton)

        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .right, .left]
        NSLayoutConstraint.activate(attributes.map {
            NSLayoutConstraint(
                item: imageView,
                attribute: $0,
                relatedBy: .equal,
                toItem: self,
                attribute: $0,
                multiplier: 1,
                constant: 0
            )
        })
        favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24).isActive = true
    }

    private func onHighlightChanged() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            if self.isHighlighted {
                self.imageView.alpha = 0.9
                self.imageView.transform = CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95)
            }
            else {
                self.imageView.alpha = 1.0
                self.imageView.transform = .identity
            }
        })
    }

    private func loadImageUsingCache(_ url: URL) {
        if let cachedImage = ImageCacheManager.shared.retrieve(forKey: url) {
            imageView.image = cachedImage
            favoriteButton.isHidden = false
            return
        }

        task = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            guard let data, error == nil else { return }

            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    ImageCacheManager.shared.store(image: image, withUrl: url)
                    self.imageView.image = image
                    self.favoriteButton.isHidden = false
                }
            }
        })
        task?.resume()
    }

    @objc private func favoriteToggleTapped() {
        delegate?.favoriteStatusChanged(self)
    }
}

// MARK: - DataModel
extension DogCell {

    class DataModel {
        let imageUrl: URL
        let isFavorite: Bool
        let showBreedIndicator: Bool
        let breed: String

        init(breedImage: BreedImage, showBreedIndicator: Bool = false) {
            self.imageUrl = breedImage.url
            self.isFavorite = breedImage.isFavorite
            self.showBreedIndicator = showBreedIndicator
            self.breed = breedImage.breed
        }
    }
}
