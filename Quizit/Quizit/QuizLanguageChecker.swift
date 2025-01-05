import SwiftUI

struct QuizLanguageChecker: View {
    @StateObject var languages = LanguageManager()  // Your Language Manager
    @State var selectedLanguage = ""  // Default selected language
    @State private var name: String = ""
    @State private var showingAlert: Bool = false
    @State private var canNotMoveOn: Bool = true
    @State private var searhableText: String = ""
    @State private var isLocked: Bool = false  // Lock the picker after selection
    @State private var questionsUserInput: String = ""
    @State private var isSearchListVisible: Bool = true  // To toggle between search list and picker
    @State private var intDifficulty: Int = 0
    @State private var questionsAmount: Int = 0
    @State private var isNavigationActive = false
    @State var sendModelQuiz: SendModelQuiz = SendModelQuiz(language: "", difficulty: 1, questions: 6)
    @State var counterForQuiz: Int = 0
    @State var otherCounter: Int = 0
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
                                            showingAlert = true
                                            canNotMoveOn = true
                                        }else{
                                            otherCounter = 1
                                        }
                                         // Make the search list items transparent
                                    } label: {
                                        Text(language.name)
                                    }
                                    .id(UUID())
                                    
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
                                        showingAlert = true
                                        canNotMoveOn = true
                                    }else{
                                        counterForQuiz = 1
                                    }
                                    intDifficulty = Int(name) ?? 0
                                    if intDifficulty > 10{
                                        showingAlert = true
                                    }
                                } else {
                                    showingAlert = true
                                    canNotMoveOn = true
                                }
                            }
                            .alert(isPresented: $showingAlert) {
                                Alert(title: Text("Required Field"), message: Text("You must enter a difficulty level"))
                            }
                        Text("/ 10")
                    }
                    HStack {
                        Text("Questions")
                        TextField("How many questions?", text: $questionsUserInput)
                            .multilineTextAlignment(.trailing)
                            .onSubmit {
                                if let _ = Int(questionsUserInput) {
                                    if name.isEmpty {
                                        showingAlert = true
                                        canNotMoveOn = true
                                    }
                                    questionsAmount = Int(questionsUserInput) ?? 0
                                    if questionsAmount <= 50 && counterForQuiz == 1 && otherCounter == 1{
                                        canNotMoveOn = false
                                    }else{
                                        showingAlert = true
                                    }
                                } else {
                                    showingAlert = true
                                    canNotMoveOn = true
                                }
                            }
                            .alert(isPresented: $showingAlert) {
                                Alert(title: Text("Required Field"), message: Text("You must enter a question amount"))
                            }
                        Text("/ 50")
                    }
                }
                
                // Continue Button
                NavigationLink(destination: QuizView(sendModelQuiz: $sendModelQuiz), isActive: $isNavigationActive){
                    Text("Continue")
                        .padding()
                        .onTapGesture {
                            isNavigationActive = true
                            
                                sendModelQuiz = SendModelQuiz(language: selectedLanguage, difficulty: intDifficulty, questions: questionsAmount)
                            
                            print(sendModelQuiz)
                        
                        }
                        .disabled(canNotMoveOn)
                }


                .disabled(canNotMoveOn)
            }
        }
        .onAppear {
            languages.getLanguage()  // Load the languages
        }
    }
}

#Preview {
    QuizLanguageChecker()
}
