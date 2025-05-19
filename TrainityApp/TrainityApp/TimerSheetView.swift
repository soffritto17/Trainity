import SwiftUI

struct TimerSheetView: View {
    @Binding var timeRemaining: Int
    @Binding var isTimerRunning: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color(red: 0.9, green: 0.95, blue: 0.95).edgesIgnoringSafeArea(.all)
            
            VStack {
                // Handle per trascinare il foglio
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 5)
                    .padding(.top, 8)
                
                Text("Timer di Recupero")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    .padding(.top, 10)
                
                // Timer circle
                ZStack {
                    Circle()
                        .stroke(Color(red: 0.1, green: 0.4, blue: 0.4).opacity(0.3), lineWidth: 15)
                        .frame(width: 250, height: 250)
                    
                    Circle()
                        .trim(from: 0, to: timeRemaining == 0 ? 1 : CGFloat(timeRemaining) / 60.0)
                        .stroke(Color(red: 0.1, green: 0.4, blue: 0.4), lineWidth: 15)
                        .frame(width: 250, height: 250)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear, value: timeRemaining)
                    
                    VStack {
                        Text("\(timeRemaining)")
                            .font(.system(size: 70, weight: .bold))
                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                        
                        Text("secondi")
                            .font(.title3)
                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    }
                }
                .padding(.vertical, 20)
                
                // Timer controls - solo play/pause
                Button(action: {
                    isTimerRunning.toggle()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.1, green: 0.4, blue: 0.4))
                            .frame(width: 90, height: 90)
                            .shadow(color: Color.gray.opacity(0.3), radius: 3)
                        
                        Image(systemName: isTimerRunning ? "pause.fill" : "play.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                }
                .padding(.vertical, 10)
                
                // Time presets
                HStack(spacing: 15) {
                    ForEach([30, 60, 90, 120], id: \.self) { seconds in
                        Button(action: {
                            timeRemaining = seconds
                            isTimerRunning = false
                        }) {
                            Text("\(seconds)s")
                                .font(.headline)
                                .foregroundColor(timeRemaining == seconds ? .white : Color(red: 0.1, green: 0.4, blue: 0.4))
                                .frame(width: 70, height: 40)
                                .background(
                                    timeRemaining == seconds ?
                                        Color(red: 0.1, green: 0.4, blue: 0.4) :
                                        Color.white
                                )
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color(red: 0.1, green: 0.4, blue: 0.4), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(.bottom, 30)
        }
    }
}
