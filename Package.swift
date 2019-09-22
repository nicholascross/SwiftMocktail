// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftMocktail",
    products: [
        .library(
            name: "SwiftMocktail",
            targets: ["SwiftMocktail"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftMocktail",
            dependencies: [], path: "SwiftMocktail"),
        .testTarget(
            name: "SwiftMocktailTests",
            dependencies: ["SwiftMocktail"], path: "SwiftMocktailTests"),
    ]
)
