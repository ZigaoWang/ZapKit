//
//  SettingsView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/21/24.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var processor: FileProcessor

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("General")) {
                    Toggle("Convert to Grayscale", isOn: $processor.isGrayscale)
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 300)
            .navigationTitle("Settings")
        }
    }
}