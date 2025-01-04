import SwiftUI

struct QuizView: View {
    @State private var currentValue: Int = 0
    @State private var maxValue: Int = 10
    @State private var backIsDisabled: Bool = true
    @State private var frontIsDisabled: Bool = false
    @Binding var sendModelQuiz: SendModelQuiz
    @StateObject var viewModel: ViewModelQuiz = ViewModelQuiz()

    @State private var isDataLoaded: Bool = false // Track if data is loaded
    @State private var isLoading: Bool = true // Track if data is loading
    @State private var theColor: Color = .black
    @State private var counter: Int = 0 // Track number of correct answers
    @State private var selectedAnswer: Int? = nil // Track the selected answer index
    @State private var isAnswerCorrect: Bool? = nil // Store if the selected answer is correct

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
                                        let correctAnswerIndex = question.answer // This is an index of the correct answer
                                        
                                        VStack {
                                            Text(question.question)
                                                .padding(.bottom, 50)
                                                .padding()
                                                .multilineTextAlignment(.center)
                                                .lineLimit(5)
                                                .foregroundStyle(theColor)

                                            // Display options for each question
                                            HStack {
                                                Text(question.options[0])
                                                    .onTapGesture {
                                                        selectedAnswer = 0
                                                        isAnswerCorrect = selectedAnswer == correctAnswerIndex
                                                        if isAnswerCorrect == true {
                                                            counter += 1
                                                        }
                                                    }
                                                    .padding()
                                                    .multilineTextAlignment(.center)
                                                    .lineLimit(5)
                                                
                                                Text(question.options[1])
                                                    .onTapGesture {
                                                        selectedAnswer = 1
                                                        isAnswerCorrect = selectedAnswer == correctAnswerIndex
                                                        if isAnswerCorrect == true {
                                                            counter += 1
                                                        }
                                                    }
                                                    .padding()
                                                    .multilineTextAlignment(.center)
                                                    .lineLimit(5)
                                            }
                                            .padding()
                                            
                                            HStack {
                                                Text(question.options[2])
                                                    .onTapGesture {
                                                        selectedAnswer = 2
                                                        isAnswerCorrect = selectedAnswer == correctAnswerIndex
                                                        if isAnswerCorrect == true {
                                                            counter += 1
                                                        }
                                                    }
                                                    .multilineTextAlignment(.center)
                                                    .lineLimit(5)
                                                    .padding()

                                                Text(question.options[3])
                                                
                                                    .onTapGesture {
                                                        selectedAnswer = 3
                                                        isAnswerCorrect = selectedAnswer == correctAnswerIndex
                                                        if isAnswerCorrect == true {
                                                            counter += 1
                                                        }
                                                    }
                                                    .multilineTextAlignment(.center)
                                                    .lineLimit(5)
                                                    .padding()
                                            }
                                            .padding()
                                        }
                                    }

                                    // Submit button
                                    Button {
                                        // Actions when submit is clicked
                                        print("Submit clicked! Total correct answers: \(counter) / \(sendModelQuiz.questions) or \(Double(counter)/Double(sendModelQuiz.questions)*100)%")
                                    } label: {
                                        Text("Submit")
                                            .padding(.top, 50)
                                            .padding(.bottom, 50)
                                    }
                                }
                                .navigationTitle("Test for \(sendModelQuiz.language)")
                                .foregroundStyle(.blue)
                            }
                        }
                    }
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
            isDataLoaded = true // Indicate that data is loaded
        }
    }
}
