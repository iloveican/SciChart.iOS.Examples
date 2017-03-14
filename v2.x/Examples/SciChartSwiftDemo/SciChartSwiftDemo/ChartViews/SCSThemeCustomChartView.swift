//
//  SCSThemeCustomChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 12/19/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSThemeCustomChartView: SCSBaseChartView {
    
    var dataSource : [SCSMultiPaneItem]!
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxis()
        addDefaultModifiers()
        addDataSeries()
        applyCustomTheme()
    }
    
    // MARK: Private Methods
    
    fileprivate func addAxis() {
        
        let axisStyle = SCIAxisStyle()
        axisStyle.drawMajorGridLines = false
        axisStyle.drawMinorGridLines = false
        axisStyle.drawMinorTicks = false
        axisStyle.drawMajorBands = false
        
        let xAxis = SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle)
        xAxis.axisTitle = "Bottom Axis Title";
        chartSurface.xAxes.add(xAxis)
        
        let yAxis = SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle)
        yAxis.axisTitle = "Right Axis Title"
        chartSurface.yAxes.add(yAxis)
        
        let yAxis2 = SCINumericAxis()
        yAxis2.axisAlignment = .left
        yAxis2.axisId = "yAxis2"
        yAxis2.axisTitle = "Left Axis Title"
        chartSurface.yAxes.add(yAxis2)
    }
    
    fileprivate func addDataSeries() {
        
        dataSource = SCSDataManager.loadThemeData()
        
        let priceDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        priceDataSeries.seriesName = "Line Series"
        priceDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let priceRenderableSeries = SCIFastLineRenderableSeries()
        priceRenderableSeries.style.drawPointMarkers = false
        priceRenderableSeries.dataSeries = priceDataSeries
        chartSurface.renderableSeries.add(priceRenderableSeries)
        
        let ohlcDataSeries = SCIOhlcDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        ohlcDataSeries.seriesName = "Candle Series"
        ohlcDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let candlestickRenderableSeries = SCIFastCandlestickRenderableSeries()
        candlestickRenderableSeries.dataSeries = ohlcDataSeries
        candlestickRenderableSeries.style.drawBorders = false
        chartSurface.renderableSeries.add(candlestickRenderableSeries)
        
        let mountainDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        mountainDataSeries.seriesName = "Mountain Series"
        mountainDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let mountainRenderableSeries = SCIFastMountainRenderableSeries()
        mountainRenderableSeries.dataSeries = mountainDataSeries
        chartSurface.renderableSeries.add(mountainRenderableSeries)
        
        let columnDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        columnDataSeries.seriesName = "Column Series"
        columnDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let columnRenderableSeries = SCIFastColumnRenderableSeries()
        columnRenderableSeries.style.dataPointWidth = 0.3
        columnRenderableSeries.dataSeries = columnDataSeries
        chartSurface.renderableSeries.add(columnRenderableSeries)
        
        let averageHigh = SCSMovingAverage(length: 20)
        var i = 0
        for item: SCSMultiPaneItem in dataSource {
            let date = SCIGeneric(i)
            let open = SCIGeneric(item.open)
            let high = SCIGeneric(item.high)
            let low = SCIGeneric(item.low)
            let close = SCIGeneric(item.close)
            ohlcDataSeries.appendX(date, open: open, high: high, low: low, close: close)
            priceDataSeries.appendX(date, y: SCIGeneric(averageHigh.push(item.close).current))
            mountainDataSeries.appendX(date, y: SCIGeneric(item.close - 1000))
            columnDataSeries.appendX(date, y: SCIGeneric(item.close - 3500))
            i += 1
        }
        chartSurface.invalidateElement()
        
    }
    
    func applyCustomTheme() {
        
        let themeProvider = SCIThemeProvider()
        
        // Axis
        themeProvider.axisTitleLabelStyle.colorCode = 0xFF6495ED
        themeProvider.axisTickLabelStyle.colorCode = 0xFF6495ED
        themeProvider.axisMajorGridLineBrush = SCISolidPenStyle(colorCode: 0xFF102a47, withThickness: 1.0)
        themeProvider.axisMinorGridLineBrush = SCISolidPenStyle(colorCode: 0xFF0d223d, withThickness: 1.0)
        themeProvider.axisGridBandBrush = SCISolidBrushStyle(colorCode: 0xFF0e233a)
        
        //Modifier
        themeProvider.modifierRolloverStyle.rolloverPen = SCISolidPenStyle(colorCode: 0x33fd9f25, withThickness: 1.0)
        themeProvider.modifierRolloverStyle.axisTooltipColor = UIColor.fromABGRColorCode(0x33fd9f25)
        themeProvider.modifierRolloverStyle.axisTextStyle.colorCode = 0xFFeeeeee
        themeProvider.modifierCursorStyle.cursorPen = SCISolidPenStyle(colorCode: 0x996495ed, withThickness: 1.0)
        themeProvider.modifierCursorStyle.axisHorizontalTooltipColor = UIColor.fromABGRColorCode(0x996495ed)
        themeProvider.modifierCursorStyle.axisVerticalTooltipColor = UIColor.fromABGRColorCode(0x996495ed)
        themeProvider.modifierCursorStyle.axisVerticalTextStyle.colorCode = 0xFFeeeeee
        themeProvider.modifierCursorStyle.axisHorizontalTextStyle.colorCode = 0xFFeeeeee
        themeProvider.modifierLegendBackgroundColor = UIColor.fromABGRColorCode(0xFF0D213a)
        
        // RendereableSeries
        themeProvider.stackedMountainAreaBrushStyle = SCISolidBrushStyle(colorCode: 0xFF094c9f)
        themeProvider.mountainAreaBrushStyle = SCISolidBrushStyle(colorCode: 0xFF094c9f)
        themeProvider.stackedMountainBorderPenStyle = SCISolidPenStyle(colorCode: 0xFF76bbd2, withThickness: 1.0)
        themeProvider.mountainBorderPenStyle = SCISolidPenStyle(colorCode: 0xFF76bbd2, withThickness: 1.0)
        themeProvider.impulseLinePenStyle = SCISolidPenStyle(colorCode: 0xFFC6E6FF, withThickness: 1.0)
        themeProvider.linePenStyle = SCISolidPenStyle(colorCode: 0xFFC6E6FF, withThickness: 1.0)
        themeProvider.stackedColumnBorderPenStyle = SCISolidPenStyle(colorCode: 0xFFFFFFFF, withThickness: 1.0)
        themeProvider.columnBorderPenStyle = SCISolidPenStyle(colorCode: 0xFFFFFFFF, withThickness: 1.0)
        themeProvider.stackedColumnFillBrushStyle = SCISolidBrushStyle(colorCode: 0xFFFFFFFF)
        themeProvider.columnFillBrushStyle = SCISolidBrushStyle(colorCode: 0xFFFFFFFF)
        themeProvider.candleUpWickPen = SCISolidPenStyle(colorCode: 0xFF6495ed, withThickness: 1.0)
        themeProvider.candleDownWickPen = SCISolidPenStyle(colorCode: 0xFF00008b, withThickness: 1.0)
        themeProvider.candleUpBodyBrush = SCISolidBrushStyle(colorCode: 0xa06495ed)
        themeProvider.candleDownBodyBrush = SCISolidBrushStyle(colorCode: 0xa000008b)
        themeProvider.ohlcUpWickPenStyle = SCISolidPenStyle(colorCode: 0xFF6495ed, withThickness: 1.0)
        themeProvider.ohlcDownWickPenStyle = SCISolidPenStyle(colorCode: 0xFF00008b, withThickness: 1.0)
        themeProvider.bandPen1Style = SCISolidPenStyle(colorCode: 0xFF6495ed, withThickness: 1.0)
        themeProvider.bandPen2Style = SCISolidPenStyle(colorCode: 0xFF00008b, withThickness: 1.0)
        themeProvider.bandBrush1Style = SCISolidBrushStyle(colorCode: 0xa06495ed)
        themeProvider.bandBrush2Style = SCISolidBrushStyle(colorCode: 0xa000008b)
        
        //Chart
        themeProvider.chartTitleColor = UIColor.fromABGRColorCode(0xFF6495ED)
        themeProvider.borderPen = SCISolidPenStyle(colorCode: 0xFF102a47, withThickness: 1.0)
        themeProvider.seriesBackgroundBrush = SCISolidBrushStyle(color: UIColor.clear)
        themeProvider.backgroundBrush = SCISolidBrushStyle(colorCode: 0xFF0D213a)
        
        //Annotation
        themeProvider.annotationTextStyle.colorCode = 0xFF222222
        themeProvider.annotationTextBackgroundColor = UIColor.fromABGRColorCode(0xFF999999)
        themeProvider.annotationAxisMarkerBorderColor = UIColor.clear
        themeProvider.annotationAxisMarkerBackgroundColor = UIColor.fromABGRColorCode(0xFF999999)
        themeProvider.annotationAxisMarkerTextStyle.colorCode = 0xFF222222
        themeProvider.annotationAxisMarkerLineStyle = SCISolidPenStyle(colorCode: 0x77333333, withThickness: 1.0)
        themeProvider.annotationLinePenStyle = SCISolidPenStyle(colorCode: 0x77333333, withThickness: 1.0)
        themeProvider.annotationLineResizeMarker = SCIEllipsePointMarker()
        (themeProvider.annotationLineResizeMarker as! SCIEllipsePointMarker).fillBrush = SCISolidBrushStyle(colorCode: 0x994682b4)
        (themeProvider.annotationLineResizeMarker as! SCIEllipsePointMarker).borderPen = SCISolidPenStyle(colorCode: 0xFF4682b4, withThickness: 1.0)
        themeProvider.annotationBoxPointMarkerStyle = SCIEllipsePointMarker()
        (themeProvider.annotationBoxPointMarkerStyle as! SCIEllipsePointMarker).fillBrush = SCISolidBrushStyle(colorCode: 0x994682b4)

        themeProvider.annotationBoxPointMarkerStyle = SCIEllipsePointMarker()
        (themeProvider.annotationBoxPointMarkerStyle as! SCIEllipsePointMarker).fillBrush = SCISolidBrushStyle(colorCode: 0x994682b4)
        (themeProvider.annotationBoxPointMarkerStyle as! SCIEllipsePointMarker).borderPen = SCISolidPenStyle(colorCode: 0xFF4682b4, withThickness: 1.0)
        themeProvider.annotationBoxBorderPenStyle = SCISolidPenStyle(color: UIColor.clear, withThickness: 0.0)
        themeProvider.annotationBoxFillBrushStyle = SCISolidBrushStyle(colorCode: 0xFF999999)
        
        chartSurface.applyTheme(withThemeProvider: themeProvider)
        
    }
    
}