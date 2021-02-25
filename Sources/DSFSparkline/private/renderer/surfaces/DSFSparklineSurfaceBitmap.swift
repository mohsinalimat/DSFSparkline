//
//  DSFSparklineSurfaceBitmap.swift
//  DSFSparklines
//
//  Created by Darren Ford on 26/2/21.
//  Copyright © 2021 Darren Ford. All rights reserved.
//
//  MIT license
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
//  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import CoreGraphics
import Foundation

/// A surface for drawing a sparkline into an image
@objc public class DSFSparklineSurfaceBitmap: NSObject {

	/// Add a sparkline overlay to the surface
	@objc public func addOverlay(_ overlay: DSFSparklineOverlay) {
		self.overlays.append(overlay)
	}

	/// Return a CGImage representation of the sparklline
	/// - Parameters:
	///   - size: The dimension in pixels
	///   - scale: The scale to use (eg. retina == 2)
	/// - Returns: A CGImage representation, or nil if the image couldn't be generated
	@objc public func cgImage(size: CGSize, scale: CGFloat = 2) -> CGImage? {
		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

		// Create the bitmap context to draw into
		guard let bitmapContext = self.generateBitmapContext(rect: rect, scale: scale) else {
			return nil
		}

		var bounds: CGRect = rect

		// Loop through each overlay and ask it to draw
		self.overlays.forEach { overlay in
			bitmapContext.usingGState { ctx in
				bounds = overlay.drawGraph(context: ctx, bounds: bounds, scale: scale)
			}
		}

		return bitmapContext.makeImage()
	}

	// MARK: Private

	// The overlays to use when generating the image
	private var overlays: [DSFSparklineOverlay] = []
}

// MARK: - AppKit Additions

#if os(macOS)

import AppKit
public extension DSFSparklineSurfaceBitmap {
	/// Generate an NSImage for the contents of the surface
	@objc func image(size: CGSize, scale: CGFloat = 2) -> NSImage? {
		guard let cgImage = self.cgImage(size: size, scale: scale) else {
			return nil
		}
		return NSImage(cgImage: cgImage, size: size)
	}
}

#else

// MARK: - UIKit Additions

import UIKit
public extension DSFSparklineSurfaceBitmap {
	/// Generate a UIImage for the contents of the surface
	@objc func image(size: CGSize, scale: CGFloat = 2) -> UIImage? {
		guard let cgImage = self.cgImage(size: size, scale: scale) else {
			return nil
		}
		return UIImage(
			cgImage: cgImage,
			scale: scale,
			orientation: UIImage.Orientation.up
		)
	}
}

#endif

// MARK: - Private

private extension DSFSparklineSurfaceBitmap {
	// Generate a bitmap context for the specified rect and scale
	func generateBitmapContext(rect: CGRect, scale: CGFloat) -> CGContext? {
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		guard let bitmapContext = CGContext(
			data: nil,
			width: Int(rect.width * scale),
			height: Int(rect.height * scale),
			bitsPerComponent: 8,
			bytesPerRow: 0,
			space: colorSpace,
			bitmapInfo: bitmapInfo.rawValue
		) else {
			Swift.print("(ERROR) DSFSparklineBitmap unable to generate bitmap context for drawing")
			return nil
		}

		// Need to flip
		bitmapContext.scaleBy(x: scale, y: -scale)
		bitmapContext.translateBy(x: 0, y: -rect.height)
		return bitmapContext
	}
}
