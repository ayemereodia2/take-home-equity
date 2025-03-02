//
//  WaveLoadingIndicator.swift
//  Equity
//
//  Created by ANDELA on 02/03/2025.
//

import SwiftUI

struct WaveLoadingIndicator: View {
    let barCount = 6
    let barColors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange]
    
    @State private var waveOffset: Bool = false

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<barCount, id: \.self) { index in
                WaveBar(color: barColors[index % barColors.count], delay: Double(index) * 0.1)
            }
        }
        .frame(height: 30)
    }
}

struct WaveBar: View {
    let color: Color
    let delay: Double
    @State private var isAnimating = false

    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(color)
            .frame(width: 6, height: isAnimating ? 20 : 10) // Varying height for wave effect
            .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(delay), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
    }
}

struct WaveLoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        WaveLoadingIndicator()
    }
}

