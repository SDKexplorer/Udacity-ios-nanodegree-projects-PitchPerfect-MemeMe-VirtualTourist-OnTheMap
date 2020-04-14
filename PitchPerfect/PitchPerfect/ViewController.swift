//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Marius Chelariu on 27/03/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController {

    // MARK: Properties
    var audioRecorder: AVAudioRecorder!
    
    // MARK: LifeCycle hooks
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: UI Elements
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    
    // MARK: Actions
    @IBAction func recordAudio(_ sender: Any) {
        toggleState(state: true)
    }
    @IBAction func stopRecording(_ sender: Any) {
        toggleState(state: false)
    }
    
    // MARK: Methods
    private func toggleState(state: Bool){
        recordButton.isEnabled = !state;
        stopRecordButton.isEnabled = state;
        recordingLabel.text = state ? "Recording in progress" : "Tap to record"
    }
    
    private func getFilePath() -> URL {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        return URL(string: pathArray.joined(separator: "/"))!
    }
    
    private func recordAudio() {
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: getFilePath(), settings: [:])
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
}

