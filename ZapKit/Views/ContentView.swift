//
//  ContentView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/20/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var processor = FileProcessor()
    @State private var showSettings = false

    var body: some View {
        NavigationView {
            SidebarView(processor: processor)
            FileListView(processor: processor)
            DetailView(processor: processor)
        }
        .frame(minWidth: 800, minHeight: 600)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    processor.showFileImporter = true
                }) {
                    Label("Add Files", systemImage: "plus")
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    processor.processFiles()
                }) {
                    Text("Process")
                }
                .disabled(processor.selectedAction == nil || processor.files.isEmpty)
            }
            ToolbarItem(placement: .status) {
                if processor.isProcessing {
                    ProgressView()
                }
            }
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    showSettings = true
                }) {
                    Label("Settings", systemImage: "gear")
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView(processor: processor)
                }
            }
        }
        .environmentObject(processor)
    }
}