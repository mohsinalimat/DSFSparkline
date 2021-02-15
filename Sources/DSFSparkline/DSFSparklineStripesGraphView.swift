//
//  DSFSparklineStripesGraphView.swift
//  DSFSparklines
//
//  Created by Darren Ford on 15/2/21.
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

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

/// A sparkline graph that displays solid color bars with a gradient (like the climate graph)
@IBDesignable
public class DSFSparklineStripesGraphView: DSFSparklineView {
	@IBInspectable public var integral: Bool = true {
		didSet {
			self.updateDisplay()
		}
	}

	/// The spacing (in pixels) between each bar
	@IBInspectable public var barSpacing: UInt = 0 {
		didSet {
			self.updateDisplay()
		}
	}

	/// The color gradient to use when rendering.
	///
	/// Note that transparent gradients display strangely and not as I would expect them to.
	/// Stick with solid colors in your gradient for the current time.
	@objc public var gradient: CGGradient? {
		didSet {
			self.updateGradient()
		}
	}

	internal let helper = GradientHandler()
}