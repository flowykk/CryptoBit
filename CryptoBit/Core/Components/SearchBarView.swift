//
//  SearchBarView.swift
//  CryptoBit
//
//  Created by Данила Рахманов on 30.09.2024.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ?
                    Colors.secondaryTextColor :
                    Colors.accentColor
                )
            
            TextField("Search by name or symbol...", text: $searchText)
                .foregroundColor(Colors.accentColor)
                .disableAutocorrection(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(Colors.accentColor)
                        .opacity(searchText.isEmpty ? 0 : 1)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            HapticManager.shared.impact(style: .medium)
                            searchText.removeAll()
                        }
                    ,alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Colors.backgroundColor)
                .shadow(
                    color: Colors.accentColor.opacity(0.3),
                    radius: 10, x: 0, y: 0)
        )
        .padding()
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
