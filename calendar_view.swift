//  calender_view.swift
//  Created by Roger on 2022/1/24.

import SwiftUI

struct CalenderView<DateView>: View where DateView:View
{
    @Environment(\.calendar) var calendar
    //attribute
    @Binding var selectDate:Date
    @Binding var isMoved:Bool
    @Binding var isDark:Bool

    @State var isAdvanced:Bool = false
    @State var isHorizontal:Bool = false
    @State var angleX: Double = 0
    @State var angleY: Double = 0

    //function
    let content: (Date) -> DateView

    init(
        selection_:Binding<Date>,
        isMoved_: Binding<Bool>,
        isDark_:Binding<Bool>,
        @ViewBuilder content: @escaping (Date) -> DateView
    )
    {
        self._selectDate = selection_
        self._isMoved = isMoved_
        self._isDark = isDark_
        self.content = content
    }

    func turnCalender(_ isAdvance : Bool = true, _ isHor : Bool = true)
    {
        var incValue:Int = 1
        if isAdvance == false
        {
            incValue = -1
        }

        let todayComponrnts = self.calendar.dateComponents([Calendar.Component.day, Calendar.Component.year, Calendar.Component.month], from: self.selectDate)
        var nextMonth:Int = todayComponrnts.month ?? 1
        var currentYear:Int = todayComponrnts.year ?? 2021

        if (isHor)
        {
            nextMonth += incValue
            if nextMonth == 0
            {
                nextMonth = 12
                currentYear += -1
            }
            if nextMonth > 12
            {
                nextMonth = 1
                currentYear += 1
            }
        }
        else
        {
            currentYear += incValue
        }

        var componrnts = DateComponents()
        componrnts.year = currentYear
        componrnts.month = nextMonth
        componrnts.day = 1
        self.selectDate = self.calendar.date(from: componrnts) ?? Date()
    }

    func calDirection(_ offsetSize: CGSize)
    {
        var offset:CGFloat = offsetSize.width
        self.isHorizontal = true

        if (abs(offsetSize.width) < abs(offsetSize.height))
        {
            offset = offsetSize.height
            self.isHorizontal = false
        }

        self.isAdvanced = false
        self.isMoved = false

        if (offset < 0) {
            self.isAdvanced = true
        }

        if(abs(offset) > 15)
        {
            self.isMoved = true
        }
    }

    func playTrunsAnim(_ mode: Int = 1, _ animTimes: Int = 1, _ isAdvance: Bool = false)
    {
        var incAngle:Double = 360

        if (isAdvance)
        {
            incAngle = -360
        }

        if (mode == 1)
        {
            self.angleY += (incAngle * Double(animTimes))
        }
        else if (mode == 2)
        {
            self.angleX -= (incAngle * Double(animTimes))
        }
        else if(mode == 3)
        {
            self.angleY = 0
            self.angleX = 0
        }
    }

    var body: some View
    {
        let tad = DragGesture()
            .onChanged { value in
                calDirection(value.translation)
            }.onEnded { _ in

                if (self.isMoved)
                {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.02) {
                        turnCalender(self.isAdvanced, self.isHorizontal)
                    }

                    var mode:Int = 2

                    if (self.isHorizontal)
                    {
                        mode = 1
                    }
                    playTrunsAnim(mode, 1, self.isAdvanced)
                    self.isMoved = false
                }
            }

            VStack
            {
                Spacer(minLength: 50)
                MonthView(isDark_: self.$isDark, selection: self.$selectDate, content: self.content)
                    .frame(width: 400, height: 400, alignment: .center)
                    .background(Color.init(.sRGB, white: 0, opacity: 0))
                    .padding()
                    .gesture(tad)
                    .rotation3DEffect(.degrees(angleY), axis: (x: 0, y: 1, z: 0))
                    .rotation3DEffect(.degrees(angleX), axis: (x: 1, y: 0, z: 0))
                    .animation(.interpolatingSpring(stiffness: 200, damping: 20).speed(1.2), value: [self.angleX, self.angleY])
                
                Spacer(minLength: 20)
                Spacer(minLength: 110)
            }
            .onTapGesture(count: 2)
        {
            self.selectDate = Date()
            playTrunsAnim(3, 1, false)
        }
    }
}