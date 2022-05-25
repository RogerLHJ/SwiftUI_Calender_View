//  month_view.swift
//  Created by Roger on 2022/1/24.

import SwiftUI

//month
struct MonthView<DateView>: View where DateView: View
{
    @Environment(\.calendar) var calendar
    @Binding var isDark: Bool

    let selectDate: Date
    let content:(Date) -> DateView
    private let weekTitle: [String] = ["日", "一", "二", "三", "四", "五", "六"]

    init(
        isDark_:Binding<Bool>,
        selection: Binding<Date>,
        @ViewBuilder content: @escaping (Date) ->DateView
    )
    {
        self._isDark = isDark_
        self.selectDate = selection.wrappedValue
        self.content = content
    }

    private var header: some View
    {
        let formatter = DateFormatter.monthAndYear
        return Text(formatter.string(from: selectDate))
            .font(.title)
            .foregroundColor(config.getShareInstance().getFontColor(.normal, self.isDark ? .dark : .light))
            .padding()
    }

    private var weekHeader: some View
    {
        return HStack
        {
            ForEach(weekTitle, id:\.self)
            {title in
                Text(title)
                    .frame(width: 38, height: 20, alignment: .center)
                    .foregroundColor(config.getShareInstance().getFontColor(.normal, self.isDark ? .dark : .light))
                    .padding(1)
            }
        }
    }

    private var weeks: [Date]
    {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: selectDate)
        else{ return[] }
        return calendar.generateDates(inside: monthInterval, matching: DateComponents(hour:0, minute: 0, second: 0, weekday: 1))
    }

    var body: some View
    {
        VStack
        {
            header
            weekHeader
            ForEach(weeks, id:\.self){week in
                WeekView(week: week, isDark_: self.$isDark, content: self.content)
            }
            Spacer()
        }
    }
}