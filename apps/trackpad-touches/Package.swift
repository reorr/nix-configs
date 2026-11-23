// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "TrackpadTouches",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "TrackpadTouches",
            path: "Sources/TrackpadTouches"
        ),
    ]
)
