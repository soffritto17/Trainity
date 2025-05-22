import SwiftUI

struct TimerSheetView: View {
    @Binding var timeRemaining: Int
    @Binding var isTimerRunning: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color("wht").edgesIgnoringSafeArea(.all)
            
            VStack {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color("blk").opacity(0.3))
                    .frame(width: 40, height: 5)
                    .padding(.top, 8)
                
                Text("Timer di Recupero")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("blk"))
                    .padding(.top, 10)
                
                ZStack {
                    Circle()
                        .stroke(Color("blk").opacity(0.2), lineWidth: 15)
                        .frame(width: 250, height: 250)
                    
                    Circle()
                        .trim(from: 0, to: timeRemaining == 0 ? 1 : CGFloat(timeRemaining) / 60.0)
                        .stroke(Color("blk"), lineWidth: 15)
                        .frame(width: 250, height: 250)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear, value: timeRemaining)
                    
                    VStack {
                        Text("\(timeRemaining)")
                            .font(.system(size: 70, weight: .bold))
                            .foregroundColor(Color("blk"))
                        
                        Text("secondi")
                            .font(.title3)
                            .foregroundColor(Color("blk"))
                    }
                }
                .padding(.vertical, 20)
                
                Button(action: {
                    isTimerRunning.toggle()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color("blk"))
                            .frame(width: 90, height: 90)
                            .shadow(color: Color("blk").opacity(0.2), radius: 3)
                        
                        Image(systemName: isTimerRunning ? "pause.fill" : "play.fill")
                            .font(.largeTitle)
                            .foregroundColor(Color("wht"))
                    }
                }
                .padding(.vertical, 10)
                
                HStack(spacing: 15) {
                    ForEach([30, 60, 90, 120], id: \.self) { seconds in
                        Button(action: {
                            timeRemaining = seconds
                            isTimerRunning = false
                        }) {
                            Text("\(seconds)s")
                                .font(.headline)
                                .foregroundColor(timeRemaining == seconds ? Color("wht") : Color("blk"))
                                .frame(width: 70, height: 40)
                                .background(timeRemaining == seconds ? Color("blk") : Color("wht"))
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color("blk"), lineWidth: 1)
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
