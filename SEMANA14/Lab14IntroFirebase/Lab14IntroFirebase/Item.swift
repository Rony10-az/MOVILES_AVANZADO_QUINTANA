//
//  Item.swift
//  Lab14IntroFirebase
//
//  Created by Rony Jhostin on 19/11/26.
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
