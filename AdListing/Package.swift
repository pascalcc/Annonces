// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdListing",
    platforms: [.iOS(.v15)],

    products: [
        .library(
            name: "AdListing",
            targets: ["AdListing"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/Alamofire/Alamofire.git",
            .upToNextMajor(from: "5.10.0")),
        .package(
            url: "https://github.com/Swinject/Swinject.git", from: "2.9.0"),
    ],
    targets: [
        .target(
            name: "AdListing",
            dependencies: ["Alamofire", "Swinject"])
    ],
    swiftLanguageModes: [.v5]

)
