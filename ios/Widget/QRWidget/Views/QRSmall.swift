//
//  QRSmall.swift
//  WidgetExtension
//
//  Created by Kris Luu on 10/9/21.
//

import SwiftUI
import WidgetKit

struct QRSmall: View {
    private var entry: QRProvider.Entry
    init(entry: QRProvider.Entry) {
        self.entry = entry
    }
    
    var body: some View {
        ZStack{
            Image(
                uiImage: generateQRCode(
                    from: entry.content
                )!
            )
                .resizable()
                .padding(10)
        }
    }
}

struct QRSmall_Previews: PreviewProvider {
    static var previews: some View {
        QRWidgetEntryView(
            entry: QREntry(
                date: Date(),
                name: "previewName",
                content: "previewContent"
            )
        ).previewContext(
            WidgetPreviewContext(family: .systemSmall)
        )
    }
}
