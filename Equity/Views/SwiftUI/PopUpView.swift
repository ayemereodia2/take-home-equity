//
//  PopUpView.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import SwiftUI

struct PopupView: View {
    let message: String
    @Binding var isVisible: Bool
    let messageType: MessageType
  
    var body: some View {
        VStack {
            Spacer()
            if isVisible {
                Text(message)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(messageType == .error ? Color.red : Color.mint)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.3), value: isVisible)
            }
          Spacer()
            .frame(height: 80)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    isVisible = false
                }
            }
        }
    }
}


#Preview {
  PopupView(message: "BTC has been added to your favorite", isVisible: .constant(true), messageType: .error)
}
