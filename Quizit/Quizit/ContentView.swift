//
//  ContentView.swift
//  Quizit
//
//  Created by Neel Arora on 1/3/25.
//

import SwiftUI

struct ContentView: View {
    @State private var languageManager: LanguageManager = LanguageManager()
    var body: some View {
        VStack {
            TabView{
                StatsView()
                    .tabItem{
                        Label("Stats", systemImage: "chart.bar.xaxis")
                    }
                    .onAppear{
                        
                    }
                FlashCardChecker()
                    .tabItem{
                        Label("Flash Card", systemImage: "rectangle")
                    }
                QuizLanguageChecker()
                    .tabItem{
                        Label("Quiz", systemImage:"t.circle")
                    }
                
                
                
                
            }
        }
        
        
    }
}

#Preview {
    ContentView()
}
