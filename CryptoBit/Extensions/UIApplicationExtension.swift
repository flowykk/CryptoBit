//
//  UIApplicationExtension.swift
//  CryptoBit
//
//  Created by Данила Рахманов on 30.09.2024.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector (UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
