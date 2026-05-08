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
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
