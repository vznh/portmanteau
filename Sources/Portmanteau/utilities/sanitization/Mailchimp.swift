import Foundation

extension Sanitize.Rule {
    /// Strips Mailchimp campaign and subscriber identifiers (mc_eid, mc_cid).
    static let mailchimp = Sanitize.Rule(id: "mailchimp") { components in
        let names: Set<String> = ["mc_eid", "mc_cid"]
        return Sanitize.strip(components) { names.contains($0) }
    }
}
