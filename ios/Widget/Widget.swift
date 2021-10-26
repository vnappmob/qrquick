//
//  Widget.swift
//  Widget
//
//  Created by Kris Luu on 10/9/21.
//

import WidgetKit
import SwiftUI

@main
struct AppWidgetBundle: WidgetBundle{
    @WidgetBundleBuilder
    var body: some Widget {
        QRWidget()
    }
}
