//
//  CustomCell.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/22.
//

import SwiftUI
import Charts

struct CustomCell: View {
    
    @State private var datas: [ChartData]
    
    init(title1: String, number1: Int, title2: String, number2: Int) {
        datas = [ChartData(title: title2, number: number2, color: .blue),
                 ChartData(title: title1, number: number1, color: .red)]
    }
    
    var body: some View {
        Chart(datas, id: \.title) { data in
            SectorMark(angle: .value("number", data.number))
                .foregroundStyle(data.color)
        }
    }
}

#Preview {
    CustomCell(title1: "umi", number1: 483, title2: "yama", number2: 736)
}
