//
//  StatisticView.swift
//  CryptoBit
//
//  Created by Данила Рахманов on 30.09.2024.
//

import SwiftUI

struct StatisticView: View {
    let stat: Statistic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Colors.secondaryTextColor)
            
            Text(stat.value)
                .font(.headline)
                .foregroundColor(Colors.accentColor)
            
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption)
                    .rotationEffect(
                        Angle(degrees: (stat.percantageChange ?? 0) >= 0 ? 0 : 180))
                
                Text(stat.percantageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundColor((stat.percantageChange ?? 0) >= 0 ? Colors.greenColor : Colors.redColor)
            .opacity(stat.percantageChange == nil ? 0 : 1)
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView(stat: dev.stat1)
            .previewLayout(.sizeThatFits)
        StatisticView(stat: dev.stat2)
            .previewLayout(.sizeThatFits)
        StatisticView(stat: dev.stat3)
            .previewLayout(.sizeThatFits)
    }
}
