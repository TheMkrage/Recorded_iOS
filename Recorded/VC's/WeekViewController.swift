//
//  WeekViewController.swift
//  Recorded
//
//  Created by Matthew Krager on 2/17/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit

class WeekViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var week: Week!
    
    func getFilteredDays() -> [Day] {
        return week.days.filter { (day) -> Bool in
            return day.date <= Date()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if let newWeek = WeekStore.shared.getWeek(week: self.week) {
            self.week = newWeek
            self.table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.hidesBackButton = fal
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismiss() {
        self.navigationController?.queueUnCurl()
        self.navigationController?.popViewController(animated: false)
    }
}

extension WeekViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getFilteredDays().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.table.dequeueReusableCell(withIdentifier: "Day") as? DayTableViewCell else {
            return UITableViewCell()
        }
        let day = self.getFilteredDays()[indexPath.row]
        cell.cloudImageView.image = day.getCloudImage()
        cell.dayLabel.text = day.date.toLongFormattedString()
        if day.width != 0 {
            cell.aspectRatio.constant = CGFloat(day.width / day.height)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Day") as? DayViewController else {
            return
        }
        vc.day = self.getFilteredDays()[indexPath.row]
        self.navigationController?.queueCurl()
        self.show(vc, sender: self)
    }
}
