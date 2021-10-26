//
//  QRWidgetEntryView.swift
//  WidgetExtension
//
//  Created by Kris Luu on 10/9/21.
//

import SwiftUI
import WidgetKit

struct QRWidgetEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: QRProvider.Entry
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall: QRSmall(entry: entry)
        case .systemLarge: QRLarge(entry: entry)
        default: Text("QR Quick non-support widget")
        }
    }
}
