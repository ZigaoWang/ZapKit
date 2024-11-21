//
//  DetailView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/21/24.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var processor: FileProcessor

    var body: some View {
        VStack {
            if let selectedAction = processor.selectedAction {
                switch selectedAction {
                case .compressImage:
                    CompressionSettingsView(processor: processor)
                case .resizeImage:
                    ResizeSettingsView(processor: processor)
                case .adjustBrightness:
                    BrightnessSettingsView(processor: processor)
                case .rotateImage:
                    RotationSettingsView(processor: processor)
                case .applyFilter:
                    FilterSettingsView(processor: processor)
                default:
                    Text("No additional settings for this action.")
                        .foregroundColor(.secondary)
                }
            } else {
                Text("Select an action to view settings.")
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
    }
}