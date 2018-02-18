//
//  DayViewController.swift
//  Recorded
//
//  Created by Matthew Krager on 2/17/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import HoundifySDK

class DayViewController: UIViewController {
    
    @IBOutlet weak var aspectRatio: NSLayoutConstraint!
    @IBOutlet weak var cloudImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    
    var day: Day!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reload()
    }
    
    func reload() {
        self.cloudImage.image = self.day.getCloudImage()
        self.textView.text = self.day.text
        self.dateLabel.text = self.day.date.toFormattedString()
        if day.width != 0 {
            self.aspectRatio.constant = CGFloat(self.day.width / self.day.height)
        }
        WeekStore.shared.save(day: self.day)
    }
    
    @IBAction func trash() {
        self.day.text = ""
        self.reload()
    }
}

extension DayViewController {
    @IBAction func recordPressed() {
        self.view.endEditing(true)
        Houndify.instance().presentListeningViewController(in: self, from: nil, style: nil, requestInfo: [:], responseHandler:
            
            { (error: Error?, response: Any?, dictionary: [String : Any]?, requestInfo: [String : Any]?) in
                if let error = error as NSError? {
                    print("\(error.domain) \(error.code) \(error.localizedDescription)")
                } else if let dictionary = dictionary {
                    print(dictionary)
                }
                
                guard let serverData = response as? HoundDataHoundServer,
                    let choice = serverData.disambiguation?.choiceData,
                    let commandResult = serverData.allResults?.firstObject() as? HoundDataCommandResult,
                    let choiceData = choice[0] as? HoundDataHoundServerDisambiguationChoiceData,
                    let transcription = choiceData.transcription
                else
                {
                    return
                }
                if transcription != "" {
                    self.day.text = self.textView.text + "\n" + transcription
                    self.textView.text = self.textView.text + "\n" + transcription
                    CloudSession.shared.getImage(text: self.day.text, callback: { (dto) in
                        self.day.cloudImageBase64 = dto.img_str
                        self.day.height = dto.height
                        self.day.width = dto.width
                        self.reload()
                    })
                }
                Houndify.instance().dismissListeningViewController(animated: true, completionHandler: nil)
            }
        )
    }
    
    fileprivate func dismissSearch() {
        Houndify.instance().dismissListeningViewController(animated: true, completionHandler: nil)
    }
    
    // MARK: - Notifications
    
    func handle(houndVoiceSearchStateChangeNotification notification: Notification) {
        var statusString = ""
        
        switch HoundVoiceSearch.instance().state {
        case .none:
            // Don't update UI when audio is disabled for backgrounding.
            if UIApplication.shared.applicationState == .active {
                statusString = ""
                self.recordButton.isEnabled = true
            }
        case .ready:
            statusString = "Listening"
            self.recordButton.isEnabled = HoundVoiceSearch.instance().enableHotPhraseDetection == false
        case .recording:
            statusString = "Recording"
        case .searching:
            statusString = "Searching"
        case .speaking:
            statusString = "Speaking"
        }
        
        print(statusString)
    }
}
