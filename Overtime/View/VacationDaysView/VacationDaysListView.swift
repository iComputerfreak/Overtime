// Copyright © 2024 Jonas Frey. All rights reserved.

import SwiftData
import SwiftUI

struct VacationDaysListView: View {
    @Query(sort: \Vacation.startDate, order: .reverse)
    private var vacations: [Vacation]
    
    let onEdit: (Vacation) -> Void
    
    @Environment(\.modelContext) private var context
    
    var groupedVacations: [Int: [Vacation]] {
        Dictionary(grouping: vacations) { vacation in
            vacation.startDate[.year]
        }
    }
    
    var years: [Int] {
        groupedVacations.keys
            .sorted(by: >)
    }

    var body: some View {
        List {
            ForEach(years, id: \.self) { year in
                Section {
                    ForEach(groupedVacations[year] ?? []) { vacation in
                        VacationDayRow(vacation: vacation)
                            .deleteDisabled(false)
                            .swipeActions(allowsFullSwipe: true) {
                                Button {
                                    context.delete(vacation)
                                } label: {
                                    Label("actionLabel.delete", systemImage: "trash")
                                }
                                .tint(.red)
                                Button {
                                    onEdit(vacation)
                                } label: {
                                    Label("actionLabel.edit", systemImage: "pencil")
                                }
                            }
                    }
                } header: {
                    Text(verbatim: "\(year.description)")
                }
            }
        }
    }
}

#Preview {
    ModelPreview { (_: Vacation) in
        VacationDaysListView(onEdit: { _ in })
    }
}
