import SwiftUI

struct TestCalender:View
{
   @State var selectDate:Date = Date()
   @State var isMoved:Bool = false
   @State var isDark:Bool = false
   @Environment(\.calendar) var calendar

   func createCalender()->some View
   {
       let cv = CalenderView(selection_: self.$selectDate, isMoved_: self.$isMoved, isDark_: self.$isDark, content: { date in
           DateButton(date_:String(self.calendar.component(.day, from: date)), isMoved_: self.$isMoved, isDark_: self.$isDark)
           })
        return cv
    }

   var body: some View
   {
       VStack
       {
           //Spacer(minLength: 80)
           HStack
           {
               createCalender()
                   .frame(width: 100, height: 200, alignment: .top)
           }
           Spacer()
       }
   }
}

struct testContentView:View
{
   var body: some View
   {
       TestCalender(selectDate: Date(), isMoved: false)
   }
}

struct CalenderView_Previews: PreviewProvider {
   static var previews: some View {
       testContentView()
   }
}