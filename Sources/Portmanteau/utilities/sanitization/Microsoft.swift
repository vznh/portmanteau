import Foundation

extension Sanitize.Rule {
    /// Strips Microsoft (Bing/MSN) click identifier (msclkid).
    static let microsoft = Sanitize.Rule(id: "microsoft") { components in
        Sanitize.strip(components) { $0 == "msclkid" }
    }
}
