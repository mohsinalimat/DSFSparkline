//
//  DSFSparklineLineGraphView+Private.swift
//  DSFSparklines
//
//  Created by Darren Ford on 21/12/19.
//  Copyright © 2019 Darren Ford. All rights reserved.
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

public extension DSFSparklineLineGraphView {
	#if os(macOS)
	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		if let ctx = NSGraphicsContext.current?.cgContext {
			self.drawGraph(primary: ctx)
		}
	}
	#else
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		if let ctx = UIGraphicsGetCurrentContext() {
			self.drawGraph(primary: ctx)
		}
	}
	#endif

	private func drawGraph(primary: CGContext) {
		if self.centeredAtZeroLine {
			self.drawCenteredGraph(primary: primary)
		}
		else {
			self.drawLineGraph(primary: primary)
		}
	}

	@inlinable func gradientForColor(_ color: DSFColor) -> CGGradient {
		return CGGradient(
			colorsSpace: nil,
			colors: [color.withAlphaComponent(0.4).cgColor,
						color.withAlphaComponent(0.2).cgColor] as CFArray,
			locations: [1.0, 0.0]
		)!
	}

	override func colorDidChange() {
		// Update the gradients to match the color change
		self.gradient = gradientForColor(self.graphColor)
		self.lowerGradient = gradientForColor(self.lowerColor)
	}
}

private extension DSFSparklineLineGraphView {
	func drawLineGraph(primary: CGContext) {
		guard let dataSource = self.dataSource,
				dataSource.counter != 0  else {
			// There's no line if there's either no data or just a single point
			// https://github.com/dagronf/DSFSparkline/issues/3#issuecomment-770324047
			return
		}

		// Adjust the inset so that markers can draw unclipped if they are asked for
		let inset = self.markerSize > 0 ? self.markerSize / 2 : self.lineWidth
		let drawRect = self.bounds.insetBy(dx: inset, dy: inset)

		let normy = dataSource.normalized
		let xDiff = drawRect.width / CGFloat(normy.count - 1)
		let points = normy.enumerated().map {
			CGPoint(x: CGFloat($0.offset) * xDiff + drawRect.minX,
					  y: drawRect.height + drawRect.minY - ($0.element * drawRect.height))
		}

		let path = CGPath.pathWithPoints(points, smoothed: self.interpolated)

		let allP = CGMutablePath()
		if self.markerSize > 0 {
			points.forEach { point in
				let w = self.markerSize / 2
				let r = CGRect(x: point.x - w, y: point.y - w, width: self.markerSize, height: self.markerSize)
				allP.addPath(CGPath(ellipseIn: r, transform: nil))
			}
		}

		primary.usingGState { outer in

			if dataSource.counter < dataSource.windowSize {
				let pos = self.bounds.minX + (CGFloat(dataSource.counter) * xDiff)
				let clipRect = self.bounds.divided(atDistance: pos, from: .maxXEdge).slice
				outer.clip(to: clipRect)
			}

			if self.lineShading, let gradient = self.gradient {
				outer.usingGState { ctx in

					let clipper = path.mutableCopy()!
					clipper.addLine(to: CGPoint(x: drawRect.maxX, y: points.last!.y))
					clipper.addLine(to: CGPoint(x: drawRect.maxX, y: drawRect.maxY))
					clipper.addLine(to: CGPoint(x: drawRect.minX, y: drawRect.maxY))
					clipper.addLine(to: CGPoint(x: drawRect.minX, y: points.first!.y))
					clipper.closeSubpath()

					ctx.addPath(clipper)
					ctx.clip()
					ctx.drawLinearGradient(
						gradient, start: CGPoint(x: 0.0, y: drawRect.maxY),
						end: CGPoint(x: 0.0, y: drawRect.minY),
						options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
					)
				}
			}

			outer.usingGState { ctx in
				ctx.addPath(path)
				ctx.setStrokeColor(self.graphColor.cgColor)
				ctx.setLineWidth(self.lineWidth)

				let yoff: CGFloat
				#if os(macOS)
				yoff = -0.5 // macos is flipped
				#else
				yoff = 0.5
				#endif

				if shadowed {
					ctx.setShadow(offset: CGSize(width: 0.5, height: yoff),
									  blur: 1.0,
									  color: DSFColor.black.withAlphaComponent(0.3).cgColor)
				}
				ctx.setLineJoin(.round)
				ctx.strokePath()
			}

			if !allP.isEmpty {
				outer.usingGState { ctx in
					ctx.addPath(allP)
					ctx.setFillColor(self.graphColor.cgColor)
					ctx.fillPath()
				}
			}
		}
	}

