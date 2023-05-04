import UIKit

final class SimulationInputViewController: UIViewController {
    private let simulationInputView: SimulationInputView = .init(frame: .zero)
    override func loadView() {
        view = simulationInputView
        simulationInputView.delegateView(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ввод данных"
    }
}

extension SimulationInputViewController: SimulationInputViewDelegate {}
