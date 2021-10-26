//
//  QRWidget.swift
//  WidgetExtension
//
//  Created by Kris Luu on 10/9/21.
//

import WidgetKit
import SwiftUI

private let widgetKind = "com.vnappmob.qrquick.kind1"

struct QRWidget: Widget {
    let kind: String = widgetKind
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: QRProvider()
        ) { entry in
            QRWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .configurationDisplayName("QR Quick Widget")
        .description("Powered by VNAppMob")
        .supportedFamilies([.systemSmall, .systemLarge])
    }
}

struct QRWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            QRWidgetEntryView(
                entry: QREntry(
                    date: Date(),
                    name: "previewName",
                    content: "previewContent"
                )
            ).previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
