import Foundation

extension Sanitize.Rule {
    /// Strips Twitter/X share identifiers (s, t) on twitter.com and x.com only — `s`/`t` are generic names other sites legitimately use.
    static let twitter = Sanitize.Rule(id: "twitter") { components in
        let host = components.host?.lowercased() ?? ""
        let onTwitter = host == "twitter.com" || host.hasSuffix(".twitter.com")
            || host == "x.com" || host.hasSuffix(".x.com")
        guard onTwitter else { return Sanitize.Step(components: components, removed: []) }
        return Sanitize.strip(components) { ["s", "t"].contains($0) }
    }
}
