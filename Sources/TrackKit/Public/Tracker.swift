import Foundation
import os

public enum Tracker {
    public static let version = "0.1.0"

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
            throw TrackerError.invalidAPIKey
        }
        // Запись: $0 здесь - inout State, менять можно только внутри замыкания
        state.withLock { $0.configuration = config }
    }

    public static func track(_ name: String, parameters: [String: String] = [:]) {
        state.withLock {
            guard $0.configuration != nil else { return }
            $0.trackedEvents.append(TrackerEvent(name: name, parameters: parameters, date: Date()))
        }
    }
}
