import UIKit

enum InputTypeTags: Int {
    case groupSize = 0
    case infectionFactor
    case recalculationTime
}
final class SimulationInputViewController: UIViewController {
    private let simulationInputView: SimulationInputView = .init(frame: .zero)
    private var groupSize: String = ""
    private var infectionFactor: String = ""
    private var recalculationTime: String = ""
    override func loadView() {
        view = simulationInputView
        simulationInputView.delegateView(self)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ввод данных"
    }
}

extension SimulationInputViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard
            let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText)
        else { return false }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 6
    }
}
extension SimulationInputViewController: SimulationInputViewDelegate {
    func confirmTouch(isActive: Bool) {
        guard isActive else {
            let alert = UIAlertController(title: "Все поля обязательны", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Хорошо", style: .cancel)
            alert.addAction(action)
            present(alert, animated: true)
            return
        }
        let simulatorInput = SimulationInput(
            groupSize: Int(groupSize) ?? 0,
            infectionFactor: Int(infectionFactor) ?? 0,
            recalculationTime: Int(recalculationTime) ?? 0
        )
        let infectionModelingViewController = InfectionModelingViewController(
            simulationInput: simulatorInput
        )
        navigationController?.pushViewController(infectionModelingViewController, animated: true)
    }
}

extension SimulationInputViewController: InputViewDelegate {
    func changeInputText(_ text: String, forTag: Int) {
        switch forTag {
        case InputTypeTags.groupSize.rawValue: groupSize = text
        case InputTypeTags.infectionFactor.rawValue: infectionFactor = text
        case InputTypeTags.recalculationTime.rawValue: recalculationTime = text
        default: break
        }
        let isActiveButton = !groupSize.isEmpty && !infectionFactor.isEmpty && !recalculationTime.isEmpty
        simulationInputView.isConfirmButtonActive(isActiveButton)
    }
    func touchDone() {
        simulationInputView.endEditing(true)
    }
    func inputDescriptionButtonTouch(description: String) {
        let alert = UIAlertController(title: description, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Понятно", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
