struct InfectionModelingModel {
    var isInfection: Bool
    mutating func infect() -> InfectionModelingModel {
        return InfectionModelingModel(isInfection: true)
    }
}
