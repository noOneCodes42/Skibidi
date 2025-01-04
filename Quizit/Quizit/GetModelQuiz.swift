//
//  GetModel.swift
//  Quizit
//
//  Created by Neel Arora on 1/3/25.
//

import Foundation

struct GetModelQuiz: Codable{
    var questions: [Questions]
}
struct Questions: Codable{
    var number: Int
    var question: String
    var options: [String]
    var answer: Int
}
