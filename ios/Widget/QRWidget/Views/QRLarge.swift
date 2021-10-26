//
//  QRLarge.swift
//  WidgetExtension
//
//  Created by Kris Luu on 10/12/21.
//

import SwiftUI
import WidgetKit

struct QRLarge: View {
    private var entry: QRProvider.Entry
    init(entry: QRProvider.Entry) {
        self.entry = entry
    }
    
    var body: some View {
        VStack{
            Image(
                uiImage: generateQRCode(
                    from: entry.content
                )!
            )
                .resizable()
                .padding(
                    EdgeInsets(
                        top: 10,
                        leading: 10,
                        bottom: 0,
                        trailing: 10
                    )
                )
            Text(entry.name)
        }
    }
}

struct QRLarge_Previews: PreviewProvider {
    static var previews: some View {
        QRWidgetEntryView(
            entry: QREntry(
                date: Date(),
                name: "previewName",
                content: "previewContent"
            )
        ).previewContext(
            WidgetPreviewContext(family: .systemLarge)
        )
    }
}
