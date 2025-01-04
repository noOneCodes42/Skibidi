//
//  FlashCard.swift
//  Quizit
//
//  Created by Neel Arora on 1/4/25.
//

import Foundation
struct FlashCardGet: Codable{
    var cards: [FlashCardsCards]
}
struct FlashCardsCards: Codable{
    var number: Int
    var question: String
    var answer: String
}
