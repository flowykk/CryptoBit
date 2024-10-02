//
//  CoinDataService.swift
//  CryptoBit
//
//  Created by Данила Рахманов on 29.09.2024.
//

import Foundation
import Combine

final class CoinDataService {
    @Published var allCoins = [Coin]()
    
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets") else { return }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "vs_currency", value: "usd"),
            URLQueryItem(name: "order", value: "market_cap_desc"),
            URLQueryItem(name: "per_page", value: "250"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "sparkline", value: "true"),
            URLQueryItem(name: "price_change_percentage", value: "24h"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        guard components.url != nil else { return }
        coinSubscription = NetworkManager.download(url: components.url!)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompetion, receiveValue: { [weak self] allCoins in
                self?.allCoins = allCoins
                self?.coinSubscription?.cancel()
            })

    }
}
