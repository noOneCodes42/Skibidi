//
//  Flashcard.swift
//  Quizit
//
//  Created by Neel Arora on 1/3/25.
//

import SwiftUI

struct FlashCardView: View {
    @State var counter: Int = 0
    // Get the backend for this
    @State var max: Int = 15
    @State var isDisabledForBack: Bool = true
    @State var isDisabledForFront: Bool = false
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .frame(width: 500, height: 400)
                Text("What is 10 * 10 + 100 - 2000 and what is the ab")
                    .font(.title)
                    .foregroundStyle(Color.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(5)
                    .padding(.leading, 44)
                    .padding(.trailing, 44)
            }
            .padding(.bottom, 50)
            HStack {
                Button {
                    if counter > 0{
                        counter -= 1
                        isDisabledForFront = false
                    }else{
                        isDisabledForBack = true
                    }
                    
                } label: {
                    Image(systemName: "chevron.backward")
                }
                .disabled(isDisabledForBack)
                Text("\(counter) out of \(max)")
                Button {
                    if counter < max {
                        counter += 1
                        isDisabledForFront = false
                        isDisabledForBack = false
                    }else{
                        isDisabledForFront = true
                    }
                } label: {
                    Image(systemName: "chevron.right")
                }
                .disabled(isDisabledForFront)
                
            }
            
        }
        
    }
}

#Preview {
    FlashCardView()
}
