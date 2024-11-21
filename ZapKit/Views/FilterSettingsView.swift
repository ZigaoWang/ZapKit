//
//  FilterSettingsView.swift
//  ZapKit
//
//  Created by Zigao Wang on 11/21/24.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct FilterSettingsView: View {
    @ObservedObject var processor: FileProcessor

    let filters = FilterType.allCases

    var body: some View {
        VStack(alignment: .leading) {
            Text("Select Filter")
                .font(.headline)
            Picker("Filter", selection: $processor.selectedFilterType) {
                ForEach(filters) { filter in
                    Text(filter.displayName).tag(filter)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            Spacer()
        }
    }
}

enum FilterType: String, CaseIterable, Identifiable {
    case sepia
    case blur
    case pixellate
    case invert

    var id: String { self.rawValue }

    var displayName: String {
        switch self {
        case .sepia:
            return "Sepia"
        case .blur:
            return "Blur"
        case .pixellate:
            return "Pixellate"
        case .invert:
            return "Invert"
        }
    }

    var filter: CIFilter {
        switch self {
        case .sepia:
            return CIFilter.sepiaTone()
        case .blur:
            return CIFilter.gaussianBlur()
        case .pixellate:
            return CIFilter.pixellate()
        case .invert:
            return CIFilter.colorInvert()
        }
    }
}
