// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MaToolAPI",
    products: [
        // 本体ターゲットを実行可能として出力
        .executable(
            name: "MaToolAPI",
            targets: ["MaToolAPI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/awslabs/swift-aws-lambda-runtime.git", from: "2.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "MaToolAPI",
            dependencies: [
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime")
            ],
            path: "Sources/MaToolAPI"
        ),
        .testTarget(
            name: "MaToolAPITests",
            dependencies: ["MaToolAPI"],
            path: "Tests/MaToolAPITests"
        )
    ]
)
