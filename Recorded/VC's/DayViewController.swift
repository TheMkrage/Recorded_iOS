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
    @IBOutlet weak var notEnoughLabel: UILabel!
    @IBOutlet weak var recordHereLabel: UILabel!
    
    var textBeforeRecordingBegan = ""
    var day: Day!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HoundVoiceSearch.instance().enableSpeech = false
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(partial(notification:)),
            name: .HoundVoiceSearchPartialTranscription,
            object: nil)
        //self.notEnoughLabel.font = UIFont.init(name: "Chalkduster", size: 16.0)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reload()
    }

    @objc func partial(notification: NSNotification) {
        guard let partial = notification.object as? HoundDataPartialTranscript else {
            fatalError()
        }
        DispatchQueue.main.async {
            self.textView.text =  self.textBeforeRecordingBegan + "\n" + partial.partialTranscript
        }
    }
    
    func reload() {
        let bigImage = self.day.getCloudImage()
        if bigImage == #imageLiteral(resourceName: "Screen Shot 2018-02-18 at 4.11.35 AM") {
            self.cloudImage.image = nil
            DispatchQueue.main.async {
                self.notEnoughLabel.isHidden = false
                self.notEnoughLabel.text = "How's your day going?"
                self.recordHereLabel.isHidden = false
            }
        } else {
            self.notEnoughLabel.isHidden = true
            self.recordHereLabel.isHidden = true
            self.cloudImage.image = bigImage?.giveTransparentBackground()
        }
        self.textView.text = self.day.text
        self.dateLabel.text = self.day.date.toFullMonthFormattedString()
        if day.width != 0 {
            self.aspectRatio.constant = CGFloat(self.day.width / self.day.height)
        }
        WeekStore.shared.save(day: self.day)
    }
    
    @IBAction func dismiss() {
        self.navigationController?.queueUnCurl()
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func trash() {
        self.day.text = ""
        self.day.cloudImageBase64 = ""
        self.reload()
    }
}

extension DayViewController {
    
    @IBAction func recordPressed() {
        self.view.endEditing(true)
        let style = HoundifyStyle.init()

        style.backgroundColor = UIColor.init(hex: "B3B7EE")
        style.backgroundOverlayColor = UIColor.clear
        style.fontName = "Helvetica"
        style.textColor = UIColor.black
        style.buttonTintColor = UIColor.init(hex: "#9395D3")
        style.ringColor = UIColor.purple
        style.useWhiteAttribution = false
        //weak var helpTarget: Any?
        //var helpSelector: Selector?
        style.titleText = "Listening..."
        style.subtitleText = "Tell us about your day!"
        style.hintTitleText = ""
        style.hintSubtitleText = ""
        //style.backgroundOverlayColor = UIColor.clear
        self.textBeforeRecordingBegan = self.textView.text
        self.notEnoughLabel.text = "Listening... Oh that sounds interesting"
        self.view.isUserInteractionEnabled = false
        Houndify.instance().presentListeningViewController(in: self, from: nil, style: style, requestInfo: [:], responseHandler:
            
            { (error: Error?, response: Any?, dictionary: [String : Any]?, requestInfo: [String : Any]?) in
                self.view.isUserInteractionEnabled = true
                self.notEnoughLabel.text = "I have an idea!\nCreating word cloud..."
                if let error = error as NSError? {
                    print("\(error.domain) \(error.code) \(error.localizedDescription)")
                    self.notEnoughLabel.text = "Max API Calls today :("
                } else if let dictionary = dictionary {
                    print(dictionary)
                }
                Houndify.instance().dismissListeningViewController(animated: true, completionHandler: nil)
                guard let serverData = response as? HoundDataHoundServer,
                    let choice = serverData.disambiguation?.choiceData,
                    let commandResult = serverData.allResults?.firstObject() as? HoundDataCommandResult,
                    let choiceData = choice[0] as? HoundDataHoundServerDisambiguationChoiceData,
                    let transcription = choiceData.transcription
                else
                {
                    return
                }
                if transcription != "" && transcription.count > 5 {
                    
                    self.day.text = self.textBeforeRecordingBegan + "\n" + transcription + "."
                    self.textView.text = self.textBeforeRecordingBegan + "\n" + transcription  + "."
                    CloudSession.shared.getImage(text: self.day.text, callback: { (dto) in
                        
                        let data = Data.init(base64Encoded: dto.img_str)
                        var image = UIImage(data: data!)!
                        let transparent = image.giveTransparentBackground()
                        self.day.cloudImageBase64 = transparent.toBase64()
                        self.day.height = dto.height
                        self.day.width = dto.width
                        self.reload()
                    })
                }
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
