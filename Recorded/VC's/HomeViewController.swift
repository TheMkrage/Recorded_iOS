//
//  HomeViewController.swift
//  Recorded
//
//  Created by Matthew Krager on 2/17/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var recordTodayButton: UIButton!
    var weeks = [Week]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weeks = WeekStore.shared.getLatestWeeks()
        print(weeks.count)
        let navigationBar = navigationController!.navigationBar
        navigationBar.shadowImage = UIImage()
        self.recordTodayButton.layer.cornerRadius = 10.0
        self.recordTodayButton.layer.backgroundColor = UIColor.init(hex: "9395D3").cgColor
        self.recordTodayButton.setTitleColor(UIColor.init(hex: "FBF9FF"), for: .normal)
    }

    @IBAction func recordTodayButtonPressed(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Day") as? DayViewController else {
            return
        }
        let thisWeek = self.weeks[0]
        for day in thisWeek.days {
            if day.date.toString() == Date().toString() {
                vc.day = day
            }
        }
        self.navigationController?.queueCurl()
        self.show(vc, sender: self)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weeks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.table.dequeueReusableCell(withIdentifier: "Week") as? WeekTableViewCell else {
            return UITableViewCell()
        }
        let week = self.weeks[indexPath.row]
        cell.weekLabel.text = week.getFormattedDateRangeString()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Week") as? WeekViewController else {
            return
        }
        vc.week = self.weeks[indexPath.row]
        self.navigationController?.queueCurl()
        self.show(vc, sender: self)
    }
}
