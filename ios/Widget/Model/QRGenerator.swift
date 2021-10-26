//
//  QRGenerator.swift
//  WidgetExtension
//
//  Created by Kris Luu on 10/11/21.
//

import SwiftUI

func generateQRCode(from string: String) -> UIImage? {
    let data = string.data(using: String.Encoding.utf8)
    
    if let filter = CIFilter(name: "CIQRCodeGenerator") {
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        
        if let output = filter.outputImage?.transformed(by: transform) {
            let context:CIContext = CIContext.init(options: nil)
            let cgImage:CGImage = context.createCGImage(output, from: output.extent)!
            let image:UIImage = UIImage.init(cgImage: cgImage)
            return image
        }
    }
    
    return nil
}
