import Combine
import Foundation
import Network

@MainActor
final class NetworkConnectivityMonitor: ConnectivityMonitoring {
    @Published private(set) var currentStatus: ConnectivityStatus = .unknown

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "cl.uniacc.orienta.network-monitor")

    var statusPublisher: AnyPublisher<ConnectivityStatus, Never> {
        $currentStatus
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    /// Función de inicialización empleada para comenzar a observar cambios en la conectividad del dispositivo.
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.currentStatus = path.status == .satisfied ? .online : .offline
            }
        }

        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
