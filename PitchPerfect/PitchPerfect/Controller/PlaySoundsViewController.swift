//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Marius Chelariu on 27/03/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation

import UIKit
import AVFoundation

enum ButtonType: Int {
    case slow = 0, fast = 1, chipmunk = 2, vader = 3, echo = 4, reverb = 5
}

class PlaySoundsViewController: UIViewController {
    
    // MARK: LifeCycle hooks
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    // MARK: Properties
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    // MARK: UI Elements
    
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var highPitchedButton: UIButton!
    @IBOutlet weak var lowPitchedButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func playSoundForButton(_ sender: UIButton){
        switch (ButtonType(rawValue: sender.tag)) {
        case .slow: playSound(rate: 0.5)
        case .fast: playSound(rate: 1.5)
        case .chipmunk: playSound(pitch: 1000)
        case .vader: playSound(pitch: -1000)
        case .echo: playSound(echo: true)
        case .reverb: playSound(reverb: true)
        case .none:
            playSound()
        }
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_sender: AnyObject){
        stopAudio()
    }

}
