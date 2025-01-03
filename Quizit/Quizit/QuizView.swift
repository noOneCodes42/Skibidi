//
//  QuizView.swift
//  Quizit
//
//  Created by Neel Arora on 1/3/25.
//

import SwiftUI

struct QuizView: View {
    @State private var currentValue: Int = 1
    @State private var maxValue: Int = 10
    @State private var backIsDisabled: Bool = true
    @State private var frontIsDisabled: Bool = false
    var body: some View {
        
        VStack{
            Text("Question")
                .padding(.bottom, 150)
            HStack{
                ZStack{
                    Text("Answer 1")
                }
                
                .padding(.trailing, 100)
                Text("Answer 2")
            }
            .padding(.bottom, 100)
            HStack{
                Text("Answer 3")
                    .padding(.trailing, 100)
                Text("Answer 4")
            }
            .padding(.bottom, 150)
            HStack{
                Button {
                    if currentValue > 1{
                        currentValue -= 1
                        backIsDisabled = false
                        frontIsDisabled = false
                    }else{
                        backIsDisabled = true
                    }
                    
                } label: {
                    Image(systemName: "chevron.backward")
                }
                .disabled(backIsDisabled)
                Text("\(currentValue) out of \(maxValue)")
                Button {
                    if currentValue < maxValue{
                        currentValue += 1
                        frontIsDisabled = false
                        backIsDisabled = false
                    }else{
                        frontIsDisabled = true
                    }
                } label: {
                    Image(systemName: "chevron.right")
                }
                .disabled(frontIsDisabled)
            }
            
            
            
        }
        
    }
}

#Preview {
    QuizView()
}
