//
//  TheDataModel.swift
//  GettingTheFormattingForQuestions1
//
//  Created by Neel Arora on 1/4/25.
//

import Foundation
import SwiftData

@Model
class CodingLanguage{
    var language: String
    var score: [Score]
    init(score: [Score], language: String) {
        self.score = score
        self.language = language
    }
}

@Model
class Score{
    var score: Double
    var difficuly: Int
    init(score: Double, difficuly: Int) {
        self.score = score
        self.difficuly = difficuly
    }
}








