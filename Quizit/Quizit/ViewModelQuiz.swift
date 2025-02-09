//
//  ViewModelQuiz.swift
//  Quizit
//
//  Created by Neel Arora on 1/3/25.
//

import Foundation
class ViewModelQuiz: ObservableObject{
    @Published var result: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var quizItems: [Int: GetModelQuiz] = [:]
    func postQuiz(quizInputs: SendModelQuiz){
        guard let url = URL(string: "https://skibidi.hpsk.me/query-language-questions") else {
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
                let questions = try JSONDecoder().decode(GetModelQuiz.self, from: safeData)
                let quizUUID = UUID()
                DispatchQueue.main.async{
                    self.quizItems[0] = questions
                    self.isLoading = false
                    print(self.quizItems)
                }
            }catch{
                print(error)
                return
            }
        }.resume()
        
    }
}
