//
//  SectionID.swift
//  CodeEdit
//
//  Created by Raymond Vleeshouwer on 25/01/25.
//

import Foundation
import SwiftUI

struct SectionIDs {
    let sectionIDs: [SectionID]

    /// This initializer assigns a unique SectionID to each section based on the provided number of child views.
    /// Lengths must be inclusive, e.g., in the array [0, 1, 2], there are 3 elements, not 2.
    init(_ lengths: [Int]) {
        var lastNumber = 0

        sectionIDs = lengths.map { length in
            let range = Array(lastNumber..<(lastNumber + length))
            lastNumber += length
            return SectionID(ids: range)
        }
    }

    func find(_ id: Int) -> SectionID? {
        var sectionID: SectionID?
        sectionIDs.forEach { if $0.ids.contains(id) { sectionID = $0; return } }

        return sectionID
    }

    subscript(_ index: Int) -> SectionID {
        sectionIDs[index]
    }

    /// Represents a unique ID assigned to each Section
    public struct SectionID: Hashable, Identifiable {
        let id = UUID()
        let ids: [Int]
    }
}
