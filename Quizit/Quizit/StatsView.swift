//
//  Stats.swift
//  Quizit
//
//  Created by Neel Arora on 1/3/25.
//

import SwiftUI
import SwiftData
import RealmSwift
struct StatsView: View {
    @ObservedResults(TestTakenCounter.self) var counter
    @ObservedResults(CodingLanguage.self) var mastery

    @State var isPresented: Bool = false
    var body: some View {
        VStack{
            Text("Test Taken: \(counter.count != 1 ? 0 : counter[0].testTakenCounter)")
                .padding(.bottom, 30)
            Text("Check Mastery")
                .foregroundStyle(.blue)
                .onTapGesture {
                    isPresented.toggle()
                }
                .sheet(isPresented: $isPresented) {
                    
                    List(mastery){ language in
                        let totalScore = language.scores.map { Double($0.score) * (Double($0.difficulty) / Double(10)) * (Double($0.questions) / Double(50)) / Double(5) }.reduce(0, +) * 100
                        ScrollView{
                            Text("\(language.language): \(Int(totalScore.rounded(.up)))%")
                        }
                    }
                }
                
        }
    }
}

#Preview {
    StatsView()
}
