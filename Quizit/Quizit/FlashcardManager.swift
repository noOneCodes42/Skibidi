//
//  FlashcardManager.swift
//  Quizit
//
//  Created by Neel Arora on 1/4/25.
//

import Foundation
class FlashcardManager: ObservableObject {
    @Published var result: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var flashCardItems: [Int: FlashCardGet] = [:]
    func postQuiz(quizInputs: FlashCardSend){
        guard let url = URL(string: "https://skibidi.hpsk.me/query-language-flashcards") else {
            errorMessage = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("I am at the request")
        do{
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(quizInputs)
            request.httpBody = jsonData
            print("I am at the encoder")
        }catch {
            errorMessage = "Error encoding JSON"
            return
        }
        isLoading = true
        print("I am at the loading")
        URLSession.shared.dataTask(with: request){data, response, error in
            print("Ive entered the URLSession")
            
            guard let safeData = data, error == nil else{
                self.errorMessage = "No data received"
                return
            }
            print(safeData)
            do{
                let questions = try JSONDecoder().decode(FlashCardGet.self, from: safeData)
                let quizUUID = UUID()
                DispatchQueue.main.async{
                    self.flashCardItems[0] = questions
                    self.isLoading = false
                    print(self.flashCardItems)
                }
            }catch{
                print(error)
                return
            }
        }.resume()
        
    }
}
