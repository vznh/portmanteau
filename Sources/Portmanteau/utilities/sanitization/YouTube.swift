import Foundation

extension Sanitize.Rule {
    /// Strips YouTube share identifier (si) on youtube.com / youtu.be.
    static let youtube = Sanitize.Rule(id: "youtube") { components in
        guard Sanitize.hostMatches(components, "youtube.com", "youtu.be") else {
            return Sanitize.Step(components: components, removed: [])
        }
        return Sanitize.strip(components) { $0 == "si" }
    }
}
