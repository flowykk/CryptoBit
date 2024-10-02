//
//  HomeViewModel.swift
//  CryptoBit
//
//  Created by Данила Рахманов on 29.09.2024.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    @Published var statistics = [Statistic]()
    @Published var allCoins = [Coin]()
    @Published var portfolioCoins = [Coin]()
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .holdings
    
    private let marketDataService = MarketDataService()
    private let coinDataService = CoinDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] coins in
                self?.allCoins = coins
            }
            .store(in: &cancellables)
        
        $allCoins
           .combineLatest(portfolioDataService.$savedEntities)
           .map(mapToPortfolioCoins)
           .sink { [weak self] coins in
               guard let self else { return }
               self.portfolioCoins = self.sortPortfolioCoins(coins: coins)
           }
           .store(in: &cancellables)
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalData)
            .sink { [weak self] statistics in
                self?.statistics = statistics
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.shared.notification(type: .success)
    }
    
    private func sortCoins(sort: SortOption, coins: inout [Coin]) {
        switch sort {
        case .rank, .holdings:                  coins.sort { $0.rank < $1.rank }
        case .rankReversed, .holdingsReversed:  coins.sort { $0.rank > $1.rank }
        case .price:                            coins.sort { $0.currentPrice < $1.currentPrice }
        case .priceReversed:                    coins.sort { $0.currentPrice > $1.currentPrice }
        }
    }
    
    private func sortPortfolioCoins(coins: [Coin]) -> [Coin] {
        switch sortOption {
        case .holdings:         return coins.sorted { $0.currentHoldingsValue < $1.currentHoldingsValue }
        case .holdingsReversed: return coins.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }
        default:                return coins
        }
    }
    
    private func mapToPortfolioCoins(allCoins: [Coin], portfolioEntities: [Portfolio]) -> [Coin] {
        allCoins.compactMap { coin -> Coin? in
            guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else { return nil }
            
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    private func mapGlobalData(data: MarketData?, portfolioCoins: [Coin]) -> [Statistic] {
        var statistics = [Statistic]()
        
        guard let data = data else { return statistics }
        
        let portfolioValue = portfolioCoins.map({ $0.currentHoldingsValue }).reduce(0, +)
        
        let previousValue = portfolioCoins.map { coin -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = coin.priceChangePercentage24H
            let previousValue = currentValue / ( 1 + percentChange)
            
            return previousValue
        }.reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        statistics.append(contentsOf: [
            Statistic(title: "Market Cap", value: data.marketCap, percantageChange: data.marketCapChangePercentage24HUsd),
            Statistic(title: "24h Volume", value: data.volume),
            Statistic(title: "BTC Dominance", value: data.btcDominance),
            Statistic(title: "Portfolio", value: portfolioValue.asCurrencyWith2Decimals(), percantageChange: percentageChange)
        ])
        
        return statistics
    }
    
    private func filterAndSortCoins(text: String, coins: [Coin], sort: SortOption) -> [Coin] {
        var filteredCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins:  &filteredCoins)
        
        return filteredCoins
    }
    
    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else { return coins }
        
        let lowercasedText = text.lowercased()
        return coins.filter { coin -> Bool in
            coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
}
