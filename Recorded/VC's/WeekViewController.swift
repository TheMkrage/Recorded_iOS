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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension WeekViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.week.days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.table.dequeueReusableCell(withIdentifier: "Day") as? DayTableViewCell else {
            return UITableViewCell()
        }
        let day = self.week.days[indexPath.row]
        cell.cloudImageView.image = day.getCloudImage()
        cell.dayLabel.text = day.date.toFormattedString()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Day") else {
            return
        }
        
        
    }
}
