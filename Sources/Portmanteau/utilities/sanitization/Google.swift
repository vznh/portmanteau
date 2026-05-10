import Foundation

extension Sanitize.Rule {
    /// Strips Google click and analytics identifiers (gclid, dclid, _ga, _gl, gbraid, wbraid).
    static let google = Sanitize.Rule(id: "google") { components in
        let names: Set<String> = ["gclid", "dclid", "_ga", "_gl", "gbraid", "wbraid"]
        return Sanitize.strip(components) { names.contains($0) }
    }
}
