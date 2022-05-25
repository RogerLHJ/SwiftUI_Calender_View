//  week_view.swift
//  Created by Roger on 2022/1/24.

import SwiftUI

//week
struct WeekView<DateView>: View where DateView:View
{
    @Environment(\.calendar) var calendar
    @Environment(\.colorScheme) var colorScheme
    @Binding var isDark:Bool

    let week: Date
    let content: (Date) ->DateView

    init(week: Date,
         isDark_:Binding<Bool>,
         @ViewBuilder content: @escaping (Date) ->DateView
    )
    {
        self.week = week
        self._isDark = isDark_
        self.content = content
    }

    private var days: [Date]
    {
        guard
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week)
            else {return []}
        return calendar.generateDates(inside: weekInterval, matching: DateComponents(hour: 0, minute: 0, second: 0))
    }

    var body: some View
    {
        HStack
        {
            ForEach(days, id: \.self){ date in
                HStack
                {
                    if self.calendar.isDate(self.week, equalTo: date, toGranularity: .month)
                    {
                        self.content(date)
                            .frame(width: 40, height: 40, alignment: .center)
                            .font(.system(size: 20))
                            .foregroundColor(self.calendar.isDateInToday(date) ? Color.blue :config.getShareInstance().getFontColor(.normal, self.isDark ? .dark : .light))
                    }
                    else
                    {
                        self.content(date)
                            .frame(width: 40, height: 40, alignment: .center)
                            .font(.system(size: 20, weight:  self.calendar.isDateInToday(date) ? Font.Weight.heavy : Font.Weight.light, design: .default))
                            .foregroundColor(Color.gray)
                            .disabled(true)
                    }
                }
            }
        }
    }
}