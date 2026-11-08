import Combine

@MainActor
protocol Unit3ConnectivityMonitoring: AnyObject {
    var currentStatus: Unit3ConnectivityStatus { get }
    var statusPublisher: AnyPublisher<Unit3ConnectivityStatus, Never> { get }
}
