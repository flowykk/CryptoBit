//
//  StringExtension.swift
//  CryptoBit
//
//  Created by Данила Рахманов on 02.10.2024.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
