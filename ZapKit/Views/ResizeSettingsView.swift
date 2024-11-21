//
//  ResizeSettingsView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/21/24.
//

import SwiftUI

struct ResizeSettingsView: View {
    @ObservedObject var processor: FileProcessor
    @State private var widthText: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("Resize Width")
                .font(.headline)
            TextField("Width in pixels", text: Binding(
                get: { String(Int(processor.resizeWidth)) },
                set: { processor.resizeWidth = Double($0) ?? processor.resizeWidth }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer()
        }
    }
}