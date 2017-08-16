import PackageDescription

let package = Package(
    name: "HelloWorld",
    dependencies: [
        .Package(url: "https://github.com/SwiftGL/CGLFW3Linux.git", majorVersion: 1),
        .Package(url: "https://github.com/SwiftGL/OpenGL.git", majorVersion: 2)
    ]
)

