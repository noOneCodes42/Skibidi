//
//  Stats.swift
//  Quizit
//
//  Created by Neel Arora on 1/3/25.
//

import SwiftUI
import SwiftData
struct StatsView: View {
    @Environment(\.modelContext) private var context
    @Query private var items: [TestTakenCounter]

    @State var isPresented: Bool = false
    var body: some View {
        VStack{
            Text("Test Taken: \(items.count)")
                .padding(.bottom, 30)
           Text("Mastery")
                
        }
    }
}

#Preview {
    StatsView()
}
