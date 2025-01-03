//
//  Stats.swift
//  Quizit
//
//  Created by Neel Arora on 1/3/25.
//

import SwiftUI

struct StatsView: View {
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .stroke(Color.blue, lineWidth: 20)
                    .frame(width: 240, height: 240)
                Text("Average")
            }
            .padding(.bottom, 130)
            Text("Test Taken: ")
                .padding(.bottom, 30)
            Text("Mastery: ")
        }
    }
}

#Preview {
    StatsView()
}