	func drawCenteredGraph(primary: CGContext) {
		guard let dataSource = self.dataSource,
				dataSource.counter != 0  else {
			// There's no line if there's either no data or just a single point
			// https://github.com/dagronf/DSFSparkline/issues/3#issuecomment-770324047
			return
		}

		// Adjust the inset so that markers can draw unclipped if they are asked for
		let inset = self.markerSize > 0 ? self.markerSize / 2 : self.lineWidth
		let drawRect = self.bounds.insetBy(dx: inset, dy: inset)

		let normy = dataSource.normalized
		let xDiff = drawRect.width / CGFloat(normy.count - 1)
		let points = normy.enumerated().map {
			CGPoint(x: CGFloat($0.offset) * xDiff + drawRect.minX,
					  y: drawRect.height + drawRect.minY - ($0.element * drawRect.height))
		}

		let centroid = (1 - dataSource.normalizedZeroLineValue) * (drawRect.height - 1)

		let pPoints = CGMutablePath()
		let nPoints = CGMutablePath()

		if self.markerSize > 0 {
			points.enumerated().forEach { point in
				let w = self.markerSize / 2
				let r = CGRect(x: point.element.x - w, y: point.element.y - w,
									width: self.markerSize, height: self.markerSize)
				if dataSource.valueAtOffsetIsBelowZeroline(point.offset) {
					nPoints.addPath(CGPath(ellipseIn: r, transform: nil))
				}
				else {
					pPoints.addPath(CGPath(ellipseIn: r, transform: nil))
				}
			}
		}

		let path = CGPath.pathWithPoints(points, smoothed: self.interpolated).mutableCopy()!

		primary.usingGState { outer in

			for which in 0 ... 1 {
				if dataSource.counter < dataSource.windowSize {
					let pos = CGFloat(dataSource.counter) * xDiff
					let clipRect = drawRect.divided(atDistance: pos, from: .maxXEdge).slice
					outer.clip(to: clipRect)
				}

				outer.usingGState { inner in

					let split = drawRect.divided(atDistance: centroid, from: .minYEdge)

					if which == 0 {
						inner.clip(to: split.slice)
					}
					else {
						inner.clip(to: split.remainder)
					}

					if self.lineShading {
						let gradient = (which == 0) ? self.gradient : self.lowerGradient
						if let grad = gradient {
							inner.usingGState { ctx in

								let altY = which == 0 ? drawRect.maxY : drawRect.minY

								let clipper = path.mutableCopy()!
								clipper.addLine(to: CGPoint(x: drawRect.maxX, y: points.last!.y))
								clipper.addLine(to: CGPoint(x: drawRect.maxX, y: altY))
								clipper.addLine(to: CGPoint(x: drawRect.minX, y: altY))
								clipper.addLine(to: CGPoint(x: drawRect.minX, y: points.first!.y))
								clipper.closeSubpath()

								ctx.addPath(clipper)
								ctx.clip()
								ctx.drawLinearGradient(
									grad, start: CGPoint(x: drawRect.minX, y: drawRect.maxY),
									end: CGPoint(x: drawRect.maxX, y: drawRect.minY),
									options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
								)
							}
						}
					}

					let whichColor = which == 0 ? self.graphColor.cgColor : self.lowerColor.cgColor

					inner.usingGState { ctx in
						ctx.addPath(path)
						ctx.setStrokeColor(whichColor)
						ctx.setLineWidth(self.lineWidth)

						let yoff: CGFloat
						#if os(macOS)
						yoff = -0.5 // macos is flipped
						#else
						yoff = 0.5
						#endif

						if shadowed {
							ctx.setShadow(offset: CGSize(width: 0.5, height: yoff),
											  blur: 1.0,
											  color: DSFColor.black.withAlphaComponent(0.3).cgColor)
						}
						ctx.setLineJoin(.round)
						ctx.strokePath()
					}
				}
			}

			if !pPoints.isEmpty {
				outer.usingGState { ctx in
					ctx.addPath(pPoints)
					ctx.setFillColor(self.graphColor.cgColor)
					ctx.fillPath()
				}
			}
			if !nPoints.isEmpty {
				outer.usingGState { ctx in
					ctx.addPath(nPoints)
					ctx.setFillColor(self.lowerColor.cgColor)
					ctx.fillPath()
				}
			}
		}
	}
}
