//
//  SwiftUIView.swift
//  CryptoBit
//
//  Created by Данила Рахманов on 28.09.2024.
//

import SwiftUI

struct CircleButtonView: View {
    
    let icon: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.headline)
            .fontWeight(.black)
            .foregroundColor(Colors.accentColor)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundColor(Colors.backgroundColor)
            )
            .shadow(
                color: Colors.accentColor.opacity(0.25),
                radius: 10, x: 0, y: 0)
            .padding()
    }
}

#Preview(traits: .fixedLayout(width: 100, height: 100)) {
    Group {
        CircleButtonView(icon: "info")
            .padding()
        
        CircleButtonView(icon: "chevron.right")
            .padding()
            .colorScheme(.dark)
    }
    
}
