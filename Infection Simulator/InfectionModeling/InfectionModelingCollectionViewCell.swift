import UIKit

final class InfectionModelingCollectionViewCell: UICollectionViewCell {
    static let id = "InfectionModelingCollectionViewCell"
    private let activityIndicator: UIActivityIndicatorView = .init()
    private let positionLabel: UILabel = .init()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews([activityIndicator, positionLabel])
        activityIndicator.color = .blue
        activityIndicator.hidesWhenStopped = true
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 20),
            activityIndicator.widthAnchor.constraint(equalToConstant: 20),
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            positionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            positionLabel.heightAnchor.constraint(equalToConstant: 40),
            positionLabel.widthAnchor.constraint(equalToConstant: 40),
            positionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        positionLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        positionLabel.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func startLoad() {
        activityIndicator.startAnimating()
    }
    func changeColor(_ color: UIColor, text: String) {
        activityIndicator.stopAnimating()
        positionLabel.text = text
        contentView.backgroundColor = color
    }
    private func addSubviews(_ views: [UIView]) {
        views.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
