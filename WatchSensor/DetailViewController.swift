//
//  DetailViewController.swift
//  WatchSensor
//
//  Created by 上別縄祐也 on 2022/06/27.
//


import UIKit
import Charts

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    private var makeChart = MakeChart()
    private var exportFile = ExportFile()
    
    var fileInfo: FileInfo = FileInfo(sensorInfo: [], gpsInfo: [], directoryInfo: "", gravityAndAttitudeInfo: [])
    
    private let scrollHeight: CGFloat = UIScreen.main.bounds.height / 4
    private var scrollWidth: CGFloat = 0.0
    private let width: CGFloat = UIScreen.main.bounds.width
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollWidth = firstScrollView.frame.size.width
        
        ExportButtonOutlet.layer.cornerRadius = 10
        
        ExportButtonOutlet.layer.shadowOpacity = 0.7
        // 影のぼかしの大きさ
        ExportButtonOutlet.layer.shadowRadius = 3
        // 影の色
        ExportButtonOutlet.layer.shadowColor = UIColor.black.cgColor
        // 影の方向
        ExportButtonOutlet.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        
        firstPageControl.numberOfPages = 3
        secondPageControl.numberOfPages = 3
        
        let accelCharts = [LineChartView(frame: CGRect(x: 0, y: 20, width: width * 0.98, height: scrollHeight * 0.9)),
                           LineChartView(frame: CGRect(x: scrollWidth * 1 + 2, y: 20, width: width * 0.98, height: scrollHeight * 0.9)),
                           LineChartView(frame: CGRect(x: scrollWidth * 2 + 2, y: 20, width: width * 0.98, height: scrollHeight * 0.9))]
        
        let rotationCharts = [LineChartView(frame: CGRect(x: 0, y: 20, width: width * 0.98, height: scrollHeight * 0.9)),
                              LineChartView(frame: CGRect(x: scrollWidth * 1 + 2, y: 20, width: width * 0.98, height: scrollHeight * 0.9)),
                              LineChartView(frame: CGRect(x: scrollWidth * 2 + 2, y: 20, width: width * 0.98, height: scrollHeight * 0.9))]
        
        let charts = accelCharts + rotationCharts
        
        let graphData = makeChart.makeGraphData(sensorInfo: fileInfo.sensorInfo[1])
        
        for i in 0...5 {
            makeChart.displayChart(data: [graphData.data[0], graphData.data[i + 1]], LineChart: charts[i], label:
                                    graphData.labels[i + 1])
        }
        
        makeChart.setUpCharts(Charts: accelCharts, scrollView: firstScrollView)
        makeChart.setUpCharts(Charts: rotationCharts, scrollView: secondScrollView)
    }
    
    @IBOutlet weak var ExportButtonOutlet: UIButton!
    
    @IBOutlet weak var firstScrollView: UIScrollView! {
        didSet {
            firstScrollView.delegate = self
            firstScrollView.isPagingEnabled = true
            firstScrollView.showsHorizontalScrollIndicator = false
        }
    }
    
    @IBOutlet weak var secondScrollView: UIScrollView! {
        didSet {
            secondScrollView.delegate = self
            secondScrollView.isPagingEnabled = true
            secondScrollView.showsHorizontalScrollIndicator = false
        }
    }
    
    
    @IBOutlet weak var firstPageControl: UIPageControl! {
        didSet {
            firstPageControl.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var secondPageControl: UIPageControl! {
        didSet {
            secondPageControl.isUserInteractionEnabled = false
        }
    }
    
    
    @IBAction func ExportButton(_ sender: Any) {
        exportFile.exportFile(fileInfo: fileInfo)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == firstScrollView {
            firstPageControl.currentPage = Int(scrollView.contentOffset.x / scrollWidth)
        } else if scrollView == secondScrollView {
            secondPageControl.currentPage = Int(scrollView.contentOffset.x / scrollWidth)
        }
        
    }
    
}
