//
//  FlashCardChecker.swift
//  Quizit
//
//  Created by Neel Arora on 1/4/25.
//

import SwiftUI

struct FlashCardChecker: View {
    @StateObject var languages = LanguageManager()  // Your Language Manager
    @State var selectedLanguage = ""  // Default selected language
    @State private var name: String = ""
    @State private var showingAlertFlashCard: Bool = false
    @State private var canNotMoveOn: Bool = true
    @State private var searhableText: String = ""
    @State private var isLocked: Bool = false  // Lock the picker after selection
    @State private var questionsUserInput: String = ""
    @State private var isSearchListVisible: Bool = true  // To toggle between search list and picker
    @State private var intDifficulty: Int = 0
    @State private var questionsAmount: Int = 0
    @State private var isNavigationActive = false
    @State var sendModelQuiz: FlashCardSend = FlashCardSend(language: "", difficulty: 1, cards: 6)
    @State var counterFlashCard: Int = 0
    @State var otherCounterFlashCards: Int = 0
    var body: some View {
        NavigationView {
            VStack {
                Text("What Language?")
                    .font(.title)
                    .bold()
                
                Form {
                    // Search Field
                    TextField("Search Language:", text: $searhableText)
                        .autocorrectionDisabled()
                    // Display the search list if it's visible
                    if isSearchListVisible{
                        List {
                            ForEach(languages.arrayOflanguages, id: \.self) { language in
                                if language.name.contains(searhableText) {
                                    Button {
                                        // When a language is selected
                                        selectedLanguage = language.name
                                        isLocked = true // Lock the picker
                                        isSearchListVisible = false // Hide the search list
                                        if language.name.isEmpty {
                                            showingAlertFlashCard = true
                                            canNotMoveOn = true
                                        }else{
                                            otherCounterFlashCards = 1
                                        }
                                        // Make the search list items transparent
                                    } label: {
                                        Text(language.name)
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    // Show message when no languages found
                    if languages.arrayOflanguages.isEmpty {
                        Text("No languages found")
                    } else {
                        // Show the Picker once the search list is hidden
                        if !isSearchListVisible {
                            Picker("Language", selection: $selectedLanguage) {
                                ForEach(languages.arrayOflanguages, id: \.self) { language in
                                    Text(language.name).tag(language.name)
                                }
                            }
                            .pickerStyle(WheelPickerStyle()) // WheelPickerStyle shows the picker as a wheel
                            // Disable further interaction if locked
                            .onChange(of: searhableText){
                                isSearchListVisible = true
                            }
                        }
                    }
                    
                    // Difficulty Level Section
                    HStack {
                        Text("Difficulty Level:")
                        TextField("Enter a difficulty level", text: $name)
                            .multilineTextAlignment(.trailing)
                            .onSubmit {
                                if let _ = Int(name) {
                                    if name.isEmpty {
                                        showingAlertFlashCard = true
                                        canNotMoveOn = true
                                    }else{
                                        counterFlashCard = 1
                                    }
                                    intDifficulty = Int(name) ?? 0
                                    if intDifficulty > 10{
                                        showingAlertFlashCard = true
                                    } else {
                                        canNotMoveOn = true
                                    }
                                }
                                
                                
                            }
                            .alert(isPresented: $showingAlertFlashCard) {
                                Alert(title: Text("Required Field"), message: Text("You must enter a difficulty level"))
                            }
                        Text("/ 10")
                    }
                    HStack {
                        Text("Cards")
                        TextField("Enter an amount of cards", text: $questionsUserInput)
                            .multilineTextAlignment(.trailing)
                            .onSubmit {
                                if let _ = Int(questionsUserInput) {
                                    if name.isEmpty {
                                        showingAlertFlashCard = true
                                        canNotMoveOn = true
                                    }
                                    
                                    questionsAmount = Int(questionsUserInput) ?? 0
                                    if questionsAmount <= 50 && counterFlashCard == 1{
                                        canNotMoveOn = false
                                        showingAlertFlashCard = false
                                    }else{
                                        showingAlertFlashCard = true
                                    }
                                    
                                } else {
                                    showingAlertFlashCard = true
                                    canNotMoveOn = true
                                }
                            }
                            .alert(isPresented: $showingAlertFlashCard) {
                                Alert(title: Text("Required Field"), message: Text("You Must Follow Format"))
                            }
                        Text("/ 50")
                    }
                    
                    
                    // Continue Button
                    
                }
                NavigationLink(destination: FlashCardView(flashCard: $sendModelQuiz), isActive: $isNavigationActive){
                    Text("Continue")
                        .padding()
                        .onTapGesture {
                            isNavigationActive = true
                            
                            sendModelQuiz = FlashCardSend(language: selectedLanguage, difficulty: intDifficulty, cards: questionsAmount)
                            
                            print(sendModelQuiz)
                        }
                        .disabled(canNotMoveOn)
                }
                
                
                .disabled(canNotMoveOn)
            }
            .onAppear {
                languages.getLanguage()  // Load the languages
            }
        }
    }
}
#Preview {
    FlashCardChecker()
}
