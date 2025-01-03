//
//  LanguageManager.swift
//  Quizit
//
//  Created by Neel Arora on 1/3/25.
//

import Foundation
struct LanguageManager{
    
    private var url = URL(string: "https://skibidi.hpsk.me/programming-languages")!
    func getLanguage(){
        URLSession.shared.dataTask(with: url){data, response, error in
            guard let data = data, error == nil else{
                print("Error has occured: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }
            do{
                let languages = try JSONDecoder().decode([Language].self, from: data)
                print(languages)
            }catch{
                print("An error has occured: \(error.localizedDescription)")
            }
        }.resume()
    }
}

