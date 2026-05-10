import Foundation

extension Sanitize.Rule {
    /// Strips Yandex click identifier (yclid).
    static let yandex = Sanitize.Rule(id: "yandex") { components in
        Sanitize.strip(components) { $0 == "yclid" }
    }
}
