//
//  String+highlightOccurrences.swift
//  CodeEdit
//
//  Created by Raymond Vleeshouwer on 13/06/23.
//

import Foundation
import SwiftUI

extension String {
    // swiftlint:disable shorthand_operator
    func highlightOccurrences(_ ofSearch: String) -> some View {
        let ranges = self.rangesOfSubstring(ofSearch.lowercased())

        var currentIndex = self.startIndex
        var highlightedText = Text("")

        for range in ranges {
            let nonHighlightedText = self[currentIndex..<range.lowerBound]
            let highlightedSubstring = self[range]

            highlightedText = highlightedText + Text(nonHighlightedText).foregroundColor(.secondary)
            highlightedText = highlightedText + Text(highlightedSubstring).foregroundColor(.primary)

            currentIndex = range.upperBound
        }

        let remainingText = self[currentIndex..<self.endIndex]

        return highlightedText + Text(remainingText).foregroundColor(.secondary)
    }

    private func rangesOfSubstring(_ substring: String) -> [Range<Index>] {
        var ranges = [Range<Index>]()
        var currentIndex = self.startIndex

        while let range = self.range(
            of: substring,
            options: .caseInsensitive,
            range: currentIndex..<self.endIndex
        ) {
            ranges.append(range)

            currentIndex = range.upperBound
        }

        return ranges
    }
}
// swiftlint:enable shorthand_operator
