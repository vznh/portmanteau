import Foundation

extension Sanitize.Rule {
    /// Strips LinkedIn tracking parameters on linkedin.com.
    static let linkedin = Sanitize.Rule(id: "linkedin") { components in
        guard Sanitize.hostMatches(components, "linkedin.com") else {
            return Sanitize.Step(components: components, removed: [])
        }
        let names: Set<String> = [
            "trk", "trkInfo", "lipi", "originalSubdomain",
            "refId", "midToken", "midSig", "eid",
        ]
        return Sanitize.strip(components) { names.contains($0) }
    }
}
