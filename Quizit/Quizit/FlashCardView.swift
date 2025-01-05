//
//  Flashcard.swift
//  Quizit
//
//  Created by Neel Arora on 1/3/25.
//

import SwiftUI
import SwiftData
struct FlashCardView: View {
    @State var counter: Int = 0
    @Environment(\.modelContext) private var context
    @Query private var items: [TestTakenCounter]
    // Get the backend for this
    @State var max: Int = 15
    @State var isDisabledForBack: Bool = true
    @State var isDisabledForFront: Bool = false
    @Binding var flashCard: FlashCardSend
    @State var test: FlashCardSend = FlashCardSend(language: "javascript", difficulty: 3, cards: 15)
    @StateObject var flashCardManager: FlashcardManager = FlashcardManager()
    @State private var isDataLoaded: Bool = false
    @State private var isLoading: Bool = true
    @State private var isFlipped: Bool = false
    @State private var showCounter: Int = 1
    @State var numberOfTestsTaken = 0
    var body: some View {
        
        VStack{
            if isLoading{
                Text("Awaiting Your Cards ...")
                    .padding(.bottom, 20)
                ProgressView()
                    .scaleEffect(2)
                    .tint(Gradient(colors: [.red, .black]))
                
            }else{
                
                if !flashCardManager.flashCardItems.isEmpty{
                    ForEach(0..<flashCard.cards, id: \.self){ index in
                        if index == counter{
                            ZStack{
                                if !isFlipped{
                                    Text(flashCardManager.flashCardItems[0]?.cards[index].question ?? "")
                                        .padding()
                                        .frame(width: 300, height: 200)
                                        .background(Color.white)
                                        .foregroundStyle(.black)
                                        .cornerRadius(10)
                                        .shadow(radius: 10)
                                        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y:1, z: 0))
                                } else{
                                    Text(flashCardManager.flashCardItems[0]?.cards[index].answer ?? "")
                                    
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
                    .padding(.bottom, 20)
                    HStack {
                        Button {
                            if showCounter > 1{
                                counter -= 1
                                showCounter -= 1
                                isDisabledForFront = false
                            }else{
                                isDisabledForBack = true
                            }
                            
                        } label: {
                            Image(systemName: "chevron.backward")
                        }
                        .disabled(isDisabledForBack)
                        Text("\(showCounter) out of \(flashCard.cards)")
                        Button {
                            
                            
                            if showCounter < flashCard.cards {
                                counter += 1
                                showCounter += 1
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
                    
                }else{
                    Text("Awaiting Your Cards ...")
                        .padding(.bottom, 20)
                    ProgressView()
                        .scaleEffect(2)
                        .tint(Gradient(colors: [.red, .black]))
                    
                }
            }
        }
        .onAppear{
            loadDataFlashCard()
        }
    }
    private func loadDataFlashCard() {
        // Call the API to fetch data
        flashCardManager.postQuiz(quizInputs: flashCard) // Assume this will fetch the quiz data
        
        // Handle the API response asynchronously
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Simulate a delay here (e.g., for API response)
            // When the data has been fetched, update state variables
            isLoading = false  // Hide loading indicator
            isDataLoaded = true // Indicate that data is loaded
        }
    }
}

