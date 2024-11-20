//
//  FileItem.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/20/24.
//

import SwiftUI

struct FileItem: Identifiable, Hashable, Equatable {
    let id = UUID()
    let url: URL
    var processedURL: URL?
    var status: ProcessingStatus = .pending
    
    enum ProcessingStatus: Equatable {
        case pending
        case processing
        case completed
        case error(String)
        
        static func == (lhs: ProcessingStatus, rhs: ProcessingStatus) -> Bool {
            switch (lhs, rhs) {
            case (.pending, .pending): return true
            case (.processing, .processing): return true
            case (.completed, .completed): return true
            case (.error(let lhsError), .error(let rhsError)): return lhsError == rhsError
            default: return false
            }
        }
    }
    
    static func == (lhs: FileItem, rhs: FileItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
