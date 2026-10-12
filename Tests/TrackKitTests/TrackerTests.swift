import XCTest
@testable import TrackKit

final class TrackerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Tracker.resetForTesting()
    }

    func testVersion() {
        XCTAssertEqual(Tracker.version, "0.1.0")
    }

    func testValidKeyConfigure() {
        XCTAssertNoThrow(try Tracker.configure(TrackerConfiguration(apiKey: "key")))
        XCTAssertNotNil(Tracker.configuration)
    }

    func testEmptyKeyThrows() {
        XCTAssertThrowsError(try Tracker.configure(TrackerConfiguration(apiKey: ""))) { error in
            XCTAssertEqual(error as? TrackerError, .invalidAPIKey)
        }
    }

    func testWhiteSpaceKeyThrows() {
        XCTAssertThrowsError(try Tracker.configure(TrackerConfiguration(apiKey: "   "))) { error in
            XCTAssertEqual(error as? TrackerError, .invalidAPIKey)
        }
    }

    func testNoConfigurationNoEvents() {
        Tracker.track("isEmpty")
        XCTAssertTrue(Tracker.trackedEvents.isEmpty)
    }

    func testEventsAfterConfigure() throws {
        try Tracker.configure(TrackerConfiguration(apiKey: "key"))
        Tracker.track("After", parameters: ["key": "value"])
        XCTAssertEqual(Tracker.trackedEvents.count, 1)
        let event = try XCTUnwrap(Tracker.trackedEvents.first)
        XCTAssertEqual(event.name, "After")
        XCTAssertEqual(event.parameters, ["key": "value"])
    }

    func testEmptyParametersEvents() throws {
        try Tracker.configure(TrackerConfiguration(apiKey: "key"))
        Tracker.track("Empty")
        let event = try XCTUnwrap(Tracker.trackedEvents.first)
        XCTAssertTrue(event.parameters.isEmpty)
    }
}
