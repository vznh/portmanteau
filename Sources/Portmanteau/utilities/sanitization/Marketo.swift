import Foundation

extension Sanitize.Rule {
    /// Strips Marketo email-tracking token (mkt_tok).
    static let marketo = Sanitize.Rule(id: "marketo") { components in
        Sanitize.strip(components) { $0 == "mkt_tok" }
    }
}
