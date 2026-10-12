// swift-tools-version: 5.9
// ↑ Первая строка обязательна и должна быть ровно в таком виде.
//   Это не комментарий, а директива: с какой версией PackageDescription работает файл.

import PackageDescription   // Библиотека с типами Package, Target, Product и т.д

let package = Package(
    // 1. Имя пакета. Видно в Xcode в списке зависимостей.
    name: "TrackKit",

    // 2. Минимальные версии платформ. Ниже этой версии пакет не подключится.
    platforms: [
        .iOS(.v16)
    ],

    // 3. Products: что пакет ОТДАЁТ наружу.
    //    Клиент в Xcode выбирает именно продукт.
    products: [
        .library(
            name: "TrackKit",           // имя продутка
            targets: ["TrackKit"]       // из каких таргетов он собирается
        )
    ],

    // 4. Targets: из чего пакет СОСТОИТ. Каждый таргет = один модуль.
    targets: [
        // Основной таргет. Исходники SPM ищет в Sources/<имя таргета>/
        .target(
            name: "TrackKit",
            resources: [
                .process("Resources")      // путь относительно Sources/TrackKit/
            ]
        ),

        // Тестовый таргет. Исходники ищутся в Tests/<имя таргета>/
        .testTarget(
            name: "TrackKitTests",
            dependencies: ["TrackKit"]  // тестам нужен доступ к основному модулю
        )
    ]
)