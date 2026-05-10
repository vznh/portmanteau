// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Portmanteau",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "Portmanteau",
            path: "Sources/Portmanteau"
        ),
        .testTarget(
            name: "PortmanteauTests",
            dependencies: ["Portmanteau"],
            path: "Tests/PortmanteauTests"
        ),
    ]
)
