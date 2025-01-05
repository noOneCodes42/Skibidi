//
//  TheData.swift
//  Quizit
//
//  Created by Neel Arora on 1/4/25.
//

import Foundation
import SwiftData
@Model
class TestTakenCounter: Identifiable{
    var id: String
    var testTaskenCounter: Int
    init(testTaskenCounter: Int) {
        self.testTaskenCounter = testTaskenCounter
        self.id = UUID().uuidString
    }
}
