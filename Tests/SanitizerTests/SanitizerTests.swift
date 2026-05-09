import Testing
@testable import Sanitizer

@Suite("Sanitizer")
struct SanitizerTests {
    @Test func placeholder() {
        #expect(Bool(true))
    }
}
