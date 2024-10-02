//
//  XMarkButton.swift
//  CryptoBit
//
//  Created by Данила Рахманов on 01.10.2024.
//

import SwiftUI

struct XMarkButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark")
                .font(.callout)
                .foregroundColor(Colors.secondaryTextColor)
        }
    }
}

#Preview {
    XMarkButton()
}
