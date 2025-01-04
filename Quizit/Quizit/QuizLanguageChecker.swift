import SwiftUI

struct QuizLanguageChecker: View {
    @StateObject var languages = LanguageManager()  // Your Language Manager
    @State var selectedLanguage = "Swift"  // Default selected language
    @State private var name: String = ""
    @State private var showingAlert: Bool = false
    @State private var canNotMoveOn: Bool = true
    @State private var searhableText: String = ""
    @State private var isLocked: Bool = false  // Lock the picker after selection
    @State private var isSearchListVisible: Bool = true  // To toggle between search list and picker

    var body: some View {
        NavigationView {
            VStack {
                Text("What Language?")
                    .font(.title)
                    .bold()

                Form {
                    // Search Field
                    TextField("Search Language:", text: $searhableText)

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
                                        showingAlert = true
                                        canNotMoveOn = true
                                    }
                                    canNotMoveOn = false
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
                }

                // Continue Button
                NavigationLink(destination: QuizView()) {
                    Text("Continue")
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
