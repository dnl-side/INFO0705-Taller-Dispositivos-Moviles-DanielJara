import Combine
import Foundation
import Network

@MainActor
final class Unit3NetworkConnectivityMonitor: Unit3ConnectivityMonitoring {
    @Published private(set) var currentStatus: Unit3ConnectivityStatus = .unknown

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "cl.uniacc.orienta.u3.network-monitor")

    var statusPublisher: AnyPublisher<Unit3ConnectivityStatus, Never> {
        $currentStatus
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let status: Unit3ConnectivityStatus = path.status == .satisfied ? .online : .offline

            Task { @MainActor [weak self, status] in
                self?.currentStatus = status
            }
        }

        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
