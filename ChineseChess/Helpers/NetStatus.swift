import Network

class NetStatus {
    static let shared = NetStatus()
    
    var monitor: NWPathMonitor?
    var isMonitoring = false
    
    var isConnected: Bool {
        guard let monitor = monitor else { return false }
        return monitor.currentPath.status == .satisfied
    }
    
    var didStartMonitoringHandler: (() -> Void)?
    
    var didStopMonitoringHandler: (() -> Void)?
    
    var netStatusChangeHandler: (() -> Void)?
    
    private init() {
        
    }
    
    deinit {
        stopMonitoring()
    }
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        monitor = NWPathMonitor()
        
        let queue = DispatchQueue(label: "NetStatus_Monitor")
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { _ in
            self.netStatusChangeHandler?()
        }
        
        isMonitoring = true
        didStartMonitoringHandler?()
    }
    
    func stopMonitoring() {
        guard isMonitoring, let monitor = monitor else { return }
        
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
        
        didStopMonitoringHandler?()
    }
    
    
}


