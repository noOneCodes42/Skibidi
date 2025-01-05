//
//  QuizitApp.swift
//  Quizit
//
//  Created by Neel Arora on 1/3/25.
//

import SwiftUI
import SwiftData
@main
struct QuizitApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: TestTakenCounter.self)
        .modelContainer(for: CodingLanguage.self)
        .modelContainer(for: Score.self)
        
    }
}
