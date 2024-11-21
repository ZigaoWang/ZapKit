//
//  FileItem.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/20/24.
//

import Foundation

struct FileItem: Identifiable, Hashable {
    let id = UUID()
    let url: URL
    var status: ProcessingStatus = .pending
    var processedURL: URL?

    enum ProcessingStatus: Hashable {
        case pending
        case processing
        case completed
        case error(String)
    }
}