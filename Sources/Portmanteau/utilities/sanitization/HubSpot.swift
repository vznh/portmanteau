import Foundation

extension Sanitize.Rule {
    /// Strips HubSpot tracking parameters (`_hsenc`, `_hsmi`, `__hssc`, `__hstc`, `__hsfp`, `hsCtaTracking`).
    static let hubspot = Sanitize.Rule(id: "hubspot") { components in
        let names: Set<String> = ["_hsenc", "_hsmi", "__hssc", "__hstc", "__hsfp", "hsCtaTracking"]
        return Sanitize.strip(components) { names.contains($0) }
    }
}
