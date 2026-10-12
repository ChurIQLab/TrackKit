import XCTest
@testable import TrackKit

final class TrackerTests: XCTestCase {
    func testVersion() {
        XCTAssertEqual(Tracker.version, "0.1.0")
    }
}
