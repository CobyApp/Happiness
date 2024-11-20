// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
    productTypes: [
        "CobyDS": .framework,
        "ComposableArchitecture": .framework
    ],
    baseSettings: .settings(
        configurations: [
            .debug(name: .debug),
            .release(name: .release)
        ]
    )
)
#endif

let package = Package(
    name: "CobyHappiness",
    dependencies: [
        .package(url: "https://github.com/CobyLibrary/CobyDS.git", from: "1.7.2"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.16.1")
    ]
)
