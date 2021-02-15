//
//  ViewController.swift
//  Documentation project
//
//  Created by Darren Ford on 14/2/21.
//

import Cocoa
import DSFSparkline

class FlippedClipView: NSClipView {
	override var isFlipped: Bool {
		return true
	}
}

public extension NSView {
	func snapshot() -> NSImage? {
		guard let bitmapRep = self.bitmapImageRepForCachingDisplay(in: self.bounds) else { return nil }
		self.cacheDisplay(in: self.bounds, to: bitmapRep)
		let image = NSImage()
		image.addRepresentation(bitmapRep)
		return image
	}
}

// Temperture anomolies
// https://www.ncdc.noaa.gov/cag/global/time-series/globe/land_ocean/ytd/12/1880-2019
let land_ocean_temp_anomolies: [CGFloat] = [
	-0.12, -0.09, -0.10, -0.19, -0.27, -0.26, -0.25, -0.29, -0.14, -0.10, -0.36,
	-0.27, -0.32, -0.34, -0.32, -0.25, -0.10, -0.11, -0.28, -0.16, -0.08, -0.16,
	-0.26, -0.37, -0.46, -0.28, -0.21, -0.39, -0.43, -0.44, -0.40, -0.44, -0.34,
	-0.32, -0.14, -0.09, -0.32, -0.39, -0.30, -0.24, -0.23, -0.16, -0.24, -0.25,
	-0.24, -0.18, -0.07, -0.17, -0.18, -0.33, -0.11, -0.06, -0.13, -0.26, -0.11,
	-0.16, -0.12, -0.01, -0.02, 0.01, 0.16, 0.27, 0.11, 0.11, 0.28, 0.18, -0.01,
	-0.04, -0.05, -0.08, -0.15, 0.00, 0.04, 0.13, -0.10, -0.13, -0.18,
	0.07, 0.13, 0.08, 0.05, 0.09, 0.11, 0.12, -0.14, -0.07, -0.01,
	0.00, -0.03, 0.11, 0.06, -0.07, 0.04, 0.19, -0.06, 0.01, -0.07,
	0.21, 0.12, 0.23, 0.28, 0.32, 0.19, 0.36, 0.17, 0.16, 0.24,
	0.38, 0.39, 0.29, 0.45, 0.39, 0.24, 0.28, 0.34, 0.47, 0.32,
	0.51, 0.65, 0.44, 0.42, 0.57, 0.62, 0.64, 0.58, 0.67, 0.64,
	0.62, 0.54, 0.64, 0.72, 0.57, 0.64, 0.68, 0.74, 0.93, 1.00,
	0.91, 0.83, 0.95
]

class ViewController: NSViewController {

	@IBOutlet weak var primaryScrollView: NSScrollView!


	@IBOutlet weak var lineStandardView: DSFSparklineLineGraphView!
	@IBOutlet weak var lineCenteredView: DSFSparklineLineGraphView!

	@IBOutlet weak var lineInterpolatedStandardView: DSFSparklineLineGraphView!
	@IBOutlet weak var lineInterpolatedCenteredView: DSFSparklineLineGraphView!

	@IBOutlet weak var lineMarkersStandardView: DSFSparklineLineGraphView!
	@IBOutlet weak var lineMarkersCenteredView: DSFSparklineLineGraphView!


	@IBOutlet weak var barStandardView: DSFSparklineBarGraphView!
	@IBOutlet weak var barCenteredView: DSFSparklineBarGraphView!

	@IBOutlet weak var stackStandardView: DSFSparklineStackLineGraphView!
	@IBOutlet weak var stackCenteredView: DSFSparklineStackLineGraphView!

	@IBOutlet weak var dotStandardView: DSFSparklineDotGraphView!
	@IBOutlet weak var dotSecondView: DSFSparklineDotGraphView!

	@IBOutlet weak var winLoss: DSFSparklineWinLossGraphView!
	@IBOutlet weak var winLossTie: DSFSparklineWinLossGraphView!

	@IBOutlet weak var tablet1: DSFSparklineTabletGraphView!

	@IBOutlet weak var stripes1: DSFSparklineStripesGraphView!
	@IBOutlet weak var stripes2: DSFSparklineStripesGraphView!


	@IBOutlet weak var pie1: DSFSparklinePieGraphView!
	@IBOutlet weak var pie2: DSFSparklinePieGraphView!
	@IBOutlet weak var pie3: DSFSparklinePieGraphView!
	@IBOutlet weak var pie4: DSFSparklinePieGraphView!
	@IBOutlet weak var pie5: DSFSparklinePieGraphView!
	@IBOutlet weak var pie6: DSFSparklinePieGraphView!
	@IBOutlet weak var pie7: DSFSparklinePieGraphView!
	@IBOutlet weak var pie8: DSFSparklinePieGraphView!
	@IBOutlet weak var pieContainerView: NSView!

