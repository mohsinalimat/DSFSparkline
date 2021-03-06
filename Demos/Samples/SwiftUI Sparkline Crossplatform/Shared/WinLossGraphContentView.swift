//
//  WinLossGraphContentView.swift
//  SwiftUI Demo
//
//  Created by Darren Ford on 26/1/21.
//

import SwiftUI
import DSFSparkline

func WinLossCreate() -> some View {
	return WinLossGraphContentView(
		leftDataSource: WinLossDataSource1,
		rightDataSource: WinLossDataSource2,	
		upDataSource: WinLossDataSource3)
}

struct WinLossGraphContentView: View {

	let leftDataSource: DSFSparkline.DataSource
	let rightDataSource: DSFSparkline.DataSource
	let upDataSource: DSFSparkline.DataSource

	var body: some View {
		VStack(spacing: 8) {

			Text("Win/Loss")

			DSFSparklineWinLossGraphView.SwiftUI(
				dataSource: leftDataSource
			)
			.padding(5)
			.border(Color.gray.opacity(0.2), width: 1)

			Text("Win/Loss/Tie")

			DSFSparklineWinLossGraphView.SwiftUI(
				dataSource: rightDataSource,
				winColor: .systemIndigo,
				lossColor: .systemTeal,
				tieColor: DSFColor.systemGray.withAlphaComponent(0.1),
				lineWidth: 3,
				barSpacing: 6
			)
			.padding(5)
			.border(Color.gray.opacity(0.2), width: 1)

			Text("Win/Loss/Tie with center-line")

			DSFSparklineWinLossGraphView.SwiftUI(
				dataSource: upDataSource,
				winColor: .systemGreen,
				lossColor: .systemRed,
				tieColor: DSFColor.systemYellow.withAlphaComponent(0.2),
				barSpacing: 3,
				showZeroLine: true,
				zeroLineDefinition: DSFSparkline.ZeroLineDefinition(color: .systemGray)
			)
			.frame(width: 330.0, height: 34.0)
			.padding(5)
			.border(Color.gray.opacity(0.2), width: 1)
		}
		.frame(height: 400)
		.padding()
	}
}

var WinLossDataSource1: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 10, range: -1.0 ... 1)
	d.push(values: [1, -1, 0, 1, -1, -1, 1, -1, 0, 1])
	return d
}()

var WinLossDataSource2: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 10, range: -1.0 ... 1.0)
	d.push(values: [20, 10, 0, -10, -20, -30, 40, 50, 0, 70])
	return d
}()

var WinLossDataSource3: DSFSparkline.DataSource = {
	let d = DSFSparkline.DataSource(windowSize: 20, range: -1 ... 1)
	d.push(values: [1, 1, 1, -1, 1, 0, -1, -1, 1, 1, 1, -1, -1, 1, 1, 0, -1, 1, 1, 1])
	return d
}()

struct WinLossGraphContentView_Previews: PreviewProvider {
	static var previews: some View {
		WinLossGraphContentView(leftDataSource: WinLossDataSource1,
										rightDataSource: WinLossDataSource2,
										upDataSource: WinLossDataSource3)
	}
}
