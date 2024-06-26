// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MiniGit",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "XGit",
            targets: ["XGit"]),
        .library(
            name: "MiniGit",
            targets: ["MiniGit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "XGit",
            dependencies: ["libgit2"],
            exclude: ["internal"]),
        .target(
            name: "MiniGit",
            dependencies: ["XGit"],
            linkerSettings: [.linkedLibrary("z"), .linkedLibrary("iconv")]),
        .binaryTarget(
            name: "libgit2",
            url: "https://github.com/codestubhacker/LibGit2-On-iOS/releases/download/1.0.2/libgit2.xcframework.zip",
            checksum: "1d07752339a61b36419010a82a086384b62d3baa853c272d17897ebf084cda32"),
        .testTarget(
            name: "MiniGitTests",
            dependencies: ["MiniGit"]),
    ],
    cxxLanguageStandard: .cxx14
)
