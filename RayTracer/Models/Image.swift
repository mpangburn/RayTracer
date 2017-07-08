//
//  Image.swift
//  RayTracer
//
//  Created by Michael Pangburn on 6/26/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import Foundation


/// The data for an image.
public struct Image {

    /// The pixel data for the image.
    public var pixelData: [Color.PixelData]

    /// The width of the image.
    public var width: Int

    /// The height of the image.
    public var height: Int
}


// MARK: - Image conversion
extension Image {

    public enum Format {
        case ppm
    }

    /**
     Writes the image data to a file of the specified format in Documents.
     - Parameters:
        - format: The image format to save to.
        - fileName: The name of the file to write to (excluding the extension).
     - Returns: A boolean representing whether or not the image was saved successfully.
     */
    @discardableResult public func write(to format: Image.Format, named fileName: String) -> Bool {
        switch format {
        case .ppm:
            return writeToPPM(named: fileName)
        }
    }


    /// Writes the image data to the file in PPM format.
    private func writeToPPM(named fileName: String) -> Bool {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
        let path = documentsDirectory.appendingPathComponent("\(fileName).ppm")
        var fileContents = "P3\n\(self.width) \(self.height)\n255\n"
        for pixel in self.pixelData {
            fileContents += "\(pixel.red)\n\(pixel.green)\n\(pixel.blue)\n"
        }

        do {
            try fileContents.write(to: path, atomically: false, encoding: .utf8)
            return true
        }
        catch {
            print("Error writing the PPM file.")
            return false
        }
    }

}


extension Image: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "Image(pixelData: \(self.pixelData), width: \(self.width), height: \(self.height))"
    }

    public var debugDescription: String {
        return self.description
    }
}
