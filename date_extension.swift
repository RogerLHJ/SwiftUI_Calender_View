//  date_extension.swift
//  Created by Roger on 2022/1/24.

import SwiftUI

extension DateFormatter
{
    static var month: DateFormatter
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }

    static var monthAndYear: DateFormatter
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        return formatter
    }

    static var hourAndMinAndScd: DateFormatter
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter
    }
}

extension Calendar
{
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) ->[Date]
    {
        var dates: [Date] = []
        dates.append(interval.start)
        enumerateDates(startingAfter: interval.start, matching: components, matchingPolicy: .nextTime)
        {
            date, _, stop in
            if let date = date
            {
                if date < interval.end
                {
                    dates.append(date)
                }
                else
                {
                    stop = true
                }
            }
        }
        return dates
    }
}