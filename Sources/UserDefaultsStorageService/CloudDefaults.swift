//  Created by Leopold Lemmermann on 25.07.22.

import Foundation

/// CloudDefaults, as an extension of the `UserDefaults`.
/// Automatically update, when `UserDefaults` are changed,
/// but have to be started with  the ``start()`` method.
public final class CloudDefaults {
    private var _ignore = false

    private let _center = NotificationCenter.default,
                _cloud = NSUbiquitousKeyValueStore.default,
                _local = UserDefaults.standard

    private init() {}
    deinit { _center.removeObserver(self) }
}

extension CloudDefaults {
    /// A shared singleton instance of the CloudDefaults
    public static let shared = CloudDefaults()

    /// The prefix to discern cloud defaults from regular user defaults
    public static let prefix = "cloud-"
}

extension CloudDefaults {
    /// Starts the CloudDefaults, so they observe UserDefault changes and adjust the CloudDefaults accordingly.
    public func start() {
        _center.addObserver(
            forName: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: _cloud,
            queue: .main,
            using: updateLocal
        )

        _center.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: .main,
            using: updateRemote
        )

        _cloud.synchronize()
    }

    private func updateRemote(note: Notification) {
        guard !_ignore else { return }

        for (key, value) in _local.dictionaryRepresentation() {
            guard key.hasPrefix(Self.prefix) else { continue }
            _cloud.set(value, forKey: key)
        }
    }

    private func updateLocal(note: Notification) {
        _ignore = true
        defer { _ignore = false }

        for (key, value) in _cloud.dictionaryRepresentation {
            guard key.hasPrefix(Self.prefix) else { continue }
            _local.set(value, forKey: key)
        }
    }
}
