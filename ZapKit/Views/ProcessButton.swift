//
//  ProcessButton.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/20/24.
//

import SwiftUI

struct ProcessButton: View {
    @ObservedObject var processor: FileProcessor

    var body: some View {
        Button(action: {
            Task {
                await processor.processFiles()
            }
        }) {
            Text("Process")
                .frame(maxWidth: .infinity)
        }
        .disabled(processor.selectedAction == nil || processor.files.isEmpty)
        .padding()
    }
}