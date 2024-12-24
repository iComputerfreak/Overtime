// Copyright © 2024 Jonas Frey. All rights reserved.

import SwiftUI

struct VacationDayRow: View {
    let vacation: Vacation
    
    @EnvironmentObject
    private var userData: UserData
    
    var formattedDateRange: String {
        (vacation.startDate ..< vacation.endDate)
            .formatted(date: .abbreviated, time: .omitted)
    }
    
    var formattedDaysUsed: String {
        let daysUsed = vacation.daysUsed == 0 ? 0 : -vacation.daysUsed
        return daysUsed.formatted(
            .number
            .precision(.fractionLength(0...2))
        )
    }
    
    var dayColor: Color {
        if vacation.daysUsed > 0 {
            return .red
        } else if vacation.daysUsed < 0 {
            return .green
        } else {
            return .primary
        }
    }

    var body: some View {
        HStack {
            if let title = vacation.title {
                VStack(alignment: .leading) {
                    Text(title)
                        .bold()
                    Text(formattedDateRange)
                        .font(.subheadline)
                }
            } else {
                Text(formattedDateRange)
            }
            Spacer(minLength: 24)
            Text(formattedDaysUsed)
                .font(.title2)
                .bold()
                .foregroundStyle(dayColor)
        }
        .frame(minHeight: 38)
    }
}

#Preview {
    ModelPreview { (vacation: Vacation) in
        List {
            VacationDayRow(
                vacation: .init(
                    title: "Christmas",
                    startDate: .now,
                    endDate: .now.addingTimeInterval(365 * .day),
                    daysUsed: 26
                )
            )
            VacationDayRow(
                vacation: .init(
                    title: "Chilling, hanging out and gaming a bit",
                    startDate: .now,
                    endDate: .now.addingTimeInterval(3 * .day),
                    daysUsed: 2.5
                )
            )
            VacationDayRow(
                vacation: .init(
                    startDate: .now,
                    endDate: .now.addingTimeInterval(.day),
                    daysUsed: 0
                )
            )
            VacationDayRow(
                vacation: .init(
                    title: "Top up 2025",
                    startDate: DateComponents(calendar: .current, year: 2025).date!,
                    duration: 0,
                    daysUsed: -25
                )
            )
        }
    }
}
