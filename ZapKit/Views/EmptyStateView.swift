//
//  EmptyStateView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/20/24.
//

import SwiftUI

struct EmptyStateView: View {
    @State private var isDragging = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "arrow.down.doc")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            Text("Drag and Drop Files Here")
                .font(.title2)
            Text("or")
                .foregroundColor(.secondary)
            Button("Choose Files") {
                showFilePicker()
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isDragging ? Color.accentColor : Color.secondary.opacity(0.2),
                       style: StrokeStyle(lineWidth: 2, dash: [10]))
                .padding()
        )
    }
    
    private func showFilePicker() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.image]
        panel.runModal()
    }
}
