import Foundation

extension Sanitize.Rule {
    /// Strips Amazon tracking parameters on amazon.* — includes affiliate `tag`, which attributes the referrer.
    static let amazon = Sanitize.Rule(id: "amazon") { components in
        let host = components.host?.lowercased() ?? ""
        let onAmazon = host == "amazon.com" || host.hasPrefix("amazon.")
            || host.contains(".amazon.") || host.hasSuffix(".amazon.com")
        guard onAmazon else { return Sanitize.Step(components: components, removed: []) }
        let exact: Set<String> = ["ref_", "tag", "linkCode", "creative", "creativeASIN", "ascsubtag"]
        return Sanitize.strip(components) { name in
            exact.contains(name) || name.hasPrefix("pf_rd_") || name.hasPrefix("pd_rd_")
        }
    }
}
