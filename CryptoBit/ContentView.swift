//
//  ContentView.swift
//  CryptoBit
//
//  Created by Данила Рахманов on 28.09.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Colors.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("Accent Color")
                    .foregroundColor(Colors.accentColor)
                
                Text("Secondary Text Color")
                    .foregroundColor(Colors.secondaryTextColor)
                
                Text("Red Color")
                    .foregroundColor(Colors.redColor)
                
                Text("Green Color")
                    .foregroundColor(Colors.greenColor)
            }
            .font(.headline)
        }
    }
}

#Preview {
    ContentView()
}