	@IBOutlet weak var databarPercent1: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarPercent2: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarPercent3: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarPercent4: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarPercent5: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarPercent6: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarContainerView: NSView!

	@IBOutlet weak var databarTotal1: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarTotal2: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarTotal3: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarTotal4: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarTotal5: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarTotal6: DSFSparklineDataBarGraphView!
	@IBOutlet weak var databarTotalContainerView: NSView!



//	lazy var nameMap: [String: NSView] = { [
//		"line-standard": lineStandardView,
//		"line-centered": lineCenteredView,
//		"line-interpolated": lineInterpolatedStandardView,
//		"line-interpolated-centered": lineInterpolatedCenteredView,
//		"line-markers": lineMarkersStandardView,
//		"line-markers-centered": lineMarkersCenteredView,
//
//		"bar-standard": barStandardView,
//		"bar-centered": barCenteredView,
//
//		"stackline-standard": stackStandardView,
//		"stackline-centered": stackCenteredView,
//
//		"dot-standard": dotStandardView,
//		"dot-inverted": dotSecondView,
//
//		"win-loss": self.winLoss,
//		"win-loss-tie": self.winLossTie,
//
//		"tablet": self.tablet1,
//
//		"pie": self.pieContainerView,
//
//		"databar": self.databarContainerView,
//		"databar-max": self.databarTotalContainerView
//	]
//	}()

	var nameMap: [String: NSView] = [:]
	func buildNameMap() {
		nameMap["line-standard"] = lineStandardView
		nameMap["line-centered"] = lineCenteredView
		nameMap["line-interpolated"] = lineInterpolatedStandardView
		nameMap["line-interpolated-centered"] = lineInterpolatedCenteredView
		nameMap["line-markers"] = lineMarkersStandardView
		nameMap["line-markers-centered"] = lineMarkersCenteredView
		nameMap["bar-standard"] = barStandardView
		nameMap["bar-centered"] = barCenteredView
		nameMap["stackline-standard"] = stackStandardView
		nameMap["stackline-centered"] = stackCenteredView
		nameMap["dot-standard"] = dotStandardView
		nameMap["dot-inverted"] = dotSecondView
		nameMap["win-loss"] = self.winLoss
		nameMap["win-loss-tie"] = self.winLossTie
		nameMap["tablet"] = self.tablet1
		nameMap["pie"] = self.pieContainerView
		nameMap["databar"] = self.databarContainerView
		nameMap["databar-max"] = self.databarTotalContainerView
		nameMap["stripes-standard"] = self.stripes1
		nameMap["stripes-integral"] = self.stripes2
	}

	fileprivate var lineSource: DSFSparklineDataSource = {
		let d = DSFSparklineDataSource(windowSize: 20, range: 0 ... 1, zeroLineValue: 0.3)
		d.push(values: [
			0.72, 0.84, 0.15, 0.16, 0.30, 0.58, 0.87, 0.44, 0.02, 0.27,
			0.48, 0.16, 0.15, 0.14, 0.81, 0.53, 0.67, 0.52, 0.07, 0.50
		])
		return d
	}()

	fileprivate var dotSource: DSFSparklineDataSource = {
		let d = DSFSparklineDataSource(windowSize: 70, range: 0 ... 1)
		d.push(values: [
			0.73, 0.86, 0.72, 0.35, 0.36, 0.09, 0.06, 0.89, 0.94, 0.22,
			0.52, 0.74, 0.53, 0.89, 0.34, 0.67, 0.88, 0.00, 0.78, 0.99,
			0.84, 0.55, 0.02, 0.96, 0.66, 0.94, 0.70, 0.27, 0.18, 0.02,
			0.18, 0.03, 0.00, 0.23, 0.93, 0.17, 0.48, 0.34, 0.89, 0.56,
			0.70, 0.59, 0.12, 0.77, 0.98, 0.31, 0.10, 0.47, 0.42, 0.06,
			1.00, 0.12, 0.50, 0.18, 0.02, 0.90, 0.33, 0.05, 0.60, 0.17,
			0.53, 0.84, 0.72, 0.39, 0.56, 0.57, 0.61, 0.23, 0.96, 0.85
		])
		return d
	}()

