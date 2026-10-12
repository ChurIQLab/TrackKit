
extension Tracker {
    static func resetForTesting() {
        configuration = nil
        trackedEvents.removeAll()
    }
}
