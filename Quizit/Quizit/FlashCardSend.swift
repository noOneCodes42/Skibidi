//
//  FlashCardSend.swift
//  Quizit
//
//  Created by Neel Arora on 1/4/25.
//

import Foundation
struct FlashCardSend: Codable {
    var language: String
    var difficulty: Int
    var cards: Int
}
