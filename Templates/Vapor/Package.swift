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
        {% for dependency in options.dependencies %}
        .package(url: "https://github.com/{{ dependency.github }}.git", from: "{{ dependency.version }}"),
        {% endfor %}
    ],
    targets: [
        .target(name: "{{ options.name }}", dependencies: [
          {% for dependency in options.dependencies %}
          .product(name: "{{ dependency.name }}", package: "{{ dependency.lowerName }}")
          {% endfor %}
        ], path: "Sources")
    ]
)
