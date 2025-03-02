//
//  FilterOption.swift
//  Equity
//
//  Created by ANDELA on 02/03/2025.
//

import Foundation
struct FilterOption: Equatable {
    let id: String
    let title: String
    let imageTitle: String?
    
    static func == (lhs: FilterOption, rhs: FilterOption) -> Bool {
        lhs.id == rhs.id
    }
}
