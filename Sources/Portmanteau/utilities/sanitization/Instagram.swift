import Foundation

extension Sanitize.Rule {
    /// Strips Instagram share identifier (igshid).
    static let instagram = Sanitize.Rule(id: "instagram") { components in
        Sanitize.strip(components) { $0 == "igshid" }
    }
}
