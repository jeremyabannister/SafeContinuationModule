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
    dependencies: [
        
        ///
        .package(
            url: "https://github.com/jeremyabannister/LeakTracker-module",
            "0.1.7" ..< "0.2.0"
        ),
    ],
    targets: [
        .target(
            name: "SafeContinuationModule",
            dependencies: [
                "LeakTracker-module",
            ]
        ),
        .testTarget(
            name: "SafeContinuationModuleTests",
            dependencies: ["SafeContinuationModule"]
        ),
    ]
)
