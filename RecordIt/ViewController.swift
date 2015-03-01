//
//  ViewController.swift
//  RecordIt
//
//  Created by Benjamin Myers on 2/28/15.
//  Copyright (c) 2015 Benjamin Myers. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    @IBOutlet weak var playBTN: UIButton!
    @IBOutlet weak var stopBTN: UIButton!
    @IBOutlet weak var recordBTN: UIButton!
    
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var session = AVAudioSession.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        playBTN.enabled = false
        stopBTN.enabled = false
        
        audioPlayer?.delegate = self
        audioRecorder?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordAudio(sender: AnyObject) {
        var date = NSDate()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0] as String
        var fileName = "sound\(date).caf"
        let soundFilePath = docsDir.stringByAppendingPathComponent(fileName)
        let soundFileURL = NSURL(fileURLWithPath: soundFilePath)
        let recordSettings = [
            AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0
        ]
        
        var error: NSError?
        
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &error)
        
        if let err = error {
            println("audioSession error: \(err.localizedDescription)")
        }
        
        self.audioRecorder = AVAudioRecorder(
            URL: soundFileURL,
            settings: recordSettings,
            error: &error
        )
        
        if let err = error {
            println("audioSession error: \(err.localizedDescription)")
        } else {
            audioRecorder?.prepareToRecord()
        }
        
        if audioRecorder?.recording == false {
            playBTN.enabled = false
            stopBTN.enabled = true
            audioRecorder?.record()
            println("Filename: \(fileName)")
        }
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        stopBTN.enabled = false
        playBTN.enabled = true
        recordBTN.enabled = true
        
        if audioRecorder?.recording == true {
            audioRecorder?.stop()
        } else {
            audioPlayer?.stop()
        }
    }
    
    @IBAction func playAudio(sender: AnyObject) {
        if audioRecorder?.recording == false {
            stopBTN.enabled = true
            recordBTN.enabled = false
            
            var error: NSError?
            
            session.setCategory(AVAudioSessionCategoryPlayback, error: nil)
            session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: nil)
            
            audioPlayer = AVAudioPlayer(contentsOfURL: audioRecorder?.url,
                error: &error)
            
            audioPlayer?.delegate = self
            
            if let err = error {
                println("audioPlayer error: \(err.localizedDescription)")
            } else {
                audioPlayer?.play()
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        recordBTN.enabled = true
        stopBTN.enabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        println("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        println("Recording stopped")
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!, error: NSError!) {
        println("Audio Record Encode Error")
    }
    
    

}

