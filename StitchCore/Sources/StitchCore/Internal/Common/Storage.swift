import Foundation

/// Storage allows us to store arbitrary data via
/// an arbitrary source. The protocol is modeled
/// after Foundation.UserDefaults.
public protocol Storage {
    /// Read value for key
    /// - parameter forKey key: key to read from
    /// - returns: value for key
    func value(forKey key: String) -> Any?

    /// Set value for key
    /// - parameter value: value to save
    /// - parameter forKey key: key to save value for
    mutating func set(_ value: Any?, forKey key: String)

    /// Remove object for key
    /// - parameter forKey key: key to remove value for
    mutating func removeObject(forKey key: String)
}

extension Storage {
    subscript(key: String) -> Any? {
        get {
            return self.value(forKey: key)
        }
        set {
            if let value = newValue {
                self.set(value, forKey: key)
            } else {
                self.removeObject(forKey: key)
            }
        }
    }
}

/// Failover implementation of the Storage protocol
/// in the event that no other storage unit can
/// be found.
internal struct MemoryStorage: Storage {
    /// Internal storage unit
    private var storage: [String: Any] = [:]

    func value(forKey key: String) -> Any? {
        return self.storage[key]
    }

    mutating func set(_ value: Any?, forKey key: String) {
        self.storage[key] = value
    }

    mutating func removeObject(forKey key: String) {
        self.storage.removeValue(forKey: key)
    }
}

#if !os(Linux)
    /// Protocol conformance for Foundation.UserDefaults
    extension UserDefaults: Storage {}
#endif