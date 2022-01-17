//
//  TrackDurationProviderTests.swift
//  simple-search-iosTests
//
//  Created by Kelly Morales on 1/16/22.
//

import XCTest
@testable import simple_search_ios

class TrackDurationProviderTests: XCTestCase {

    func testFormattedTrackDuration_fewerThan10SecondsReturnsIntAsStringWithLeading0s() {
        let formattedString = TrackDurationProvider().formattedTrackDuration(seconds: 0)
        XCTAssertEqual(formattedString, "0:00")
    }

    func testFormattedTrackDuration_fewerThan60SecondsReturnsSameIntAsString() {
        let formattedString = TrackDurationProvider().formattedTrackDuration(seconds: 59)
        XCTAssertEqual(formattedString, "0:59")
    }

    func testFormattedTrackDuration_60SecondsReturnsOneMinute() {
        let formattedString = TrackDurationProvider().formattedTrackDuration(seconds: 60)
        XCTAssertEqual(formattedString, "1:00")
    }

    func testFormattedTrackDuration_MoreThan60SecondsReturnsFormattedTimeString() {
        var formattedString = TrackDurationProvider().formattedTrackDuration(seconds: 181)
        XCTAssertEqual(formattedString, "3:01")

        formattedString = TrackDurationProvider().formattedTrackDuration(seconds: 179)
        XCTAssertEqual(formattedString, "2:59")

        formattedString = TrackDurationProvider().formattedTrackDuration(seconds: 987)
        XCTAssertEqual(formattedString, "16:27")
    }
}
