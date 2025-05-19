//
//  ProgressBar.swift
//  TrainityApp
//
//  Created by Raffa Roberto on 19/05/25.
//

import SwiftUI


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
