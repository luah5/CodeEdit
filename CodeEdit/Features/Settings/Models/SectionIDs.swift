//
//  SectionID.swift
//  CodeEdit
//
//  Created by Raymond Vleeshouwer on 25/01/25.
//

import Foundation
import SwiftUI

struct SectionIDs: Equatable {
    private var sectionIDs: [SectionID]

    /// This initializer assigns a unique `SectionID` to each section based on the provided number of child views.
    /// Lengths of
    init(_ lengths: [Int]) {
        var lastNumber = 0

        sectionIDs = lengths.map { length in
            let range = Array(lastNumber..<(lastNumber + length))
            lastNumber += length
            return SectionID(ids: range)
        }
    }

    init(_ sectionIDs: [SectionID]) {
        self.sectionIDs = sectionIDs
    }

    mutating func append(_ length: Int) {
        sectionIDs.append(.init(ids: Array(0...length)))
    }

    func find(_ id: Int) -> SectionID? {
        var sectionID: SectionID?
        sectionIDs.forEach { if $0.ids.contains(id) { sectionID = $0; return } }

        return sectionID
    }

    // Potentially in the future a get/set subscript could be added
    subscript(_ index: Int) -> SectionID {
        return sectionIDs[index]
    }

    /// Represents a unique ID assigned to each Section
    struct SectionID: Hashable, Identifiable {
        static func == (lhs: SectionIDs.SectionID, rhs: SectionIDs.SectionID) -> Bool {
            lhs.ids == rhs.ids && lhs.id == rhs.id
        }

        let id = UUID()
        private let action: () -> Void
        let ids: [Int]

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(ids)
        }

        init(ids: [Int], action: @escaping () -> Void = {}) { self.ids = ids; self.action = action }

        func performAction() { action() }

        /// Return a `UnitPoint` from where `id` is in the array, `.top` is for first elements, `.bottom` for last elements
        func getAnchor(for id: Int) -> UnitPoint {
            let index = Int(max(min(Double(ids.firstIndex(of: id) ?? 1) / Double(ids.count - 1) * 2, 2), 0))
            return [.top, .center, .bottom][index]
        }
    }
}
