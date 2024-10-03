//
//  CoinDetailDataService.swift
//  CryptoBit
//
//  Created by Данила Рахманов on 01.10.2024.
//

import Foundation
import Combine

final class CoinDetailDataService {
    @Published var coinDetails: CoinDetail? = nil
    
    var coinDetailSubscription: AnyCancellable?
    let coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
        getCoinDetails()
    }
    
    func getCoinDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {
            return
        }
        
        coinDetailSubscription = NetworkManager.download(url: url)
            .decode(type: CoinDetail.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] coinDetails in
                self?.coinDetails = coinDetails
                self?.coinDetailSubscription?.cancel()
            })
    }
}
