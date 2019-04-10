import UIKit
import DXCharts

class ViewController: UIViewController {
    @IBOutlet weak var chart: DXChart!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = Bundle.main.url(forResource: "StockData", withExtension: "xml")!
        let provider = XmlOhlcProvider(xmlUrl: url)
        
        let ohlcSeries = DXStockSeries()
        ohlcSeries.data = OhlcArrayToFinancialDataAdapter(array: provider.getPoints())
        ohlcSeries.displayName = "OHLC"
        chart.addSeries(ohlcSeries)
        
        let movingAverage = DXMovingAverageIndicator()
        movingAverage.data = CalculatedSeriesData(series: ohlcSeries)
        movingAverage.displayName = "MA (21)"
        movingAverage.valueLevel = .close
        movingAverage.pointsCount = 21
        chart.addSeries(movingAverage)
        
        let axisY = DXNumericAxisY()
        axisY.alwaysShowZeroLevel = false
        chart.axisY = axisY
        
        let legend = DXLegend()
        legend.horizontalPosition = .center
        legend.verticalPosition = .topOutside
        legend.orientation = .leftToRight
        chart.legend = legend
        
        chart.axisXNavigationMode = .scrollingAndZooming
        chart.axisYNavigationMode = .scrollingAndZooming
    }
}

class CalculatedSeriesData: NSObject, DXCalculatedSeriesData {
    let series: DXSeries
    
    required init (series: DXSeries) {
        self.series = series
    }
    
    func getSource() -> DXSeries! {
        return series
    }
}

class OhlcArrayToFinancialDataAdapter: NSObject, DXFinancialSeriesData {
    private let points: [OhlcPoint]
    
    required init(array: [OhlcPoint]) {
        points = array
    }
    
    func getCount() -> Int32 {
        return Int32(points.count)
    }
    
    func getArgumentBy(_ index: Int32) -> Date! {
        return points[Int(index)].date
    }
    
    func getHighValue(by index: Int32) -> Double {
        return points[Int(index)].high
    }
    
    func getLowValue(by index: Int32) -> Double {
        return points[Int(index)].low
    }
    
    func getOpenValue(by index: Int32) -> Double {
        return points[Int(index)].open
    }
    
    func getCloseValue(by index: Int32) -> Double {
        return points[Int(index)].close
    }
}
