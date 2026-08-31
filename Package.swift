// swift-tools-version: 6.4

// swiftlint:disable explicit_acl explicit_top_level_acl

import PackageDescription

// MARK: - Swift Settings Configuration

let swiftSettings: [SwiftSetting] = [
  // Swift 6.2 Upcoming Features (not yet enabled by default)
  // SE-0335: Introduce existential `any`
  .enableUpcomingFeature("ExistentialAny"),
  // SE-0409: Access-level modifiers on import declarations
  .enableUpcomingFeature("InternalImportsByDefault"),
  // SE-0444: Member import visibility (Swift 6.1+)
  .enableUpcomingFeature("MemberImportVisibility"),
  // SE-0413: Typed throws
  .enableUpcomingFeature("FullTypedThrows"),
]

let package = Package(
  name: "MistKitConfiguration",
  platforms: [
    .macOS(.v15),
    .iOS(.v18),
    .tvOS(.v18),
    .watchOS(.v11),
    .visionOS(.v2),
  ],
  products: [
    .library(name: "MistKitConfiguration", targets: ["MistKitConfiguration"])
  ],
  dependencies: [
    // The monorepo copy of this manifest carries `.package(name: "MistKit", path: "../..")`
    // instead. That overlay is required there: a `path:` package takes its identity from
    // the directory name, so pairing it with a sibling that depends on MistKit by `url:`
    // makes SwiftPM resolve two distinct packages and fail with "multiple similar targets
    // 'MistKit', 'MistKitOpenAPI'". Standalone there is no such sibling, so this uses the
    // tagged release — which is also what makes a tag of this package usable downstream.
    .package(url: "https://github.com/brightdigit/MistKit.git", from: "1.0.0-beta.4"),
    // Pinned to the fix for brightdigit/ConfigKeyKit#8: booleans resolved through
    // `string(forKey:)` could not see a valueless command-line flag, so `--flag` read as
    // its default and `--flag false` read as true, while an unrecognized environment
    // value collapsed to false instead of being ignored. Move back to a version range
    // once a release carrying that fix is tagged.
    .package(
      url: "https://github.com/brightdigit/ConfigKeyKit.git",
      revision: "90110faa06f7666a0d58d224c92da976fff5d930"
    ),
    .package(
      url: "https://github.com/apple/swift-configuration.git",
      from: "1.0.0",
      traits: ["CommandLineArguments"]
    ),
  ],
  targets: [
    .target(
      name: "MistKitConfiguration",
      dependencies: [
        .product(name: "MistKit", package: "MistKit"),
        .product(name: "ConfigKeyKit", package: "ConfigKeyKit"),
        .product(name: "Configuration", package: "swift-configuration"),
      ],
      swiftSettings: swiftSettings
    ),
    .testTarget(
      name: "MistKitConfigurationTests",
      dependencies: ["MistKitConfiguration"],
      swiftSettings: swiftSettings
    ),
  ]
)

// swiftlint:enable explicit_acl explicit_top_level_acl
