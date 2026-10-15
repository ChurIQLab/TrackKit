import Foundation
import os

public enum Tracker {
    public static let version = "0.1.0"

    static let logger = Logger(
        subsystem: "com.churiqlab.TrackKit",
        category: "Tracker"
    )

    struct State: Sendable {
        var configuration: TrackerConfiguration?
        var trackedEvents: [TrackerEvent] = []
    }

    // static let: сама ссылка на замок не меняется -> не "mutable" -> компилятор доволен
    // Меняется только содержимое, а к нему не попасть иначе как через withLock
    static let state = OSAllocatedUnfairLock(initialState: State())

    // Чтение: замок открывается, отдает копию значения, закрывается
    static var configuration: TrackerConfiguration? {
        state.withLock { $0.configuration }
    }

    public static var trackedEvents: [TrackerEvent] {
        state.withLock { $0.trackedEvents }
    }

    public static func configure(_ config: TrackerConfiguration) throws {
        guard !config.apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            // error — самый высокий уровень: .error >= любой порог → всегда true,
            // поэтому проверку можно не писать. Текст статический → privacy не нужна
            logger.error("Configure failed: empty apiKey")
            throw TrackerError.invalidAPIKey
        }
        // Запись: $0 здесь - inout State, менять можно только внутри замыкания
        state.withLock { $0.configuration = config }

        // Лог ПОСЛЕ замка. Порог берём из ПЕРЕДАННОГО config:
        // пользователь только что сам сказал, какой уровень хочет
        if .info >= config.logLevel {
            logger.info("Configure done, environment: \(String(describing: config.environment), privacy: .public)")
            // String(describing:) превращает enum в строку "sandbox".
            // Logger умеет интерполировать String, Int, Bool…, а голый enum не примет
        }
    }

    public static func track(_ name: String, parameters: [String: String] = [:]) {
        // withLock возвращает значение: тип можно указать явно, так понятнее
        let threshold: TrackerConfiguration.LogLevel? = state.withLock {
            guard let config = $0.configuration else { return nil }                                     // не настроен → nil
            $0.trackedEvents.append(TrackerEvent(name: name, parameters: parameters, date: Date()))
            return config.logLevel                                                                      // настроен → порог
        }
        // ↑ замок уже отпущен, дальше только логирование

        guard let threshold else {
            logger.error("track called before configure")
            return
        }

        if .debug >= threshold {
            logger.debug("Tracked \(name, privacy: .public), parameters: \(parameters.description)")
            //                     ↑ имя открыто             ↑ String без privacy → <private>
            // parameters.description: словарь → String (Logger не интерполирует словарь напрямую)
        }
    }

    public static func greeting(for name: String) async throws -> String {
        guard configuration != nil else {
            throw TrackerError.notConfigured
        }

        try await Task.sleep(for: .milliseconds(500))   // «сетевой запрос»

        return "Hello, \(name)!"
    }
}
