//
//  DetailViewModel.swift
//  CryptoBit
//
//  Created by Данила Рахманов on 01.10.2024.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    private let coinDetailDataService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        coinDetailDataService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailDataService.$coinDetails
            .sink { coinDetails in
                print(coinDetails)
            }
            .store(in: &cancellables)
    }
}
