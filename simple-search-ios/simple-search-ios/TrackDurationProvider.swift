//
//  TrackDurationProvider.swift
//  simple-search-ios
//
//  Created by Kelly Morales on 1/16/22.
//

import Foundation

/// Provides logic converting track duration into displayable format
protocol TrackDurationProviding {
    /**
     * Converts a number of seconds into a formatted duration string
     * - parameter seconds: The number of seconds to be converted into a displayable time duration
     * - returns: A formatted string verion of a track duration, ie. 120 seconds yields "2:00"
     */
    func formattedTrackDuration(seconds: Int) -> String
}

/// Provides logic for formatting a track duration
class TrackDurationProvider: TrackDurationProviding {

    func formattedTrackDuration(seconds: Int) -> String {
        if seconds < 10 {
            return "0:0\(seconds)"
        } else if seconds < 60 {
            return "0:\(seconds)"
        } else {
            let minutes = seconds / 60
            let remainingSeconds = seconds % 60

            let stringSeconds: String
            if remainingSeconds < 10 {
                stringSeconds = "0\(remainingSeconds)"
            } else {
                stringSeconds = "\(remainingSeconds)"
            }

            return "\(minutes):\(stringSeconds)"
        }
    }
}
