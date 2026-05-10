import Foundation

extension Sanitize.Rule {
    /// Strips TikTok share-tracking parameters on tiktok.com.
    static let tiktok = Sanitize.Rule(id: "tiktok") { components in
        guard Sanitize.hostMatches(components, "tiktok.com") else {
            return Sanitize.Step(components: components, removed: [])
        }
        let names: Set<String> = [
            "_r", "_t", "_d",
            "is_from_webapp", "sender_device", "sender_web_id",
            "share_app_id", "share_link_id", "tt_from", "u_code",
        ]
        return Sanitize.strip(components) { names.contains($0) }
    }
}
