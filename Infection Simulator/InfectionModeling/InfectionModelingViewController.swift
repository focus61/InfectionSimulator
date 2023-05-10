import UIKit

final class InfectionModelingViewController: UIViewController {
    private let factor: Int
    private let currentTime: Int
    private let simulationInput: SimulationInput
    private var infectionModelingPerson: [InfectionModelingModel] = []
    private let infectionModelingView: InfectionModelingView = .init(frame: .zero)
    private var infectionPersonsSet: Set<IndexPath> = []
    private let counterTitleView: CounterView = .init(frame: .zero)
    private lazy var timer = Timer.scheduledTimer(
        timeInterval: 1.0,
        target: self,
        selector: #selector(updateTimer),
        userInfo: nil,
        repeats: true
    )
    private var healthyCount = 0 {
        didSet {
            DispatchQueue.main.async {
                self.counterTitleView.changeCounterText(
                    self.setAttributedString(healthyCount: self.healthyCount, infectCount: self.infectCount)
                )
            }
        }
    }
    private var infectCount = 0 {
        didSet {
            DispatchQueue.main.async {
                self.counterTitleView.changeCounterText(
                    self.setAttributedString(healthyCount: self.healthyCount, infectCount: self.infectCount)
                )
            }
        }
    }
    private lazy var timeout = currentTime {
        didSet {
            if timeout == 0 {
                timeout = currentTime
                DispatchQueue.main.async {
                    self.infectionModelingView.reloadData()
                }
            }
        }
    }
    init(simulationInput: SimulationInput) {
        self.simulationInput = simulationInput
        self.infectionModelingPerson = Array(
            repeating: InfectionModelingModel(isInfection: false),
            count: simulationInput.groupSize
        )
        self.factor = simulationInput.infectionFactor
        self.currentTime = simulationInput.recalculationTime
        self.healthyCount = simulationInput.groupSize
        super.init(nibName: nil, bundle: nil)
        navigationItem.titleView = counterTitleView
        self.counterTitleView.changeCounterText(
            self.setAttributedString(healthyCount: self.healthyCount, infectCount: self.infectCount)
        )
        title = "Моделирование инфекции"
    }
    required convenience init?(coder: NSCoder) {
        self.init(simulationInput: SimulationInput(groupSize: 0, infectionFactor: 0, recalculationTime: 0))
    }
    override func loadView() {
        view = infectionModelingView
        infectionModelingView.delegateView(self)
    }
    deinit {
        timer.invalidate()
    }
    private func setAttributedString(healthyCount: Int, infectCount: Int) -> NSMutableAttributedString {
        let fullText = String(healthyCount) + " : " + String(infectCount)
        let mutableAttrStr = NSMutableAttributedString(string: fullText)
        let healthySide = (fullText as NSString).range(of: String(healthyCount))
        let infectSide = (fullText as NSString).range(of: " : ")
        mutableAttrStr.setAttributes([.foregroundColor: UIColor.green], range: healthySide)
        mutableAttrStr.setAttributes(
            [.foregroundColor: UIColor.red],
            range: NSRange(
                location: infectSide.location + infectSide.length,
                length: String(infectCount).count
            )
        )
        return mutableAttrStr
    }

    func calculateInfectionFactor(currentIndex: Int, mainArray: [InfectionModelingModel]) -> ClosedRange<Int> {
        let factor = Int.random(in: 0...factor)
        return infectionDiv(
            currentIndex: currentIndex,
            factor: factor,
            mainArray: mainArray,
            isEven: factor % 2 == 0
        )
    }
    private func infectionDiv(currentIndex: Int, factor: Int, mainArray: [InfectionModelingModel], isEven: Bool) -> ClosedRange<Int> {
        if mainArray.count <= factor {
            return 0...mainArray.count - 1
        }
        if currentIndex == 0 {
            return currentIndex...currentIndex + factor
        }
        
        let newFactor = isEven ? factor : factor - 1
        var leftSide = (newFactor / 2) + (isEven ? 0 : 1)
        var rightSide = newFactor / 2
        if currentIndex - leftSide < 0 {
            rightSide = rightSide + currentIndex
            leftSide = 0
            return leftSide...rightSide
        } else {
            return currentIndex - leftSide...currentIndex + rightSide
        }
    }
    private func update(index: Int) {
        DispatchQueue.global().async {
            let infectionRange = self.calculateInfectionFactor(currentIndex: index, mainArray: self.infectionModelingPerson)
            for i in infectionRange {
                self.infectCount += 1
                self.healthyCount -= 1
                self.infectionModelingPerson[i] = self.infectionModelingPerson[i].infect()
            }
        }
    }
    @objc func updateTimer() {
        if timeout != 0 {
            timeout -= 1
        }
    }
}

extension InfectionModelingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infectionModelingPerson.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfectionModelingCollectionViewCell.id, for: indexPath)
        guard let infectionModelingCell = cell as? InfectionModelingCollectionViewCell else { return cell }
        let currentPosition = infectionModelingPerson[indexPath.row]
        infectionModelingCell.changeColor(
            currentPosition.isInfection ? .red : .green, text: "\(indexPath.row)"
        )
        if infectionPersonsSet.contains(indexPath) {
            infectionModelingCell.startLoad()
            infectionPersonsSet.remove(indexPath)
        }
        return infectionModelingCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        infectionPersonsSet.insert(indexPath)
        timer.fire()
        collectionView.reloadItems(at: [indexPath])
        let thr = DispatchQueue.global(qos: .background)
        let reloadData = DispatchWorkItem {
            collectionView.reloadItems(at: [indexPath])
            self.update(index: indexPath.row)
        }
        let item = DispatchWorkItem(block: {
            self.infectionModelingPerson[indexPath.row] = self.infectionModelingPerson[indexPath.row].infect()
        })
        item.notify(queue: .main, execute: reloadData)
        thr.async(execute: item)
    }
}
