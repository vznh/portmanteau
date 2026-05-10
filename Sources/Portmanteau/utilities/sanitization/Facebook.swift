import Foundation

extension Sanitize.Rule {
    /// Strips Facebook click identifier (fbclid).
    static let facebook = Sanitize.Rule(id: "facebook") { components in
        Sanitize.strip(components) { $0 == "fbclid" }
    }
}
