import Foundation

extension Sanitize.Rule {
    /// Strips Twitter/X share identifiers (s, t) on twitter.com / x.com only — `s`/`t` are generic names other sites legitimately use.
    static let twitter = Sanitize.Rule(id: "twitter") { components in
        guard Sanitize.hostMatches(components, "twitter.com", "x.com") else {
            return Sanitize.Step(components: components, removed: [])
        }
        return Sanitize.strip(components) { ["s", "t"].contains($0) }
    }
}
