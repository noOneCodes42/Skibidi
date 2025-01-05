//
//  TheData.swift
//  Quizit
//
//  Created by Neel Arora on 1/4/25.
//

import Foundation
import RealmSwift

class TestTakenCounter: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var testTakenCounter: Int
    
    convenience init(testTakenCounter: Int) {
        self.init()
        self.testTakenCounter = testTakenCounter
    }
}
