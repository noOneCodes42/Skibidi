//
//  TheDataModel.swift
//  GettingTheFormattingForQuestions1
//
//  Created by Neel Arora on 1/4/25.
//

import Foundation

import RealmSwift

class CodingLanguage: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var language: String
    @Persisted var scores: List<Score>
    
    convenience init(language: String, scores: [Score] = []) {
        self.init()
        self.language = language
        self.scores.append(objectsIn: scores)
    }
}

class Score: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var score: Double
    @Persisted var difficulty: Int
    @Persisted var questions: Int
    
    convenience init(score: Double, difficulty: Int, questions: Int) {
        self.init()
        self.score = score
        self.difficulty = difficulty
        self.questions = questions
    }
}









