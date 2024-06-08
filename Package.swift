// swift-tools-version:5.9

import PackageDescription

let packageName = "Easing"

let package = Package(
    name: "Easing",
    platforms: [.iOS(.v12), .macOS(.v10_13), .watchOS(.v4), .tvOS(.v12), .visionOS(.v1)],
    products: [.library(name: "Easing", targets: ["Easing"])],
    dependencies: [],
    targets: [
        .target(name: "Easing", dependencies: [], path: "Sources"),
        .testTarget(name: "EasingTests", dependencies: ["Easing"], path: "Tests"),
    ]
)
