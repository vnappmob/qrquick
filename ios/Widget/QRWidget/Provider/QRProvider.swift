//
//  QRProvider.swift
//  WidgetExtension
//
//  Created by Kris Luu on 10/9/21.
//

import Foundation
import WidgetKit
import SwiftUI

private let previewName = "QR Quick"
private let previewContent = "UG93ZXJlZF9ieV9WTkFQUE1PQg=="
private let groupId = "group.com.vnappmob.qrquick"

struct QRProvider: TimelineProvider {
    func placeholder(in context: Context) -> QREntry {
        
        return QREntry(
            date: Date(),
            name: previewName,
            content: previewContent
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (QREntry) -> ()) {
        var widgetName = ""
        var widgetContent = ""
        if let userDefaults = UserDefaults(suiteName: groupId) {
            widgetName = userDefaults.string(forKey: "widgetName") ?? previewName
            widgetContent = userDefaults.string(forKey: "widgetContent") ?? previewContent
        }
        
        let entry = QREntry(
            date: Date(),
            name: widgetName,
            content: widgetContent
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<QREntry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}
