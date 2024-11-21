//
//  BrightnessSettingsView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/21/24.
//

import SwiftUI

struct BrightnessSettingsView: View {
    @ObservedObject var processor: FileProcessor

    var body: some View {
        VStack(alignment: .leading) {
            Text("Adjust Brightness")
                .font(.headline)
            Slider(value: $processor.brightnessAmount, in: -1...1, step: 0.1)
            Text("Brightness: \(String(format: "%.1f", processor.brightnessAmount))")
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}