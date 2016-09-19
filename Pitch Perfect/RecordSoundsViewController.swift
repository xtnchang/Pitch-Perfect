//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Christine Chang on 7/31/16.
//  Copyright © 2016 Christine Chang. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordingButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: AnyObject) {
        print("Record button pressed")
        configureView(isRecording: true)
        
        // Commented out code below is abstracted out into func configureView.
        /*
         recordingLabel.text = "Recording in progress"
         stopRecordingButton.enabled = true
         recordButton.enabled = false
         */
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(sender: AnyObject) {
        print("Stop recording button pressed")
        configureView(isRecording: false)
        
        // Commented out code below is abstracted out into func configureView.
        /*
         recordingLabel.text = "Tap the microphone to record"
         stopRecordingButton.enabled = false
         recordButton.enabled = true
         */
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func configureView(isRecording isRecording: Bool){
        // Set label (ternary operator)
        recordingLabel.text =
            isRecording ? "Recording in progress" : "Tap the microphone to record"
        
        // Set buttons
        stopRecordingButton.enabled = isRecording
        recordButton.enabled = !isRecording
    }
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear called") 
    }
    
    // Use this function to call the stopRecording segue.
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVAudioRecorder finished saving recording.")
        if (flag) {
            performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        } else {
            print("Saving of recording failed.")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