	fileprivate var winLossDataSource1: DSFSparklineDataSource = {
		let d = DSFSparklineDataSource(windowSize: 10, range: -1.0 ... 1)
		d.push(values: [1, -1, 0, 1, -1, -1, 1, -1, 0, 1])
		return d
	}()

	fileprivate var landOceanTempAnomolies: DSFSparklineDataSource = {
		let e = DSFSparklineDataSource(windowSize: UInt(land_ocean_temp_anomolies.count))
		e.set(values: land_ocean_temp_anomolies)
		return e
	}()

	fileprivate var twiggle: DSFSparklineDataSource = {
		let e = DSFSparklineDataSource(windowSize: 50)

		var v: Int = 0
		let vv: [CGFloat] = (0 ..< 24).map { value in
			let d = v
			v = (v + 1) % 3
			if d == 0 { return -1 }
			if d == 1 { return 0 }
			return 1
		}
		e.set(values: vv)
		e.windowSize = 50
		return e
	}()

	fileprivate var world: DSFSparklineDataSource = {
		let e = DSFSparklineDataSource(windowSize: UInt(rawData.count))
		e.set(values: rawData)
		return e
	}()


	fileprivate var australianAnomaly: DSFSparklineDataSource = {
		let e = DSFSparklineDataSource(windowSize: UInt(temperature.count))
		e.set(values: temperature)
		return e
	}()


	override func viewDidLoad() {
		super.viewDidLoad()

		self.buildNameMap()

//		do {
//			guard let scroll = self.primaryScrollView,
//					let documentView = scroll.documentView else {
//				return
//			}
//
//			scroll.translatesAutoresizingMaskIntoConstraints = false
//
//			let clip = scroll.contentView
//			clip.translatesAutoresizingMaskIntoConstraints = false
//
//			scroll.addConstraint(NSLayoutConstraint(item: clip, attribute: .left, relatedBy: .equal, toItem: scroll, attribute: .left, multiplier: 1, constant: 0))
//			scroll.addConstraint(NSLayoutConstraint(item: clip, attribute: .top, relatedBy: .equal, toItem: scroll, attribute: .top, multiplier: 1, constant: 0))
//			scroll.addConstraint(NSLayoutConstraint(item: clip, attribute: .right, relatedBy: .equal, toItem: scroll, attribute: .right, multiplier: 1, constant: 0))
//			scroll.addConstraint(NSLayoutConstraint(item: clip, attribute: .bottom, relatedBy: .equal, toItem: scroll, attribute: .bottom, multiplier: 1, constant: 0))
//
//			documentView.translatesAutoresizingMaskIntoConstraints = false
//
//			clip.addConstraint(NSLayoutConstraint(item: clip, attribute: .left, relatedBy: .equal, toItem: documentView, attribute: .left, multiplier: 1, constant: 0))
//			clip.addConstraint(NSLayoutConstraint(item: clip, attribute: .top, relatedBy: .equal, toItem: documentView, attribute: .top, multiplier: 1, constant: 0))
//			//clip.addConstraint(NSLayoutConstraint(item: clip, attribute: .right, relatedBy: .equal, toItem: documentView, attribute: .right, multiplier: 1, constant: 0))
//		}

		self.lineStandardView.dataSource = lineSource
		self.lineCenteredView.dataSource = lineSource

		self.lineInterpolatedStandardView.dataSource = lineSource
		self.lineInterpolatedCenteredView.dataSource = lineSource

		self.lineMarkersStandardView.dataSource = lineSource
		self.lineMarkersCenteredView.dataSource = lineSource


		self.barStandardView.dataSource = lineSource
		self.barCenteredView.dataSource = lineSource

		self.stackStandardView.dataSource = lineSource
		self.stackCenteredView.dataSource = lineSource

		self.dotStandardView.dataSource = dotSource
		self.dotSecondView.dataSource = dotSource

		self.winLoss.dataSource = winLossDataSource1
		self.winLossTie.dataSource = winLossDataSource1

		self.tablet1.dataSource = winLossDataSource1


		self.pie1.dataSource = [10, 30, 20]
		self.pie2.dataSource = [33, 33, 33]
		self.pie3.dataSource = [40, 5, 80]
		self.pie4.dataSource = [1, 2, 3]
		self.pie5.dataSource = [66.7, 66, 66.9]
		self.pie6.dataSource = [9, 9, 4]
		self.pie7.dataSource = [0.5, 0.1, 0.1]
		self.pie8.dataSource = [1000, 2000, 300]

		let palette = DSFSparklinePalette([
			DSFColor(deviceRed: 0, green: 0, blue: 1, alpha: 1),
			DSFColor(deviceRed: 0.33, green: 0.33, blue: 1, alpha: 1),
			DSFColor(deviceRed: 0.66, green: 0.66, blue: 1, alpha: 1)
		])
		self.pie2.palette = DSFSparklinePalette.sharedGrays
		self.pie4.palette = palette
		self.pie6.palette = palette
		self.pie6.palette = DSFSparklinePalette.sharedGrays
		self.pie8.palette = palette


		///

		self.databarPercent1.dataSource = [10, 30, 20]
		self.databarPercent2.dataSource = [33, 33, 33]
		self.databarPercent3.dataSource = [40, 5, 80]
		self.databarPercent4.dataSource = [1, 2, 3]
		self.databarPercent5.dataSource = [66.7, 66, 66.9]
		self.databarPercent6.dataSource = [9, 9, 4]


		self.databarTotal1.dataSource = [8, 19, 20]
		self.databarTotal1.maximumTotalValue = 60
		self.databarTotal2.dataSource = [20, 20, 20]
		self.databarTotal2.maximumTotalValue = 60
		self.databarTotal3.dataSource = [30, 5, 12]
		self.databarTotal3.maximumTotalValue = 60
		self.databarTotal4.dataSource = [10, 15, 20]
		self.databarTotal4.maximumTotalValue = 60
		self.databarTotal5.dataSource = [25, 10, 12]
		self.databarTotal5.maximumTotalValue = 60
		self.databarTotal6.dataSource = [9, 9, 4]
		self.databarTotal6.maximumTotalValue = 60

		let color0 = NSColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0).cgColor
		let color1 = NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
		let color2 = NSColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor

