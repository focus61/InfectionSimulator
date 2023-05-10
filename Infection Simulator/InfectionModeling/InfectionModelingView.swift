import UIKit

final class InfectionModelingView: UIView {
    private let collectionView: UICollectionView = .init(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout.init()
    )
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.register(InfectionModelingCollectionViewCell.self, forCellWithReuseIdentifier: InfectionModelingCollectionViewCell.id)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    func reloadData() {
        collectionView.reloadData()
    }
    func delegateView(_ controller: InfectionModelingViewController) {
        collectionView.delegate = controller
        collectionView.dataSource = controller
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
