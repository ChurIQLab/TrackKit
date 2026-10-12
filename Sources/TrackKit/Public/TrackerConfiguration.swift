
public struct TrackerConfiguration: Sendable {

    public enum Environment: Sendable { case sandbox, production }

    public enum LogLevel: Sendable { case debug, info, error }

    public let apiKey: String
    public let environment: Environment
    public let logLevel: LogLevel

    public init(apiKey: String, environment: Environment = .sandbox, logLevel: LogLevel = .info) {
        self.apiKey = apiKey
        self.environment = environment
        self.logLevel = logLevel
    }
}
