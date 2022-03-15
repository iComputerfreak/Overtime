//
//  CalendarDayView.swift
//  Overtime
//
//  Created by Jonas Frey on 12.12.21.
//  Copyright © 2021 Jonas Frey. All rights reserved.
//

import SwiftUI

struct CalendarDayView: View {
    
    let overtime: Overtime
    
    var body: some View {
        VStack {
            HStack {
                Text("\(overtime.duration.hours)")
                    .font(.headline)
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                Text("\(Calendar.current.component(.day, from: overtime.date))")
                    .font(.headline)
                Spacer()
            }
        }
    }
}

struct CalendarDayView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarDayView(overtime: Overtime(date: Date(), duration: .zero))
            .previewLayout(.sizeThatFits)
    }
}
