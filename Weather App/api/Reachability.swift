import SystemConfiguration

class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return flags.contains(.reachable) && !flags.contains(.connectionRequired)
        }

        return false
    }
}
