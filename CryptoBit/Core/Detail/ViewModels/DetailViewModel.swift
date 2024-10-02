//
//  DetailViewModel.swift
//  CryptoBit
//
//  Created by Данила Рахманов on 01.10.2024.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    @Published var overviewStatistics = [Statistic]()
    @Published var additionalStatistics = [Statistic]()
    @Published var coin: Coin
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    private let coinDetailDataService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coin = coin
        coinDetailDataService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailDataService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] arrays in
                guard let self else { return }
                self.overviewStatistics = arrays.overview
                self.additionalStatistics = arrays.additional
            }
            .store(in: &cancellables)
        
        coinDetailDataService.$coinDetails
            .sink { [weak self] coinDetail in
                self?.coinDescription = coinDetail?.readableDescription
                self?.websiteURL = coinDetail?.links?.homepage?.first
                self?.redditURL = coinDetail?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistics(coinDetail: CoinDetail?, coin: Coin) -> (overview: [Statistic], additional: [Statistic]) {
        return (getOverviewStats(coin: coin), getAdditionalStats(coinDetail: coinDetail, coin: coin))
    }
    
    private func getOverviewStats(coin: Coin) -> [Statistic] {
        let price = coin.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coin.priceChangePercentage24H
        let priceStat = Statistic(title: "Current Price", value: price, percantageChange: pricePercentChange)
        
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapStat = Statistic(title: "Market Capitalization", value: marketCap, percantageChange: marketCapPercentChange)
        
        let rank = "\(coin.rank)"
        let rankStat = Statistic(title: "Rank", value: rank)
        
        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = Statistic(title: "Total Volume", value: volume)
        
        return [priceStat, marketCapStat, rankStat, volumeStat]
    }
    
    private func getAdditionalStats(coinDetail: CoinDetail?, coin: Coin) -> [Statistic] {
        let high = coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = Statistic(title: "24H High", value: high)
        
        let low = coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = Statistic(title: "24H Low", value: low)
        
        let priceChange = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange = coin.priceChangePercentage24H
        let priceChangeStat = Statistic(title: "24H Price Change", value: priceChange, percantageChange: pricePercentChange)
        
        let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapChangeStat = Statistic(title: "24H Market Cap Change", value: marketCapChange, percantageChange: marketCapPercentChange)
        
        let blockTime = coinDetail?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime) min."
        let blockTimeStat = Statistic(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetail?.hashingAlgorithm ?? "n/a"
        let hashingStat = Statistic(title: "Hashing Algorithm", value: hashing)
        
        return [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockTimeStat, hashingStat]
    }
}
