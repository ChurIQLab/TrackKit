import Foundation

public struct TrackerEvent: Equatable {
    public let name: String
    public let parameters: [String: String]
    public let date: Date
}
