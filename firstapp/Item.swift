//
//  Item.swift
//  firstapp
//
//  Created by Sedat Bilece on 8.05.2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var title: String
    var isCompleted: Bool
    var timestamp: Date

    init(title: String) {
        self.title = title
        self.isCompleted = false
        self.timestamp = Date()
    }
}
