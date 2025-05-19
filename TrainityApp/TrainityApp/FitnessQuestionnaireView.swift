import SwiftUI

struct FitnessQuestionnaireView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var currentQuestionIndex = 0
    @State private var answers = [Int](repeating: -1, count: 5)
    @State private var showResults = false
    @State private var recommendedLevel = ""
    @State private var navigateToWorkouts = false // Per la navigazione a My Workouts
    
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
        .navigationBarHidden(true)
        // Aggiungiamo un NavigationLink nascosto per andare a CustomizeWorkoutView
        .background(
            NavigationLink(destination: CustomizeWorkoutView().environmentObject(workoutManager),
                           isActive: $navigateToWorkouts) {
                EmptyView()
            }
        )
    }
    
    var questionView: some View {
        VStack(spacing: 15) {
            // Navigazione in alto
            HStack {
                Button(action: {
                    withAnimation { currentQuestionIndex -= 1 }
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.title)
                        .foregroundColor(currentQuestionIndex == 0 ? .gray.opacity(0.5) : .gray)
                }
                .disabled(currentQuestionIndex == 0)
                
                Spacer()
                
                Button(action: {
                    if currentQuestionIndex < questions.count - 1 {
                        withAnimation { currentQuestionIndex += 1 }
                    } else {
                        calculateResults()
                        createRecommendedWorkout() // Crea un workout basato sui risultati
                        showResults = true
                    }
                }) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title)
                        .foregroundColor(answers[currentQuestionIndex] == -1 ? .gray.opacity(0.5) : .teal)
                }
                .disabled(answers[currentQuestionIndex] == -1)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
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
                ForEach(0..<questions[currentQuestionIndex].options.count, id: \.self) { index in
                    OptionButton(
                        text: questions[currentQuestionIndex].options[index],
                        isSelected: answers[currentQuestionIndex] == index,
                        action: {
                            answers[currentQuestionIndex] = index
                            // Avanza automaticamente dopo la selezione
                            if currentQuestionIndex < questions.count - 1 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation { currentQuestionIndex += 1 }
                                }
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    calculateResults()
                                    createRecommendedWorkout() // Crea un workout basato sui risultati
                                    showResults = true
                                }
                            }
                        }
                    )
                }
            }
            .padding()
            
            Spacer()
        }
    }
    
    var resultsView: some View {
        VStack(spacing: 25) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 70))
                .foregroundColor(.teal)
            
            Text("Valutazione Completata!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Livello consigliato: \(recommendedLevel)")
                .font(.title3)
                .foregroundColor(.teal)
                .padding(.bottom, 10)
                
            Text("Abbiamo creato un programma di allenamento personalizzato basato sul tuo livello!")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                .padding(.horizontal)
            
            Button(action: {
                navigateToWorkouts = true
            }) {
                HStack {
                    Image(systemName: "dumbbell.fill")
                    Text("Vai alla sezione My Workouts")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.1, green: 0.4, blue: 0.4))
                .cornerRadius(15)
                .padding(.horizontal, 30)
                .padding(.top, 20)
            }
            
            Button("Riprova il questionario") {
                resetQuestionnaire()
            }
            .buttonStyle(.bordered)
            .tint(.teal)
            .padding(.top, 10)
            
            Spacer()
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
    
    func createRecommendedWorkout() {
        // Crea un workout basato sul livello dell'utente
        var newWorkout: Workout
        
        switch recommendedLevel {
        case "Principiante":
            newWorkout = Workout(
                name: "Programma Principiante",
                duration: 30,
                exercises: [
                    Exercise(name: "Push-up sulle ginocchia", sets: 3, reps: 8),
                    Exercise(name: "Squat assistiti", sets: 3, reps: 10),
                    Exercise(name: "Plank", sets: 3, reps: 20), // secondi
                    Exercise(name: "Jumping Jack", sets: 3, reps: 15)
                ],
                goal: "Condizionamento Base",
                restTime: 60,
                type: .general,
                caloriesBurned: 180
            )
        case "Intermedio":
            newWorkout = Workout(
                name: "Programma Intermedio",
                duration: 40,
                exercises: [
                    Exercise(name: "Push-up", sets: 3, reps: 12),
                    Exercise(name: "Squat", sets: 3, reps: 15),
                    Exercise(name: "Plank laterale", sets: 3, reps: 30), // secondi per lato
                    Exercise(name: "Burpees", sets: 3, reps: 10),
                    Exercise(name: "Mountain climbers", sets: 3, reps: 20)
                ],
                goal: "Forza e Resistenza",
                restTime: 45,
                type: .general,
                caloriesBurned: 250
            )
        case "Avanzato":
            newWorkout = Workout(
                name: "Programma Avanzato",
                duration: 50,
                exercises: [
                    Exercise(name: "Push-up con battuta", sets: 4, reps: 12),
                    Exercise(name: "Squat jump", sets: 4, reps: 15),
                    Exercise(name: "Plank con alternanza", sets: 3, reps: 45), // secondi
                    Exercise(name: "Burpees avanzati", sets: 3, reps: 15),
                    Exercise(name: "Pike push-up", sets: 3, reps: 10),
                    Exercise(name: "Affondi alternati", sets: 3, reps: 20)
                ],
                goal: "Forza e Potenza",
                restTime: 30,
                type: .strength,
                caloriesBurned: 320
            )
        default: // Esperto
            newWorkout = Workout(
                name: "Programma Esperto",
                duration: 60,
                exercises: [
                    Exercise(name: "Push-up con applauso", sets: 4, reps: 15),
                    Exercise(name: "Pistol squat", sets: 3, reps: 8),
                    Exercise(name: "Plank con spostamento", sets: 4, reps: 60), // secondi
                    Exercise(name: "Burpees con pull-up", sets: 4, reps: 10),
                    Exercise(name: "Handstand push-up", sets: 3, reps: 8),
                    Exercise(name: "Box jump", sets: 4, reps: 12),
                    Exercise(name: "Muscle-up", sets: 3, reps: 6)
                ],
                goal: "Forza e Resistenza Avanzata",
                restTime: 20,
                type: .strength,
                caloriesBurned: 400
            )
        }
        
        // Aggiungi il nuovo workout alla lista dei workout salvati
        workoutManager.savedWorkouts.append(newWorkout)
    }
    
    func resetQuestionnaire() {
        currentQuestionIndex = 0
        answers = [Int](repeating: -1, count: questions.count)
        showResults = false
        recommendedLevel = ""
    }
}



