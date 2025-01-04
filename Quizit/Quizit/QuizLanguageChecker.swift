//
//  QuizLanguageChecker.swift
//  Quizit
//
//  Created by Neel Arora on 1/3/25.
//

import SwiftUI

struct QuizLanguageChecker: View {
    @StateObject var languages = LanguageManager()
    @State var selectedLanguage = "Swift"
    @State var themes = ["swift", "json", "html"]
    @State private var name: String = ""
    @FocusState private var isFocused: Bool
    @State private var showingAlert: Bool = false
    @State private var canNotMoveOn: Bool = true
    @State private var searhableText: String = ""
    
    var body: some View {
        NavigationView{
            VStack{
                Text("What Language?")
                    .font(.title)
                    .bold(true)
                Form{
                    if languages.arrayOflanguages.isEmpty{
                        Text("No languages found")
                    }else{
                        Picker("Language", selection: $selectedLanguage){
                            ForEach(languages.arrayOflanguages, id: \.self){ themes in
                                Text(themes.name)
                            }
                            
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                    
                    
                    HStack{
                        Text("Difficuly Level:")
                        TextField("Enter a difficulty level", text: $name)
                            .multilineTextAlignment(.trailing)
                            .focused($isFocused)
                            .onSubmit {
                                if let _ = Int(name){
                                    if name.isEmpty{
                                        showingAlert = true
                                        canNotMoveOn = true
                                    }
                                    canNotMoveOn = false
                                }else{
                                    showingAlert = true
                                    canNotMoveOn = true
                                }
                            }
                            .alert( isPresented: $showingAlert) {
                                Alert(title: Text("Required Field"), message: Text("You must enter a difficulty level"))
                            }
                        Text("/ 10")
                    }
                }
                
                NavigationLink(destination: QuizView())
                {
                    Text("Continue")
                        .disabled(canNotMoveOn)
                    
                    
                }
                .disabled(canNotMoveOn)
                
            }
            
            
        }
        .onAppear{
            languages.getLanguage()
        }
    }
}

#Preview {
    QuizLanguageChecker()
}
