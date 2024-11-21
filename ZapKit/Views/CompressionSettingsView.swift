//
//  CompressionSettingsView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/21/24.
//

import SwiftUI

struct CompressionSettingsView: View {
    @ObservedObject var processor: FileProcessor

    var body: some View {
        VStack(alignment: .leading) {
            Text("Compression Quality")
                .font(.headline)
            Slider(value: $processor.compressionQuality, in: 0...1, step: 0.05)
            Text("Quality: \(Int(processor.compressionQuality * 100))%")
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}