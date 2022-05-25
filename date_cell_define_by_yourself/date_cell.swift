//  date_cell.swift
//  Created by Roger on 2022/1/24.

import Foundation
import SwiftUI

struct DateButton:View
{
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.calendar) var calendar
    @EnvironmentObject var tagDate:TagData

    @State var showEditPage:Bool = false

    @Binding var isMoved:Bool
    @Binding var isDark:Bool

    var date:Date

    init(date_:Date,
         isMoved_:Binding<Bool>,
         isDark_:Binding<Bool>)
    {
        self.date = date_
        self._isMoved = isMoved_
        self._isDark = isDark_
    }
    
    func getTapGesture()->some Gesture
    {
        var tapGesture: some Gesture
        {
            TapGesture(count: 1)
                .onEnded
            {
                if (!self.isMoved)
                {
                    self.showEditPage = true
                }
            }
        }
        return tapGesture
    }

    var body: some View
    {
        Rectangle()
            .fill(config.getShareInstance().getFontColor(.normal, self.isDark ? .light : .dark))
            .frame(width: 40, height: 40, alignment: .center)
            .gesture(self.getTapGesture())
            .overlay(
                ZStack
                {
                    Text(String(self.calendar.component(.day, from: self.date)))
                        .frame(width: 40, height: 40, alignment: .center)

                    Image(systemName: "scribble.variable")
                        .frame(width: 1, height: 1, alignment: .init(horizontal: .leading, vertical: .top))
                        .foregroundColor(config.getShareInstance().getTagColor(self.isDark ? .dark : .light))
                        .scaleEffect(0.5)
                        .opacity(self.tagDate.getTagByDate(self.date, self.isDark ? .Survive : .Life) ? 0.5 : 0)
                        .offset(x: 8, y: -4.5)
                }
            )
            .sheet(isPresented: self.$showEditPage, onDismiss:
            {
                self.showEditPage = false
            }, content: {
                EditPage(self.date, self.$isDark, self.$showEditPage)
                    .environmentObject(self.tagDate)
            })
    }
}