		let gradient = CGGradient(
			colorsSpace: CGColorSpaceCreateDeviceRGB(),
			colors: [color0, color1, color2 ] as CFArray,
			locations: [0.0, 0.5, 1.0]
		)!

		self.stripes1.gradient = gradient
		self.stripes1.integral = false
		self.stripes1.dataSource = world
		//self.stripes1.dataSource = landOceanTempAnomolies
		//self.stripes1.dataSource = twiggle

		///

		self.stripes2.dataSource = australianAnomaly
		australianAnomaly.range = -1.5 ... 1.5

		self.stripes2.gradient = gradient
		self.stripes2.barSpacing = 1
		self.stripes2.integral = true
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	@IBAction func generate(_ sender: Any) {

		let dialog = NSOpenPanel();

		dialog.title = "Choose a folder";
		dialog.showsResizeIndicator = true
		dialog.allowsMultipleSelection = false
		dialog.canChooseDirectories = true
		dialog.canChooseFiles = false
		dialog.canCreateDirectories = true

		dialog.beginSheetModal(for: self.view.window!, completionHandler: { response in
			guard response == NSApplication.ModalResponse.OK,
					let url = dialog.url else {
				return
			}
			DispatchQueue.main.async { [weak self] in
				self?.generate(path: url)
			}
		})
	}

	func generate(path: URL) {

		self.nameMap.forEach { (name, view) in
			let name = "\(name).png"

			let outputFile = path.appendingPathComponent(name)

			guard let image = view.snapshot(),
					let tiff = image.tiffRepresentation,
					let imageRep = NSBitmapImageRep(data: tiff),
					let pngData = imageRep.representation(using: .png, properties: [:]) else {
				return
			}

			do {
				try pngData.write(to: outputFile)
			}
			catch {
				Swift.print("\(error)")
			}
		}
	}


}

/////

// https://www.metoffice.gov.uk/hadobs/hadcrut4/data/current/download.html
// https://www.metoffice.gov.uk/hadobs/hadcrut4/data/current/time_series/HadCRUT.4.6.0.0.annual_ns_avg.txt
// Data format :- https://www.metoffice.gov.uk/hadobs/hadcrut4/data/current/series_format.html

