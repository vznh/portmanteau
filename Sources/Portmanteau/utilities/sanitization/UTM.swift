import Foundation

extension Sanitize.Rule {
    /// Strips Urchin Tracking Module campaign parameters (utm_source, utm_medium, …).
    static let utm = Sanitize.Rule(id: "utm") { components in
        Sanitize.strip(components) { $0.hasPrefix("utm_") }
    }
}
