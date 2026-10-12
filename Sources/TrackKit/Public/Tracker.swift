import Foundation

public enum Tracker {
    public static let version = "0.1.0"

    static var configuration: TrackerConfiguration?
    public private(set) static var trackedEvents: [TrackerEvent] = []

    public static func configure(_ config: TrackerConfiguration) throws {
        guard !config.apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw TrackerError.invalidAPIKey
        }
        configuration = config
    }

    public static func track(_ name: String, parameters: [String: String] = [:]) {
        guard configuration != nil else { return }
        trackedEvents.append(TrackerEvent(name: name, parameters: parameters, date: Date()))
    }
}
