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
    var select: Int
    
    init(title1: String, number1: Int, title2: String, number2: Int, select: Int) {
        datas = [ChartData(title: title2,
                           number: Double(number2),
                           color: .blue),
                 ChartData(title: title1, 
                           number: Double(number1),
                           color: .red)]
        self.select = select
                
    }
    
    var body: some View {
        VStack {
            Chart(datas, id: \.title) { data in
                SectorMark(angle: .value("number", data.number))
                    .foregroundStyle(data.color)
            }
            .padding(40)
            
            HStack {
                VStack {
                    Text("\(rate1()) %")
                        .foregroundStyle(Color.red)
                        .font(.largeTitle)
                        
                    Text(datas[1].title)
                        .foregroundStyle(Color.red)
                        .font(.title)
                    
                    Image(systemName: select == 1 ? "star.fill":"")
                        .foregroundColor(.red)
                }
                .padding(10)
                
                VStack {
                    
                    Text("\(rate2()) %")
                        .foregroundStyle(Color.blue)
                        .font(.largeTitle)
                    Text(datas[1].title)
                        .foregroundStyle(Color.blue)
                        .font(.title)
                    
                    Image(systemName: select == 2 ? "star.fill":"")
                        .foregroundColor(.blue)
                        
                }
                .padding(10)
                
            }
        }
    }
    
    func rate1() -> String {
        let double = round(datas[1].number / (datas[0].number + datas[1].number) * 1000) / 10
        return String(String(double).prefix(4))
    }
    
    func rate2() -> String {
        let double = round(datas[1].number / (datas[0].number + datas[1].number) * 1000) / 10
        return String(String(100 - double).prefix(4))
    }
}

#Preview {
    CustomCell(title1: "umi", number1: 483, title2: "yama", number2: 736, select: 2)
}
