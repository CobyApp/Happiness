import ProjectDescription

// MARK: Constants
let projectName = "CobyHappiness"
let organizationName = "Coby"
let bundleID = "com.coby.CobyHappiness"
let targetVersion = "17.0"
let version = "1.0.2"
let bundleVersion = "1"

// MARK: Struct
let project = Project(
    name: projectName,
    organizationName: organizationName,
    settings: .settings(
        configurations: [
            .debug(name: .debug),
            .release(name: .release)
        ]
    ),
    targets: [
        .target(
            name: projectName,
            destinations: [.iPhone],
            product: .app,
            bundleId: bundleID,
            deploymentTargets: .iOS(targetVersion),
            infoPlist: createInfoPlist(),
            sources: ["\(projectName)/Sources/**"],
            resources: ["\(projectName)/Resources/**"],
            entitlements: "\(projectName)/\(projectName).entitlements",
            dependencies: defaultDependencies()
        )
    ],
    schemes: [
        .scheme(
            name: "\(projectName) Debug",
            buildAction: .buildAction(targets: ["\(projectName)"]),
            runAction: .runAction(configuration: .debug)
        ),
        .scheme(
            name: "\(projectName) Release",
            buildAction: .buildAction(targets: ["\(projectName)"]),
            runAction: .runAction(configuration: .release)
        )
    ]
)

private func createInfoPlist() -> InfoPlist {
    let plist: [String: Plist.Value] = [
        "CFBundleShortVersionString": "\(version)",
        "CFBundleVersion": "\(bundleVersion)",
        "UIMainStoryboardFile": "",
        "UILaunchStoryboardName": "LaunchScreen"
    ]
    return .extendingDefault(with: plist)
}

private func defaultDependencies() -> [TargetDependency] {
    [
        .external(name: "CobyDS"),
        .external(name: "ComposableArchitecture")
    ]
}
