//
//  CGImage.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/6/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


extension UIImage {

    /**
     Creates a UIImage from the image data.
     - Parameter image: The image data used to generate the UIImage.
     */
    convenience init?(_ image: Image) {
        let width = image.width
        let height = image.height
        let area = width * height
        let componentsPerPixel = 4

        let imagePixelData = image.pixelData
        var cgPixelData = Array<UInt8>(repeating: 0, count: area * componentsPerPixel)

        for (index, pixel) in imagePixelData.enumerated() {
            let offset = index * componentsPerPixel
            cgPixelData[offset] = pixel.red
            cgPixelData[offset + 1] = pixel.green
            cgPixelData[offset + 2] = pixel.blue
            cgPixelData[offset + 3] = pixel.alpha
        }

        let bitsPerComponent = 8
        let bytesPerRow = ((bitsPerComponent * width) / 8) * componentsPerPixel
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(
            data: &cgPixelData[0],
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: UInt32(bitmapInfo.rawValue)
        )

        guard let cgImage = context?.makeImage() else { return nil }
        self.init(cgImage: cgImage)
    }
}
