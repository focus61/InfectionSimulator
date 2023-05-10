import UIKit

final class CounterView: UIView {
    private let counterLabel: UILabel = .init(frame: .zero)
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(counterLabel)
        counterLabel.numberOfLines = 0
        counterLabel.textAlignment = .center
        counterLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            counterLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            counterLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            counterLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            counterLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func changeCounterText(_ attrString: NSMutableAttributedString) {
        counterLabel.attributedText = attrString
    }
}
