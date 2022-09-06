// swift-tools-version: 5.6

///
import PackageDescription


let package = Package(
    name: "SafeContinuationModule",
    products: [
        .library(
            name: "SafeContinuationModule",
            targets: ["SafeContinuationModule"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SafeContinuationModule",
            dependencies: []
        ),
        .testTarget(
            name: "SafeContinuationModuleTests",
            dependencies: ["SafeContinuationModule"]
        ),
    ]
)
