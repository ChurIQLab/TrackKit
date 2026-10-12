
public struct TrackerConfiguration {

    public enum Environment { case sandbox, production }

    public enum LogLevel { case debug, info, error }

    public let apiKey: String
    public let environment: Environment
    public let logLevel: LogLevel

    public init(apiKey: String, environment: Environment = .sandbox, logLevel: LogLevel = .info) {
        self.apiKey = apiKey
        self.environment = environment
        self.logLevel = logLevel
    }
}
