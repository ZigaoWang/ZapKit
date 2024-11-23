//
//  ProcessingView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/23/24.
//

import SwiftUI

struct ProcessingView: View {
    let url: URL
    let action: FileAction
    @Binding var processedURL: URL?
    @Binding var isPresented: Bool
    @State private var progress = 0.0
    @State private var error: Error?
    
    var body: some View {
        VStack(spacing: 20) {
            if let error = error {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 48))
                        .foregroundColor(.red)
                    Text("Processing Error")
                        .font(.headline)
                    Text(error.localizedDescription)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                    Button("Close") {
                        isPresented = false
                    }
                    .padding(.top)
                }
            } else if processedURL != nil {
                VStack {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 48))
                        .foregroundColor(.green)
                    Text("Processing Complete")
                        .font(.headline)
                    HStack {
                        Button("Show in Finder") {
                            NSWorkspace.shared.activateFileViewerSelecting([processedURL!])
                            isPresented = false
                        }
                        Button("Close") {
                            isPresented = false
                        }
                    }
                    .padding(.top)
                }
            } else {
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                    Text("Processing \(action.name)")
                        .font(.headline)
                    Text("Please wait...")
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(width: 300)
        .padding()
        .onAppear {
            startProcessing()
        }
    }
    
    private func startProcessing() {
        Task {
            do {
                processedURL = try await action.processor(url)
            } catch {
                self.error = error
            }
        }
    }
}
