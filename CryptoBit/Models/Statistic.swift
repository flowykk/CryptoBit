//
//  Statistic.swift
//  CryptoBit
//
//  Created by Данила Рахманов on 30.09.2024.
//

import Foundation

struct Statistic: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percantageChange: Double?
    
    init(title: String, value: String, percantageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percantageChange = percantageChange
    }    
}
