import SwiftUI
import AudioToolbox
import AVFoundation

struct ActiveWorkoutView: View {
    let workout: Workout
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var completedSets: [String: [Int]] = [:]
    @State private var currentExerciseIndex = 0
    @State private var showingCompletionAlert = false
    @State private var showingTimerSheet = false
    @State private var timeRemaining: Int = 60
    @State private var isTimerRunning: Bool = false
    @State private var timer: Timer? = nil
    @State private var startTime: Date? = nil
    
    var body: some View {
        ZStack {
            Color("wht")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Allenamento: \(workout.name)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("blk"))
                    .padding(.top, 20)
                
                ProgressView(value: Double(currentExerciseIndex), total: Double(workout.exercises.count))
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .tint(Color("blk"))
                
                Text("\(currentExerciseIndex)/\(workout.exercises.count) esercizi completati")
                    .font(.subheadline)
                    .foregroundColor(Color("blk"))
                    .padding(.top, 5)
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(0..<workout.exercises.count, id: \.self) { index in
                            let exercise = workout.exercises[index]
                            
                            ExerciseTrackingCard(
                                exercise: exercise,
                                isActive: index == currentExerciseIndex,
                                isCompleted: index < currentExerciseIndex,
                                completedReps: completedSets[exercise.id.uuidString] ?? Array(repeating: 0, count: exercise.sets),
                                onSetComplete: { setIndex, reps in
                                    var exerciseSets = completedSets[exercise.id.uuidString] ?? Array(repeating: 0, count: exercise.sets)
                                    exerciseSets[setIndex] = reps
                                    completedSets[exercise.id.uuidString] = exerciseSets
                                    
                                    let allSetsCompleted = exerciseSets.allSatisfy { $0 > 0 }
                                    if allSetsCompleted && setIndex == exercise.sets - 1 {
                                        if index < workout.exercises.count - 1 {
                                            currentExerciseIndex = index + 1
                                        } else {
                                            showingCompletionAlert = true
                                        }
                                    }
                                }
                            )
                            .padding(.horizontal)
                        }
                        Spacer().frame(height: 80)
                    }
                }
                
                VStack {
                    Divider()
                        .background(Color("blk").opacity(0.3))
                    
                    Button(action: {
                        showingTimerSheet = true
                    }) {
                        HStack {
                            Button(action: {
                                toggleTimer()
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color("blk"))
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: isTimerRunning ? "pause.fill" : "play.fill")
                                        .font(.title2)
                                        .foregroundColor(Color("wht"))
                                }
                            }
                            .padding(.trailing, 10)
                            
                            VStack(alignment: .leading) {
                                Text("Timer Recupero")
                                    .font(.subheadline)
                                    .foregroundColor(Color("blk"))
                                
                                Text("\(timeRemaining) secondi")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("blk"))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.up")
                                .foregroundColor(Color("blk"))
                                .padding(.trailing)
                        }
                        .padding()
                        .background(Color("wht"))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .background(Color("wht"))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                timer?.invalidate()
                timer = nil
                if currentExerciseIndex > 0 || !completedSets.isEmpty {
                    saveWorkoutToHistory()
                }
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Termina")
                    .font(.headline)
                    .foregroundColor(Color("blk"))
            }
        )
        .sheet(isPresented: $showingTimerSheet) {
            TimerSheetView(timeRemaining: $timeRemaining, isTimerRunning: $isTimerRunning)
                .presentationDragIndicator(.visible)
        }
        .alert(isPresented: $showingCompletionAlert) {
            Alert(
                title: Text("Allenamento Completato"),
                message: Text("Hai completato tutti gli esercizi dell'allenamento!"),
                primaryButton: .default(Text("Salva Risultati")) {
                    saveWorkoutToHistory()
                    timer?.invalidate()
                    timer = nil
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel(Text("Chiudi")) {
                    timer?.invalidate()
                    timer = nil
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .onAppear {
            startTime = Date()
            timeRemaining = workout.restTime
            setupTimer()
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
        .onChange(of: isTimerRunning) { newValue in
            if newValue {
                startTimer()
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    private func saveWorkoutToHistory() {
        let endTime = Date()
        let durationInSeconds = startTime != nil ? endTime.timeIntervalSince(startTime!) : 0
        let durationInMinutes = max(Int(durationInSeconds / 60), 1)
        workoutManager.completeWorkout(workout)
    }
    
    private func setupTimer() {
        timer = nil
    }
    
    private func toggleTimer() {
        isTimerRunning.toggle()
    }
    
    private func startTimer() {
        if timeRemaining > 0 {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    handleTimerCompletion()
                }
            }
        } else {
            isTimerRunning = false
        }
    }
    
    private func handleTimerCompletion() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
        
        withAnimation(.easeInOut(duration: 0.3)) {
            showingTimerSheet = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            timeRemaining = workout.restTime
        }
        
        playTimerComplete()
    }
    
    private func playTimerComplete() {
        startLongVibration()
        playLoudAlarmSound()
    }
    
    private func startLongVibration() {
        let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
        heavyImpact.impactOccurred()
        var vibrationCount = 0
        let totalVibrations = 10
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            vibrationCount += 1
            heavyImpact.impactOccurred()
            if vibrationCount >= totalVibrations {
                timer.invalidate()
            }
        }
    }
    
    private func playLoudAlarmSound() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Errore configurazione audio: \(error)")
        }
        
        AudioServicesPlaySystemSound(1005)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            AudioServicesPlaySystemSound(1013)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }
}
