import SwiftUI
import RealmSwift
struct QuizView: View {
    @State private var currentValue: Int = 0
    @State private var maxValue: Int = 10
    @State private var backIsDisabled: Bool = true
    @State private var frontIsDisabled: Bool = false
    @Binding var sendModelQuiz: SendModelQuiz
    @StateObject var viewModel: ViewModelQuiz = ViewModelQuiz()
    @ObservedResults(CodingLanguage.self) var realmContext
    @ObservedResults(TestTakenCounter.self) var counterContext // Track if data is loaded
    @State private var isLoading: Bool = true // Track if data is loading
    @State private var theColor: Color = .black
    @State private var counter: Int = 0 // Track number of correct answers
    @State private var selectedAnswer: Int? = nil // Track the selected answer index
    @State private var isAnswerCorrect: Bool? = nil // Store if the selected answer is correct
    @State private var chosenIndex: String = ""
    @State private var listOfChosen: [String] = []
    @State private var answeredQuestions: Set<Int> = []
    @State private var userAnswered : [Int: String] = [:]
    @State private var answerFeedback: [Int: Bool] = [:]
    @State private var isSubmitted: Bool = false
    @State private var colorCorrectOrIncorrect: Color = .blue
    @State private var showSheet: Bool = false
    @State private var canNotBeSubmitted: Bool = true
    var body: some View {
        
        VStack {
            // Show loading indicator while data is being fetched
            if isLoading {
                Text("Generating Questions ...")
                    .padding(.bottom, 20)
                ProgressView()
                    .tint(Color.blue)
                    .scaleEffect(2)
            } else {
                // After loading, show the quiz content
                if !viewModel.quizItems.isEmpty {
                    ScrollView {
                        ForEach(viewModel.quizItems.keys.sorted(), id: \.self) { key in
                            if let quiz = viewModel.quizItems[key] {
                                VStack {
                                    // Iterate over each question in the current quiz
                                    ForEach(quiz.questions.indices, id: \.self) { questionIndex in
                                        let question = quiz.questions[questionIndex]
                                        
                                        VStack {
                                            Text("\(question.number). \(question.question)")
                                                .padding(.bottom, 40)
                                                .padding()
                                                .scenePadding()
                                                .multilineTextAlignment(.center)
                                                .foregroundStyle(theColor)
                                            
                                            // Display options for each question
                                            HStack {
                                                ForEach(0..<2, id:\.self) { index in
                                                    Capsule()
                                                        .fill(self.userAnswered[questionIndex] == question.options[index] ? (answerFeedback[questionIndex] == true ? Color.green : colorCorrectOrIncorrect): Color.gray)
                                                        .frame(width: 175)
                                                        .frame(minHeight: 100)
                                                        .overlay(
                                                            Text(question.options[index])
                                                                .multilineTextAlignment(.center)
                                                            
                                                            
                                                                .scenePadding()
                                                                .onTapGesture {
                                                                    if !isSubmitted{
                                                                        userAnswered[questionIndex] = question.options[index]
                                                                    }
                                                                }
                                                            
                                                            
                                                        )
                                                        .padding(index == 0 ? .leading : .trailing, 10)
                                                    
                                                    
                                                }
                                            }
                                            .padding(.bottom, 30)
                                            HStack {
                                                ForEach(2..<4, id:\.self) { index in
                                                    Capsule()
                                                        .fill(self.userAnswered[questionIndex] == question.options[index] ? (answerFeedback[questionIndex] == true ? Color.green : colorCorrectOrIncorrect): Color.gray)
                                                        .frame(width: 175)
                                                        .frame(minHeight: 100)
                                                        .overlay(
                                                            Text(question.options[index])
                                                                .multilineTextAlignment(.center)
                                                            
                                                            
                                                                .onTapGesture {
                                                                    if !isSubmitted{
                                                                        userAnswered[questionIndex] = question.options[index]
                                                                    }
                                                                }
                                                            
                                                            
                                                        )
                                                        .padding(index == 2 ? .leading : .trailing, 10)
                                                    
                                                    
                                                    
                                                }
                                            }
                                            .padding()
                                        }
                                        .padding()
                                        
                                    }
                                    // Submit button
                                    Button {
                                        // Actions when submit is clicked
                                        isSubmitted = true
                                        counter = 0
                                        for (questionIndex, answer) in userAnswered{
                                            let questions = quiz.questions[questionIndex]
                                            let correctAnswer = questions.answer
                                            
                                            let isCorrect = (answer == questions.options[correctAnswer])
                                            answerFeedback[questionIndex] = isCorrect
                                            
                                            if isCorrect{
                                                counter += 1
                                            }else{
                                                colorCorrectOrIncorrect = .red
                                            }
                                        }
                                        showSheet.toggle()
                                        
                                    } label: {
                                        
                                        Text("Submit")
                                    }
                                    .disabled(canNotBeSubmitted)
                                }
                                
                                .navigationTitle("Test for \(sendModelQuiz.language)")
                                
                                .sheet(isPresented: $showSheet) {
                                    VStack{
                                        Text("Your Score: ")
                                            .font(.largeTitle)
                                            .fontWeight(.heavy)
                                        Text("\(counter) out of \(sendModelQuiz.questions)")
                                            .fontWeight(.bold)
                                            .font(.title)
                                        
                                    }
                                    .onAppear{
                                        print("Entered On Appear")
                                        let realm = try! Realm()
                                        if let counter = realm.objects(TestTakenCounter.self).first {
                                            try! realm.write {
                                                realm.create(TestTakenCounter.self, value: ["id": counter.id, "testTakenCounter": counter.testTakenCounter + 1], update: .modified)
                                            }
                                        } else {
                                            print("creating counter")
                                            try! realm.write {
                                                realm.create(TestTakenCounter.self, value: ["testTakenCounter": 1])
                                            }
                                        }
                                        if let language = realm.objects(CodingLanguage.self).filter({$0.language == sendModelQuiz.language}).first {
                                            try! realm.write {
                                                let scores = language.scores
                                                if scores.count > 5 {
                                                    scores.removeLast(1)
                                                }
                                                let score = Score(score: Double(counter) / Double(sendModelQuiz.questions), difficulty: sendModelQuiz.difficulty, questions: sendModelQuiz.questions)
                                                scores.append(score)
                                                realm.create(CodingLanguage.self, value: ["id": language.id, "language": sendModelQuiz.language, "scores": scores], update: .modified)
                                            }
                                        } else {
                                            let score = Score(score: Double(counter) / Double(sendModelQuiz.questions), difficulty: sendModelQuiz.difficulty, questions: sendModelQuiz.questions)
                                            try! realm.write {
                                                realm.create(CodingLanguage.self, value: ["language": sendModelQuiz.language, "scores": [score]])
                                            }
                                        }
                                        let getObjects = realm.objects(CodingLanguage.self).filter("language == '\(sendModelQuiz.language)'")
                                        print(getObjects)
                                        let count = realm.objects(TestTakenCounter.self).first?.testTakenCounter
                                        print(count)
                                        
                                        //                                        if let language = languageData.first(where: {$0.language == sendModelQuiz.language}){
                                        //                                            print("Entered If Let")
                                        //                                            let scores = language.score
                                        //                                            if scores.count > 5{
                                        //                                                language.score.removeLast()
                                        //                                            }
                                        //                                            let score = Score(score: Double(counter)/Double(sendModelQuiz.questions), difficuly: sendModelQuiz.difficulty)
                                        //                                            language.score.append(score)
                                        //                                            print("LanuageData before the do block: \(languageData)")
                                        //                                            do{                                      try context.save()
                                        //                                                print("LanguageData: \(languageData)")
                                        //                                            }catch{
                                        //                                                print(error)
                                        //                                            }
                                        //                                        }else{
                                        //                                            let score = Score(score: Double(counter)/Double(sendModelQuiz.questions), difficuly: sendModelQuiz.difficulty)
                                        //                                            let item1 = CodingLanguage(score: [score], language: sendModelQuiz.language)
                                        //                                        }
                                        
                                        
                                    }
                                }
                                .onChange(of: userAnswered) { oldValue, newValue in
                                    if userAnswered.keys.count == quiz.questions.count {
                                        canNotBeSubmitted = false
                                    }
                                }
                            }
                        }
                        
                    }
                    .scenePadding()
                } else {
                    Text("Generating Questions ...")
                        .padding(.bottom, 20)
                    ProgressView()
                        .tint(Color.blue)
                        .scaleEffect(2)
                }
            }
        }
        .onAppear {
            // Trigger the request and load data when the view appears
            loadData()
        }
    }
    
    // This function is called when the view appears to make the API request
    private func loadData() {
        // Call the API to fetch data
        viewModel.postQuiz(quizInputs: sendModelQuiz) // Assume this will fetch the quiz data
        
        // Handle the API response asynchronously
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Simulate a delay here (e.g., for API response)
            // When the data has been fetched, update state variables
            isLoading = false  // Hide loading indicator
            // Indicate that data is loaded
        }
    }
}

