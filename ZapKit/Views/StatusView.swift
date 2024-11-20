//
//  StatusView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/20/24.
//

import SwiftUI

struct StatusView: View {
    let status: FileItem.ProcessingStatus
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(iconColor)
            Text(statusText)
                .foregroundColor(iconColor)
                .font(.caption)
        }
    }
    
    private var iconName: String {
        switch status {
        case .pending:
            return "clock"
        case .processing:
            return "arrow.triangle.2.circlepath"
        case .completed:
            return "checkmark.circle"
        case .error:
            return "exclamationmark.triangle"
        }
    }
    
    private var iconColor: Color {
        switch status {
        case .pending:
            return .secondary
        case .processing:
            return .blue
        case .completed:
            return .green
        case .error:
            return .red
        }
    }
    
    private var statusText: String {
        switch status {
        case .pending:
            return "Pending"
        case .processing:
            return "Processing"
        case .completed:
            return "Completed"
        case .error(let message):
            return "Error: \(message)"
        }
    }
}
