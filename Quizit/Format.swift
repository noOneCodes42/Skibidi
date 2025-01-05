//
//  Format.swift
//  Quizit
//
//  Created by Neel Arora on 1/4/25.
//

import SwiftUI

struct Format: View {
    @State private var isFlipped: Bool = false
    @StateObject var flashCardManager: FlashcardManager = FlashcardManager()
    var body: some View {
        ZStack{
            if !isFlipped{
                Text(flashCardManager.flashCardItems[0]?.cards[0].question ?? "")
                    .padding()
                    .frame(width: 300, height: 200)
                    .background(Color.white)
                    .foregroundStyle(.black)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y:1, z: 0))
            } else{
                Text(flashCardManager.flashCardItems[0]?.cards[0].answer ?? "")
                
                    .padding()
                    .frame(width: 300, height: 200)
                    .background(Color.white)
                    .foregroundStyle(Color.black)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .rotation3DEffect(.degrees(isFlipped ? 360 : 180), axis: (x: 0, y:1, z: 0))
                
            }
            
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.8)){
                isFlipped.toggle()
            }
        }
    }
}

#Preview {
    Format()
}
