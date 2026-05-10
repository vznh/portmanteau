import Foundation

extension Sanitize.Rule {
    /// Strips Reddit share/tracking parameters on reddit.com.
    static let reddit = Sanitize.Rule(id: "reddit") { components in
        guard Sanitize.hostMatches(components, "reddit.com") else {
            return Sanitize.Step(components: components, removed: [])
        }
        let names: Set<String> = ["share_id", "correlation_id", "ref_source"]
        return Sanitize.strip(components) { names.contains($0) }
    }
}
