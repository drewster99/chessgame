// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ChessGame",
    platforms: [
        .macOS(.v11),
        .iOS(.v13)
    ],
    products: [
        .executable(
            name: "ChessGame",
            targets: ["ChessGame"]),
    ],
    targets: [
        .executableTarget(
            name: "ChessGame"),
    ]
) 