//
//  RotationSettingsView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/21/24.
//

import SwiftUI

struct RotationSettingsView: View {
    @ObservedObject var processor: FileProcessor
    @State private var angleText: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("Rotation Angle")
                .font(.headline)
            TextField("Angle in degrees", text: Binding(
                get: { String(Int(processor.rotationAngle)) },
                set: { processor.rotationAngle = Double($0) ?? processor.rotationAngle }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer()
        }
    }
}