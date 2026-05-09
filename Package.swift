// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Sanitizer",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "Sanitizer",
            path: "Sources/Sanitizer"
        ),
        .testTarget(
            name: "SanitizerTests",
            dependencies: ["Sanitizer"],
            path: "Tests/SanitizerTests"
        ),
    ]
)
