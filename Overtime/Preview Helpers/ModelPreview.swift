//
//  ModelPreview.swift
//  TodoApp
//
//  Created by Karin Prater on 01.08.23.
//  Source: https://github.com/gahntpo/SwiftDataTodoApp
//

import SwiftUI
import SwiftData

struct ModelPreview<Model: PersistentModel, Content: View>: View {
    var content: (Model) -> Content
    
    init(@ViewBuilder content: @escaping (Model) -> Content) {
        self.content = content
    }
    
    var body: some View {
        PreviewContentView(content: content)
            .modelContainer(previewContainer)
    }
    
    struct PreviewContentView: View {
        var content: (Model) -> Content
        @State private var waitedToShowIssue = false
        @Query private var models: [Model]
        
        var body: some View {
            if let model = models.first {
                content(model)
            } else {
                ContentUnavailableView("Could not load model for previews" as String, systemImage: "xmark")
                    .opacity(waitedToShowIssue ? 1 : 0)
                    .onAppear {
                        Task {
                            try await Task.sleep(for: .seconds(1))
                            waitedToShowIssue = true
                        }
                    }
            }
        }
    }
}
