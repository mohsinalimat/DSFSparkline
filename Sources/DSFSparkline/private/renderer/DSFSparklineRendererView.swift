//
//  File.swift
//
//
//  Created by Darren Ford on 3/2/21.
//

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

@objc public class DSFSparklineRendererView: DSFView {
	#if os(macOS)
	override public var isFlipped: Bool {
		return true
	}
	#endif

	// Render delegate instance
	lazy private var renderDelegate: RendererDelegate = {
		return RendererDelegate(view: self)
	}()

	var rootLayer: CALayer {
		#if os(macOS)
		return self.layer!
		#else
		return self.layer
		#endif
	}

	deinit {}

	override public init(frame: CGRect) {
		super.init(frame: frame)
		self.setup()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.setup()
	}

	private func setup() {
		#if os(macOS)
		self.wantsLayer = true
		#else
		// Configure iOS/tvOS to make the background transparent.
		// If isOpaque is true (the default value) iOS assumes that you're drawing
		// the ENTIRE content of the control (which we are not).
		self.isOpaque = false
		#endif
	}

	/// Multi-platform function for telling the view to update itself
	public func updateDisplay() {
		#if os(macOS)
		self.needsDisplay = true
		#else
		self.setNeedsDisplay()
		#endif
	}
}

extension DSFSparklineRendererView {

	/// Add a sparkline overlay to the view
	public func addOverlay(_ overlay: DSFSparklineOverlay) {
		self.rootLayer.addSublayer(overlay)

		overlay.bounds = self.bounds
		overlay.delegate = self.renderDelegate

		self.syncLayers()
		overlay.setNeedsLayout()
		overlay.setNeedsDisplay()
	}

	/// Remove a sparkline overlay to the view
	public func removeOverlay(_ overlay: DSFSparklineOverlay) {
		overlay.removeFromSuperlayer()
	}

	private func syncLayers() {
		CATransaction.setDisableActions(true)
		self.rootLayer.sublayers?.forEach { layer in
			layer.bounds = self.bounds
			layer.contentsScale = self.retinaScale()
			layer.setNeedsDisplay()
		}
	}

	#if os(macOS)
	public override func layout() {
		super.layout()
		self.syncLayers()
	}
	public override func viewDidMoveToWindow() {
		super.viewDidMoveToWindow()
		self.syncLayers()
	}
	#else
	public override func layoutSubviews() {
		super.layoutSubviews()
		self.syncLayers()
	}
	public override func didMoveToWindow() {
		super.didMoveToWindow()
		self.syncLayers()
	}
	#endif
}

// the draw delegate for the overlay layers
fileprivate class RendererDelegate: NSObject, CALayerDelegate {

	let view: DSFView

	init(view: DSFView) {
		self.view = view
		super.init()
	}

	func draw(_ layer: CALayer, in ctx: CGContext) {
		if let l = layer as? DSFSparklineOverlay {
			let scale = view.retinaScale()
			l.contentsScale = scale
			_ = l.drawGraph(context: ctx, bounds: view.bounds, scale: scale)
		}
	}
}
