import Foundation

extension Sanitize.Rule {
    /// Strips Klaviyo tracking token (_kx).
    static let klaviyo = Sanitize.Rule(id: "klaviyo") { components in
        Sanitize.strip(components) { $0 == "_kx" }
    }
}
