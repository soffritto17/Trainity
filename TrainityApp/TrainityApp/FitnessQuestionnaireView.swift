import SwiftUI

struct FitnessQuestionnaireView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var currentQuestionIndex = 0
    @State private var answers = [Int](repeating: -1, count: 5)
    @State private var showResults = false
    @State private var recommendedLevel = ""
    
    let questions = [
        Question(
            text: "Quanti push-up puoi fare di fila?",
            options: ["Meno di 10", "Tra 11 e 20", "Tra 21 e 30", "Più di 30"],
            bodyPart: "Petto e Tricipiti"
        ),
        Question(
            text: "Quanti squat puoi fare di fila?",
            options: ["Meno di 15", "Tra 16 e 25", "Tra 26 e 40", "Più di 40"],
            bodyPart: "Gambe"
        ),
        Question(
            text: "Quante trazioni alla sbarra puoi eseguire?",
            options: ["Nessuna", "Tra 1 e 5", "Tra 6 e 10", "Più di 10"],
            bodyPart: "Schiena e Bicipiti"
        ),
        Question(
            text: "Per quanto tempo riesci a mantenere la posizione della plank?",
            options: ["Meno di 30 secondi", "Tra 30 e 60 secondi", "Tra 60 e 120 secondi", "Più di 120 secondi"],
            bodyPart: "Core e Addominali"
        ),
        Question(
            text: "Quanti burpees riesci a fare in un minuto?",
            options: ["Meno di 10", "Tra 10 e 15", "Tra 16 e 25", "Più di 25"],
            bodyPart: "Cardio e Resistenza Generale"
        )
    ]
    
    var body: some View {
        VStack {
            if showResults {
                resultsView
            } else {
                questionView
            }
        }
        .navigationTitle("Valutazione Fitness")
        .background(Color(UIColor.systemGray6).ignoresSafeArea())
    }
    
    var questionView: some View {
        VStack(spacing: 20) {
            ProgressBar(value: Double(currentQuestionIndex) / Double(questions.count - 1))
                .frame(height: 10)
                .padding(.horizontal)
            
            Text("Domanda \(currentQuestionIndex + 1) di \(questions.count)")
                .foregroundColor(.gray)
            
            Text(questions[currentQuestionIndex].bodyPart)
                .font(.headline)
                .foregroundColor(.teal)
            
            Text(questions[currentQuestionIndex].text)
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(0..<questions[currentQuestionIndex].options.count, id: \ .self) { index in
                    OptionButton(
                        text: questions[currentQuestionIndex].options[index],
                        isSelected: answers[currentQuestionIndex] == index,
                        action: {
                            answers[currentQuestionIndex] = index
                        }
                    )
                }
            }
            .padding()
            
            Spacer()
            
            HStack {
                if currentQuestionIndex > 0 {
                    Button("Indietro") {
                        withAnimation { currentQuestionIndex -= 1 }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.gray)
                }
                
                Button(currentQuestionIndex < questions.count - 1 ? "Avanti" : "Completa") {
                    if currentQuestionIndex < questions.count - 1 {
                        withAnimation { currentQuestionIndex += 1 }
                    } else {
                        calculateResults()
                        showResults = true
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(answers[currentQuestionIndex] == -1 ? .gray : .teal)
                .disabled(answers[currentQuestionIndex] == -1)
            }
            .padding(.horizontal)
        }
    }
    
    var resultsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 70))
                .foregroundColor(.teal)
            
            Text("Valutazione Completata!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Livello consigliato: \(recommendedLevel)")
                .font(.title3)
                .foregroundColor(.teal)
            

            .buttonStyle(.borderedProminent)
            .tint(.teal)
            
            Button("Riprova il questionario") {
                resetQuestionnaire()
            }
            .buttonStyle(.bordered)
            .tint(.teal)
        }
        .padding()
    }
    
    func calculateResults() {
        let totalScore = answers.reduce(0, +)
        let averageScore = Double(totalScore) / Double(answers.count)
        
        switch averageScore {
        case ..<1.0: recommendedLevel = "Principiante"
        case ..<2.0: recommendedLevel = "Intermedio"
        case ..<3.0: recommendedLevel = "Avanzato"
        default: recommendedLevel = "Esperto"
        }
    }
    
    func resetQuestionnaire() {
        currentQuestionIndex = 0
        answers = [Int](repeating: -1, count: questions.count)
        showResults = false
        recommendedLevel = ""
    }
}

struct Question {
    let text: String
    let options: [String]
    let bodyPart: String
}

struct ProgressBar: View {
    var value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                Rectangle()
                    .fill(Color.teal)
                    .frame(width: CGFloat(self.value) * geometry.size.width, height: geometry.size.height)
                    .animation(.linear, value: value)
            }
            .cornerRadius(45)
        }
    }
}

struct OptionButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.body)
                    .foregroundColor(isSelected ? .white : .black)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(isSelected ? Color.teal : Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: isSelected ? Color.teal.opacity(0.3) : .clear, radius: 5)
        }
    }
}
