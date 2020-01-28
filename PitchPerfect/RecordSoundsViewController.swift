//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Shyam Patel  on 5/17/19.
//  Copyright © 2019 Shyam Patel . All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate
{
    var audioRecorder: AVAudioRecorder!
    let finishRecordingIdentifier = "stopRecording"
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        stopRecordingButton.isEnabled = false
    }
    
    // MARK: Record Audio Function
    
    @IBAction func recordAudio(_ sender: Any)
    {
        configureUI(true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // MARK: Stop Audio Recording Function
    @IBAction func stopRecording(_ sender: Any)
    {
        configureUI(false)
        
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    func configureUI(_ recordState: Bool)
    {
        stopRecordingButton.isEnabled = recordState
        recordButton.isEnabled = !recordState
        recordingLabel.text = !recordState ? "Tap to Record" : "Recording in Progress"
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if flag
        {
            performSegue(withIdentifier: finishRecordingIdentifier, sender: audioRecorder.url)
        }
        else
        {
            print("Audio could not be recorded")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        guard segue.identifier == finishRecordingIdentifier else { return }
        guard let playSoundsVC = segue.destination as? PlaySoundsViewController else { return }
        guard let recordedAudioURL = sender as? URL else { return }
        playSoundsVC.recordedAudioURL = recordedAudioURL
    }
    
}

