//
//  ViewController.swift
//  COVID19
//
//  Created by 이민지 on 2022/04/20.
//

import UIKit
import Charts
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var totalCaseLebel: UILabel!
    @IBOutlet weak var nesCaseLebel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var labelStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.indicator.startAnimating()
        self.fetchCovidOverView { [weak self] result in
            guard let self = self else { return }
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            self.labelStackView.isHidden = false
            self.pieChartView.isHidden = false
            switch result {
            case let .success(result):
                self.configureStackView(KoreaCovidOverView: result.korea)
                let covidOverViewList = self.makeCovidOverViewList(cityCovidOverView: result)
                self.configureChatView(covidOverViewList: covidOverViewList)
            case let .failure(error):
                debugPrint("error \(error)")
            }
        }
    }
    
    func makeCovidOverViewList(cityCovidOverView: CityCovidOverView) -> [CovidOverView] {
        return [
            cityCovidOverView.seoul,
            cityCovidOverView.busan,
            cityCovidOverView.daegu,
            cityCovidOverView.incheon,
            cityCovidOverView.gwangju,
            cityCovidOverView.daejeon,
            cityCovidOverView.ulsan,
            cityCovidOverView.sejong,
            cityCovidOverView.gyeonggi,
            cityCovidOverView.chungbuk,
            cityCovidOverView.chungnam,
            cityCovidOverView.gyeongnam,
            cityCovidOverView.gyeongbuk,
            cityCovidOverView.jeju,
        ]
    }
    
    func configureChatView(covidOverViewList: [CovidOverView]) {
        self.pieChartView.delegate = self
        let entries = covidOverViewList.compactMap { [weak self] overview -> PieChartDataEntry? in
            guard let self = self else { return nil }
            return PieChartDataEntry(
                value: self.removeFormatString(string: overview.newCase),
                label: overview.countryName,
                data: overview
            )
        }
        let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
        dataSet.sliceSpace = 1
        dataSet.entryLabelColor = .black
        dataSet.valueTextColor = .black
        dataSet.xValuePosition = .outsideSlice
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3
        
        dataSet.colors = ChartColorTemplates.vordiplom() +
        ChartColorTemplates.joyful() +
        ChartColorTemplates.liberty() +
        ChartColorTemplates.pastel() +
        ChartColorTemplates.material()
        
        self.pieChartView.data = PieChartData(dataSet: dataSet)
        self.pieChartView.spin(duration: 0.3, fromAngle: self.pieChartView.rotationAngle, toAngle: self.pieChartView.rotationAngle + 80)
    }
    
    func removeFormatString(string: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue ?? 0
    }
    
    func configureStackView(KoreaCovidOverView: CovidOverView) {
        self.totalCaseLebel.text = "\(KoreaCovidOverView.totalCase)명"
        self.nesCaseLebel.text = "\(KoreaCovidOverView.newCase)명"
    }

    func fetchCovidOverView(completion: @escaping (Result<CityCovidOverView, Error>) -> ()) {
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = [
            "serviceKey": "BUSvMeDCOkV7cNbZHjpAIGTYRQPgia8nK"
        ]
        AF.request(url, method: .get, parameters: param)
            .responseData { response in
                switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverView.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
}

extension ViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let covidDetailController = self.storyboard?.instantiateViewController(withIdentifier: "CovidDetailTableViewController") as? CovidDetailTableViewController else { return }
        guard let covidOverView = entry.data as? CovidOverView else { return }
        covidDetailController.covidOverView = covidOverView
        self.navigationController?.pushViewController(covidDetailController, animated: true)
    }
}
