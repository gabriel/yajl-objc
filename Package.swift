// swift-tools-version:4.2
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
            path: "./Classes",
            //exclude: <#T##[String]#>,
            sources: ["./Classes", "./yajl-2.1.0"],
            publicHeadersPath: "./Classes"
        ),
        .testTarget(name: "yajlTests", dependencies: ["YAJLO"]),
    ]
)

