//
//  CovidTableViewController.swift
//  COVID19
//
//  Created by 이민지 on 2022/04/20.
//

import UIKit

class CovidDetailTableViewController: UITableViewController {
    @IBOutlet weak var newCaseCell: UITableViewCell!
    @IBOutlet weak var totalCaseCell: UITableViewCell!
    @IBOutlet weak var recoverdCell: UITableViewCell!
    @IBOutlet weak var deathCell: UITableViewCell!
    @IBOutlet weak var overseasInflowCell: UITableViewCell!
    @IBOutlet weak var percentageCell: UITableViewCell!
    @IBOutlet weak var regionalOutbreakCell: UITableViewCell!
    
    var covidOverView: CovidOverView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView() {
        guard let covidOverView = self.covidOverView else { return }
        self.title = covidOverView.countryName
        self.newCaseCell.detailTextLabel?.text = "\(covidOverView.newCase)명"
        self.totalCaseCell.detailTextLabel?.text = "\(covidOverView.totalCase)명"
        self.recoverdCell.detailTextLabel?.text = "\(covidOverView.recovered)명"
        self.deathCell.detailTextLabel?.text = "\(covidOverView.death)명"
        self.overseasInflowCell.detailTextLabel?.text = "\(covidOverView.percentage)명"
        self.percentageCell.detailTextLabel?.text = "\(covidOverView.percentage)"
        self.regionalOutbreakCell.detailTextLabel?.text = "\(covidOverView.newCcase)"
    }
}
