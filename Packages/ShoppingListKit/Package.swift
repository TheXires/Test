// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ShoppingListKit",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "ShoppingListKit", targets: ["ShoppingListKit"]),
    ],
    targets: [
        .target(name: "ShoppingListKit"),
        .testTarget(name: "ShoppingListKitTests", dependencies: ["ShoppingListKit"]),
    ]
)
