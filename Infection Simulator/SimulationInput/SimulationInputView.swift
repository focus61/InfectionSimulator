import UIKit

protocol SimulationInputViewDelegate: AnyObject {
    
}
final class SimulationInputView: UIView {
    weak var delegate: SimulationInputViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func delegateView(_ controller: SimulationInputViewController) {
        delegate = controller
    }
}
