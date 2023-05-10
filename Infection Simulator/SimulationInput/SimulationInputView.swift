import UIKit

protocol SimulationInputViewDelegate: AnyObject {
    func confirmTouch(isActive: Bool)
}

final class SimulationInputView: UIView {
    weak var delegate: SimulationInputViewDelegate?
    private let confirmButton: UIButton = .init(frame: .zero)
    private let inputStackView: UIStackView = .init(frame: .zero)
    private let groupSizeInput: InputView = .init(
        inputDescription: "Количество людей в моделируемой группе.",
        inputTitle: "Размер группы"
    )
    private let infectionFactorInput: InputView = .init(
        inputDescription: "Количество людей, которое может быть заражено одним человеком при контакте.",
        inputTitle: "Фактор инфекции"
    )

    private let recalculationTimeInput: InputView = .init(
        inputDescription: "Период пересчёта количества заражённых людей.",
        inputTitle: "Период пересчета"
    )
    private var isConfirmButtonActive = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubviews([
            confirmButton,
            inputStackView
        ])
        confirmButton.clipsToBounds = true
        confirmButton.layer.cornerRadius = 10
        confirmButton.setTitle("Запустить моделирование", for: .normal)
        confirmButton.backgroundColor = .lightGray
        confirmButton.setTitleColor(
            .gray,
            for: .normal
        )
        confirmButton.addTarget(
            self,
            action: #selector(startSimulate),
            for: .touchUpInside
        )
        NSLayoutConstraint.activate([
            inputStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            inputStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            inputStackView.bottomAnchor.constraint(equalTo: centerYAnchor),
            
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        configureInputView(groupSizeInput, tag: InputTypeTags.groupSize.rawValue)
        configureInputView(infectionFactorInput, tag: InputTypeTags.infectionFactor.rawValue)
        configureInputView(recalculationTimeInput, tag: InputTypeTags.recalculationTime.rawValue)
        inputStackView.axis = .vertical
        inputStackView.spacing = 20
    }
    @objc private func startSimulate() {
        delegate?.confirmTouch(isActive: isConfirmButtonActive)
    }
    private func configureInputView(_ inputView: InputView, tag: Int) {
        inputView.setTagForTextField(tag)
        inputStackView.addArrangedSubview(inputView)
    }
    private func addSubviews(_ views: [UIView]) {
        views.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func isConfirmButtonActive(_ isActive: Bool) {
        self.isConfirmButtonActive = isActive
        confirmButton.backgroundColor = isActive ? UIColor(red: 0, green: 161/255, blue: 217/255, alpha: 1) : .lightGray
        confirmButton.setTitleColor(
            isActive ? .white : .gray,
            for: .normal
        )
    }
    func delegateView(_ controller: SimulationInputViewController) {
        delegate = controller
        groupSizeInput.delegateInputView(controller)
        infectionFactorInput.delegateInputView(controller)
        recalculationTimeInput.delegateInputView(controller)
    }
}
