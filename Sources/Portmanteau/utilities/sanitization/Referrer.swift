import Foundation

extension Sanitize.Rule {
    /// Strips generic referrer/source parameters (ref, ref_src, ref_url, referrer, referer, source).
    /// Aggressive — `ref` and `source` may double as routing keys on some sites; disable this rule if a site breaks.
    static let referrer = Sanitize.Rule(id: "referrer") { components in
        let names: Set<String> = ["ref", "ref_src", "ref_url", "referrer", "referer", "source"]
        return Sanitize.strip(components) { names.contains($0) }
    }
}
