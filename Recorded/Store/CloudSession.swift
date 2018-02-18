//
//  CloudSession.swift
//  Recorded
//
//  Created by Matthew Krager on 2/17/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import Alamofire

struct CloudSession {
    static var shared = CloudSession()
    private init() { }
    
    func getImage(text: String, callback: @escaping (DayDto) -> Void) {
        var dictionary = Dictionary<String, Any>()
        dictionary["text"] = text
        Alamofire.request("https://recorded.herokuapp.com/create_img", method: .post, parameters: dictionary, encoding: JSONEncoding.default,  headers: nil).responseJSON { (response) in
            print(response.value)
            print(response.error)
            guard let dict = response.value as? [String: AnyObject] else {
                fatalError()
            }
            let jsonDecoder = JSONDecoder()
            do {
                guard let data = response.data else {
                    return
                }
                let result = try jsonDecoder.decode(DayDto.self, from: data)
                
                callback(result)
            } catch let error {
                print(error)
            }
        }
    }
}
