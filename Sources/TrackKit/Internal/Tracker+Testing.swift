
extension Tracker {
    static func resetForTesting() {
        state.withLock { $0 = State() }
    }
}
