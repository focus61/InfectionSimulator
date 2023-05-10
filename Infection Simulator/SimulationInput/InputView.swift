import UIKit

protocol InputViewDelegate: AnyObject {
    func inputDescriptionButtonTouch(description: String)
    func touchDone()
    func changeInputText(_ text: String, forTag: Int)
}

final class InputView: UIView {
    private let inputDescription: String
    private let inputTitle: String
    private let inputTitleLabel: UILabel = .init(frame: .zero)
    private let inputTextField: UITextField = .init(frame: .zero)
    private let inputDescriptionButton: UIButton = .init(frame: .zero)
    weak var delegate: InputViewDelegate?
    init(
        inputDescription: String,
        inputTitle: String
    ) {
        self.inputDescription = inputDescription
        self.inputTitle = inputTitle
        super.init(frame: .zero)
        addSubviews([
            inputTitleLabel,
            inputTextField,
            inputDescriptionButton
        ])
        NSLayoutConstraint.activate([
            inputDescriptionButton.heightAnchor.constraint(equalToConstant: 30),
            inputDescriptionButton.widthAnchor.constraint(equalToConstant: 30),
            inputDescriptionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            inputDescriptionButton.centerYAnchor.constraint(equalTo: inputTitleLabel.centerYAnchor),

            inputTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            inputTitleLabel.leadingAnchor.constraint(equalTo: inputDescriptionButton.trailingAnchor, constant: 10),
            inputTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            inputTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            inputTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            inputTextField.centerYAnchor.constraint(equalTo: inputTitleLabel.centerYAnchor),
            inputTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        inputTitleLabel.text = inputTitle
        inputDescriptionButton.setImage(
            UIImage(systemName: "info.circle"),
            for: .normal
        )
        inputDescriptionButton.tintColor = UIColor(red: 0, green: 161/255, blue: 217/255, alpha: 1)
        inputDescriptionButton.addTarget(
            self,
            action: #selector(showDescription),
            for: .touchUpInside
        )
        inputTextField.keyboardType = .numberPad
        inputTextField.borderStyle = .roundedRect
        inputTextField.addTarget(
            self,
            action: #selector(changeInputText),
            for: .editingChanged
        )
        addDoneButtonOnKeyboard()
    }
    func setTagForTextField(_ tag: Int) {
        inputTextField.tag = tag
    }
    @objc private func changeInputText() {
        delegate?.changeInputText(inputTextField.text ?? "", forTag: inputTextField.tag)
    }
    @objc private func showDescription() {
        delegate?.inputDescriptionButtonTouch(description: inputDescription)
    }
    @objc private func doneAction() {
        delegate?.touchDone()
    }
    private func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.backgroundColor = .white
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let done: UIBarButtonItem = UIBarButtonItem(
            title: "Готово",
            style: .done,
            target: self,
            action: #selector(doneAction)
        )
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        inputTextField.inputAccessoryView = doneToolbar
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
    func delegateInputView(_ controller: SimulationInputViewController) {
        delegate = controller
        inputTextField.delegate = controller
    }
}
