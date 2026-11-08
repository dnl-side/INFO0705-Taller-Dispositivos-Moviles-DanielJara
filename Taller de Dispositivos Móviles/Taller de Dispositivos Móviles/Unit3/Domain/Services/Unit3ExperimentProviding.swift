protocol Unit3ExperimentProviding {
    var currentVariant: Unit3ExperimentVariant { get }
    func refresh() async
}