let rawData: [CGFloat] = [
	-0.373,
	-0.218,
	-0.228,
	-0.269,
	-0.248,
	-0.272,
	-0.358,
	-0.461,
	-0.467,
	-0.284,
	-0.343,
	-0.407,
	-0.524,
	-0.278,
	-0.494,
	-0.279,
	-0.251,
	-0.321,
	-0.238,
	-0.262,
	-0.276,
	-0.335,
	-0.227,
	-0.304,
	-0.368,
	-0.395,
	-0.384,
	-0.075,
	 0.035,
	-0.230,
	-0.227,
	-0.200,
	-0.213,
	-0.296,
	-0.409,
	-0.389,
	-0.367,
	-0.418,
	-0.307,
	-0.171,
	-0.416,
	-0.330,
	-0.455,
	-0.473,
	-0.410,
	-0.390,
	-0.186,
	-0.206,
	-0.412,
	-0.289,
	-0.203,
	-0.259,
	-0.402,
	-0.479,
	-0.520,
	-0.377,
	-0.283,
	-0.465,
	-0.511,
	-0.522,
	-0.490,
	-0.544,
	-0.437,
	-0.424,
	-0.244,
	-0.141,
	-0.383,
	-0.468,
	-0.333,
	-0.275,
	-0.247,
	-0.187,
	-0.302,
	-0.276,
	-0.294,
	-0.215,
	-0.108,
	-0.210,
	-0.206,
	-0.350,
	-0.137,
	-0.087,
	-0.137,
	-0.273,
	-0.131,
	-0.178,
	-0.147,
	-0.026,
	-0.006,
	-0.052,
	 0.014,
	 0.020,
	-0.027,
	-0.004,
	 0.144,
	 0.025,
	-0.071,
	-0.038,
	-0.039,
	-0.074,
	-0.173,
	-0.052,
	 0.028,
	 0.097,
	-0.129,
	-0.190,
	-0.267,
	-0.007,
	 0.046,
	 0.017,
	-0.049,
	 0.038,
	 0.014,
	 0.048,
	-0.223,
	-0.140,
	-0.068,
	-0.074,
	-0.113,
	 0.032,
	-0.027,
	-0.186,
	-0.065,
	 0.062,
	-0.214,
	-0.149,
	-0.241,
	 0.047,
	-0.062,
	 0.057,
	 0.092,
	 0.140,
	 0.011,
	 0.194,
	-0.014,
	-0.030,
	 0.045,
	 0.192,
	 0.198,
	 0.118,
	 0.296,
	 0.254,
	 0.105,
	 0.148,
	 0.208,
	 0.325,
	 0.183,
	 0.390,
	 0.539,
	 0.306,
	 0.294,
	 0.441,
	 0.496,
	 0.505,
	 0.447,
	 0.545,
	 0.506,
	 0.491,
	 0.395,
	 0.506,
	 0.560,
	 0.425,
	 0.470,
	 0.514,
	 0.579,
	 0.763,
	 0.797,
	 0.677,
	 0.597,
	 0.736,
	 0.768
]


// Annual mean temperature anomaly
// http://www.bom.gov.au/climate/change/#tabs=Tracker&tracker=timeseries&tQ=graph%3Dtmean%26area%3Daus%26season%3D0112
let temperature: [CGFloat] = [
	-0.50,
	-0.68,
	-0.20,
	-0.87,
	 0.12,
	 0.07,
	-0.57,
	-1.24,
	-0.54,
	-0.15,
	-0.53,
	-0.23,
	-0.47,
	-0.38,
	-0.69,
	-0.77,
	-0.17,
	-0.51,
	 0.16,
	-0.87,
	-0.24,
	-0.59,
	-0.42,
	-0.45,
	-0.36,
	-0.50,
	-0.14,
	-0.36,
	 0.19,
	-0.62,
	-0.24,
	-0.55,
	 0.08,
	-0.62,
	-0.40,
	-0.29,
	-0.73,
	-0.25,
	-0.45,
	-0.94,
	-0.61,
	-0.43,
	-0.43,
	-0.45,
	-0.36,
	-0.32,
	-0.92,
	 0.04,
	 0.14,
	 0.24,
	-0.66,
	 0.05,
	-0.11,
	-0.13,
	-0.22,
	 0.25,
	-0.50,
	-0.22,
	-0.39,
	-0.03,
	-0.10,
	-0.22,
	 0.15,
	 0.54,
	-0.70,
	-0.22,
	-0.75,
	-0.04,
	-0.31,
	 0.37,
	 0.74,
	 0.27,
	-0.04,
	 0.33,
	-0.38,
	 0.21,
	 0.22,
	 0.17,
	 0.73,
	-0.02,
	 0.47,
	 0.60,
	 0.12,
	 0.31,
	 0.18,
	 0.16,
	 0.60,
	 0.30,
	 0.97,
	 0.32,
	-0.04,
	 0.05,
	 0.71,
	 0.69,
	 0.54,
	 1.16,
	 0.50,
	 0.76,
	 0.45,
	 0.93,
	 0.33,
	-0.00,
	 0.24,
	 1.33,
	 1.04,
	 0.94,
	 0.99,
	 1.06,
	 1.12,
	 1.52,
	 1.15
]
