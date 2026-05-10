import Foundation

/// URL tracking-parameter sanitization.
enum Sanitize {
    /// Outcome of sanitizing arbitrary text.
    struct Result: Sendable {
        let original: String
        let cleaned: String
        let changes: [URLChange]
        var didChange: Bool { !changes.isEmpty }
    }

    /// Per-URL change record.
    struct URLChange: Sendable {
        let original: URL
        let cleaned: URL
        let removed: [String]
    }

    /// One rule's effect on one URL.
    struct Step: Sendable {
        var components: URLComponents
        var removed: [String]
    }

    /// One configurable tracking-parameter rule. `apply` is pure.
    struct Rule: Sendable {
        let id: String
        let apply: @Sendable (URLComponents) -> Step
    }

    /// Finds URLs in `text`, applies `rules` in order, returns cleaned text plus per-URL details.
    static func run(_ text: String, rules: [Rule] = Rule.defaults) -> Result {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return Result(original: text, cleaned: text, changes: [])
        }
        let matches = detector.matches(in: text, options: [], range: NSRange(text.startIndex..., in: text))
        guard !matches.isEmpty else {
            return Result(original: text, cleaned: text, changes: [])
        }

        var cleaned = text
        var changes: [URLChange] = []

        // splice from the end so earlier ranges remain valid
        for match in matches.reversed() {
            guard
                let url = match.url,
                let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                let range = Range(match.range, in: cleaned)
            else { continue }

            // skip schemeless matches; replacing would inject http:// into user text
            let head = cleaned[range].prefix(8).lowercased()
            guard head.hasPrefix("http://") || head.hasPrefix("https://") else { continue }

            var current = components
            var removed: [String] = []
            for rule in rules {
                let step = rule.apply(current)
                current = step.components
                removed.append(contentsOf: step.removed)
            }

            guard !removed.isEmpty, let cleanedURL = current.url else { continue }
            cleaned.replaceSubrange(range, with: cleanedURL.absoluteString)
            changes.append(URLChange(original: url, cleaned: cleanedURL, removed: removed))
        }

        return Result(original: text, cleaned: cleaned, changes: changes.reversed())
    }

    /// True if the URL's host equals any of `domains` or is a subdomain of one.
    static func hostMatches(_ components: URLComponents, _ domains: String...) -> Bool {
        let host = components.host?.lowercased() ?? ""
        return domains.contains { host == $0 || host.hasSuffix("." + $0) }
    }

    /// Drops query items whose name matches `predicate`; rebuilds components.
    static func strip(_ components: URLComponents, where predicate: (String) -> Bool) -> Step {
        guard var items = components.queryItems else {
            return Step(components: components, removed: [])
        }
        var removed: [String] = []
        items.removeAll { item in
            guard predicate(item.name) else { return false }
            removed.append(item.name)
            return true
        }
        var out = components
        out.queryItems = items.isEmpty ? nil : items
        return Step(components: out, removed: removed)
    }
}

extension Sanitize.Rule {
    /// Default rule set. Configurability lands when settings UI does — filter this list by `id`.
    static let defaults: [Sanitize.Rule] = [
        .utm, .facebook, .google, .microsoft, .mailchimp, .yandex, .instagram, .twitter,
        .youtube, .tiktok, .linkedin, .reddit, .amazon, .hubspot, .marketo, .klaviyo, .referrer,
    ]
}
