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
        // Do any additional setup after loading the view.
    }

    @IBAction func recordTodayButtonPressed(_ sender: UIButton) {
        
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
        self.show(vc, sender: self)
    }
}
