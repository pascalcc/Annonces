// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AdDetail",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "AdDetail",
            targets: ["AdDetail"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.8.0")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.10.0"))
    ],
    targets: [
        .target(
            name: "AdDetail",
            dependencies: [
                "Alamofire",
                "RxSwift"
            ]
        )
    ],
    swiftLanguageModes: [.v5]
)
