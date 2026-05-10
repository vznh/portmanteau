import Testing
import Foundation
@testable import Portmanteau

@Suite("Sanitization")
struct SanitizationTests {
    @Test func stripsUTM() {
        let result = Sanitize.run("https://example.com/page?utm_source=newsletter&utm_medium=email&id=42")
        #expect(result.cleaned == "https://example.com/page?id=42")
        #expect(result.didChange)
        #expect(Set(result.changes.flatMap(\.removed)) == ["utm_source", "utm_medium"])
    }

    @Test func stripsFacebookClickId() {
        let result = Sanitize.run("https://example.com?fbclid=abc123")
        #expect(result.cleaned == "https://example.com")
    }

    @Test func stripsGoogleClickId() {
        let result = Sanitize.run("https://example.com?gclid=xyz&q=hello")
        #expect(result.cleaned == "https://example.com?q=hello")
    }

    @Test func stripsMicrosoftClickId() {
        let result = Sanitize.run("https://example.com?msclkid=xyz")
        #expect(result.cleaned == "https://example.com")
    }

    @Test func stripsMailchimp() {
        let result = Sanitize.run("https://example.com?mc_eid=a&mc_cid=b&keep=1")
        #expect(result.cleaned == "https://example.com?keep=1")
    }

    @Test func stripsYandex() {
        let result = Sanitize.run("https://example.com?yclid=foo")
        #expect(result.cleaned == "https://example.com")
    }

    @Test func stripsInstagram() {
        let result = Sanitize.run("https://example.com?igshid=foo")
        #expect(result.cleaned == "https://example.com")
    }

    @Test func stripsTwitterParamsOnTwitter() {
        let result = Sanitize.run("https://twitter.com/user/status/123?s=20&t=abc")
        #expect(result.cleaned == "https://twitter.com/user/status/123")
    }

    @Test func stripsTwitterParamsOnX() {
        let result = Sanitize.run("https://x.com/user/status/123?s=20&t=abc")
        #expect(result.cleaned == "https://x.com/user/status/123")
    }

    @Test func leavesTwitterParamsOnOtherHosts() {
        let result = Sanitize.run("https://example.com?s=foo&t=bar")
        #expect(result.cleaned == "https://example.com?s=foo&t=bar")
        #expect(!result.didChange)
    }

    @Test func leavesURLsWithNoTracking() {
        let url = "https://example.com/page?id=42&q=hello"
        let result = Sanitize.run(url)
        #expect(result.cleaned == url)
        #expect(!result.didChange)
    }

    @Test func leavesTextWithNoURLs() {
        let result = Sanitize.run("Hello, world!")
        #expect(result.cleaned == "Hello, world!")
        #expect(!result.didChange)
    }

    @Test func sanitizesURLsEmbeddedInText() {
        let result = Sanitize.run("Check this out: https://example.com?utm_source=x cool huh")
        #expect(result.cleaned == "Check this out: https://example.com cool huh")
    }

    @Test func sanitizesMultipleURLs() {
        let result = Sanitize.run("https://a.com?utm_source=x and https://b.com?fbclid=y")
        #expect(result.cleaned == "https://a.com and https://b.com")
        #expect(result.changes.count == 2)
    }

    @Test func combinesTrackingFamilies() {
        let result = Sanitize.run("https://example.com?utm_source=x&fbclid=y&gclid=z&keep=me")
        #expect(result.cleaned == "https://example.com?keep=me")
        #expect(Set(result.changes.flatMap(\.removed)) == ["utm_source", "fbclid", "gclid"])
    }

    @Test func customRuleSetCanDisableUTM() {
        let result = Sanitize.run(
            "https://example.com?utm_source=x&fbclid=y",
            rules: [.facebook]
        )
        #expect(result.cleaned == "https://example.com?utm_source=x")
    }
}
