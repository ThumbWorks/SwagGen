// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "{{ options.name }}",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "{{ options.name }}", targets: ["{{ options.name }}"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        {% for dependency in options.dependencies %}
        .package(url: "https://github.com/{{ dependency.github }}.git", .exact("{{ dependency.version }}")),
        {% endfor %}
    ],
    targets: [
        .target(name: "{{ options.name }}", dependencies: [
          {% for dependency in options.dependencies %}
          "{{ dependency.pod }}",
          {% endfor %}
        ], path: "Sources")
    ]
)
