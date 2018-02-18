//
//  WeekStore.swift
//  Recorded
//
//  Created by Matthew Krager on 2/17/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import Cache

struct WeekStore {
    static var shared = WeekStore()
    
    // init cache objects for weeks
    let diskConfig = DiskConfig.init(name: "weeks", expiry: .never, maxSize: 20000, directory: nil, protectionType: nil)
    lazy var storage: Storage = try! Storage(diskConfig: diskConfig)
    
    private init() {  }
    
    mutating func save(week: Week) {
        let sundayString = week.days[6].date.toString()
        print("saving \(sundayString)")
        try! storage.setObject(week, forKey: sundayString)
    }
    
    mutating func save(day: Day) {
        let lastSundayString = day.date.previous(.sunday, considerToday: true).toString()
        var week = try? storage.object(ofType: Week.self, forKey: lastSundayString)
        let count = (week?.days.count ?? 7)
        let dayOfTheWeekIndex = day.date.getDayOfWeek() - 1
        week?.days[count - dayOfTheWeekIndex - 1] = day
        guard let week2 = week else {
            fatalError()
        }
        self.save(week: week2)
        
    }
    
    mutating func getWeek(week: Week) -> Week? {
        return try? storage.object(ofType: Week.self, forKey: week.days[6].date.toString())
    }
    
    mutating func getLatestWeeks() -> [Week] {
        var weeks = [Week]()
        var dayBeforeSunday = Date.today()
        while(weeks.count != 10) {
            let isFirst = weeks.count == 0
            let lastSunday = dayBeforeSunday.previous(.sunday, considerToday: isFirst)
            let lastSundayString = lastSunday.toString()
            if let week = try? storage.object(ofType: Week.self, forKey: lastSundayString) {
                weeks.append(week)
                dayBeforeSunday = Calendar.current.date(byAdding: .day, value: -1, to: week.days[6].date)!
                print(week.days[0].date.toString())
            } else {
                // create new week instance for first week
                var days = [Day]()
                for i in 0..<7 {
                    let date = Calendar.current.date(byAdding: .day, value: i, to: lastSunday)!
                    let day = Day.init(cloudImageBase64: "", date: date, text: "", width: 0, height: 0)
                    days.append(day)
                }
                let week = Week(days: days.reversed())
                weeks.append(week)
                dayBeforeSunday = Calendar.current.date(byAdding: .day, value: -1, to: week.days[6].date)!
                print(week.days[0].date.toString())
                self.save(week: week)
            }
        }
        return weeks
    }
}
