// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ChessGame",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .executable(
            name: "ChessGame",
            targets: ["ChessGame"]),
    ],
    targets: [
        .executableTarget(
            name: "ChessGame",
            resources: [
                .process("Assets.xcassets")
            ]
        ),
    ]
) 
