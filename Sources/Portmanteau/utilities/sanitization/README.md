Each file in this directory is one tracking-parameter rule. To add one, drop a file here, register it in `Sanitize.Rule.defaults` in `Sanitize.swift`, and add a test in `Tests/PortmanteauTests/SanitizationTests.swift`.

Minimal shape:

```swift
import Foundation

extension Sanitize.Rule {
    /// Strips Foo's click identifier (foo_id).
    static let foo = Sanitize.Rule(id: "foo") { components in
        Sanitize.strip(components) { $0 == "foo_id" }
    }
}
```

Host-gated rules (when a param is too generic to strip everywhere) use `Sanitize.hostMatches`:

```swift
static let foo = Sanitize.Rule(id: "foo") { components in
    guard Sanitize.hostMatches(components, "foo.com") else {
        return Sanitize.Step(components: components, removed: [])
    }
    return Sanitize.strip(components) { $0 == "id" }
}
```

The `id` is a stable identifier — short, lowercase, unique. A future settings UI will toggle rules by id. The strip predicate composes freely: exact match (`$0 == "name"`), set membership (`names.contains($0)`), prefix family (`$0.hasPrefix("utm_")`), or any mix.

Default stance is aggressive — strip if a param possibly tracks the user. For broad rules (generic names like `ref` or `source`), note in the doc comment why someone might want to disable it.
