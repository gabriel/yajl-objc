// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YAJLO",
    products: [
        .library(name: "YAJLO", targets: ["YAJLO"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "YAJLO",
            dependencies: [],
            path: "./",
            exclude: ["YAJLO.podspec", "CHANGELOG.md", "README.md", "Tests", "LICENSE", "Tests-Info.plist", "Info.plist"],
            sources: ["./Classes", "./yajl-2.1.0"],
            publicHeadersPath: "./Classes",
            cxxSettings: [
                .headerSearchPath("./yajl-2.1.0"),
                .headerSearchPath("./yajl-2.1.0/api")
            ]
        ),
        .testTarget(
            name: "yajlTests",
            dependencies: ["YAJLO"]
        ),
    ]
)

