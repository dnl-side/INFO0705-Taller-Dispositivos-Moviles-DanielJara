import Combine

@MainActor
protocol ConnectivityMonitoring: AnyObject {
    var currentStatus: ConnectivityStatus { get }
    var statusPublisher: AnyPublisher<ConnectivityStatus, Never> { get }
}
