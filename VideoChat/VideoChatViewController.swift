//
//  VideoChatViewController.swift
//  VideoChat
//
//  Created by Roger Ko on 2017/10/04.
//  Copyright © 2017 Mediwhere. All rights reserved.
//

import UIKit
import WebRTC

class VideoChatViewController: UIViewController {

    //Views, Labels, and Buttons
    @IBOutlet weak var remoteView: RTCEAGLVideoView!
    @IBOutlet weak var localView: RTCEAGLVideoView!
    @IBOutlet weak var hangUpButton: UIButton!
    //Constraints
    @IBOutlet weak var remoteViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var remoteViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var remoteViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var remoteViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var localViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var localViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var localViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var localViewRightConstraint: NSLayoutConstraint!
    //Var
    var roomUrl:String?;
    var client:ARDAppClient?;
    var _roomName:NSString=NSString(format: "")
    var roomName:NSString?
    var localVideoTrack:RTCVideoTrack?;
    var remoteVideoTrack:RTCVideoTrack?;
    var localVideoSize:CGSize?;
    var remoteVideoSize:CGSize?;
    var captureController:ARDCaptureController = ARDCaptureController()

    
    override func viewDidLoad() {
        print("ViewDidLoadbegan");
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.roomName="907207548"
        self.roomName="461909097"
        self.remoteView?.delegate=self
        self.localView?.delegate=self
        print("ViewDidLoad");
    }
    
    func connect() {
        //connect to the room
        self.disconnect()
        self.client=ARDAppClient(delegate: self)
        //self.client?.serverHostUrl="https://apprtc.appspot.com"
        let settingsModel = ARDSettingsModel()
        //we can force unwrap roomname because we will make sure it has a string
        self.client!.connectToRoom(withId: self.roomName! as String!, settings: settingsModel, isLoopback: false, isAudioOnly: false, shouldMakeAecDump: false, shouldUseLevelControl: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //set the local view to the maximum first, when connected this will shrink
        self.localViewBottomConstraint?.constant=0.0
        self.localViewRightConstraint?.constant=0.0
        self.localViewHeightConstraint?.constant=self.view.frame.size.height
        self.localViewWidthConstraint?.constant=self.view.frame.size.width
        connect()
    }
    
    func disconnect(){
        if let _ = self.client {
            self.localVideoTrack?.remove(self.localView!)
            self.remoteVideoTrack?.remove(self.remoteView!)
            self.localView?.renderFrame(nil)
            self.remoteView?.renderFrame(nil)
            self.localVideoTrack=nil
            self.remoteVideoTrack=nil
            self.client?.disconnect()
        }
    }
    
    func remoteDisconnected(){
        self.remoteVideoTrack?.remove(self.remoteView!)
        self.remoteView?.renderFrame(nil)
        if self.localVideoSize != nil {
            self.videoView(self.localView!, didChangeVideoSize: self.localVideoSize!)
        }
    }

    @IBAction func endCallButtonPressed(_ sender: Any) {
        self.disconnect()
        //unwindsegue here
        self.performSegue(withIdentifier: "unwindToCallScreen", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension VideoChatViewController: ARDAppClientDelegate {
    func appClient(_ client: ARDAppClient!, didChange state: ARDAppClientState) {
        switch (state) {
        case .connected:
            print("Client connected.");
        case .connecting:
            print("Client connecting.");
        case .disconnected:
            print("Client disconnected.");
            self.remoteDisconnected();
        }
    }
    
    func appClient(_ client: ARDAppClient!, didChange state: RTCIceConnectionState) {
    }
    
    func appClient(_ client: ARDAppClient!, didCreateLocalCapturer localCapturer: RTCCameraVideoCapturer!) {
        let settingsModel = ARDSettingsModel()
        captureController = ARDCaptureController(capturer: localCapturer, settings: settingsModel)
        captureController.startCapture()
    }
    
    func appClient(_ client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
        self.localVideoTrack?.remove(self.localView!)
        self.localView?.renderFrame(nil)
        self.localVideoTrack=localVideoTrack
        self.localVideoTrack?.add(self.localView!)
    }
    
    func appClient(_ client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!) {
        self.remoteVideoTrack=remoteVideoTrack
        self.remoteVideoTrack?.add(self.remoteView!)
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.localViewBottomConstraint?.constant=28.0
            self.localViewRightConstraint?.constant=28.0
            self.localViewHeightConstraint?.constant=self.view.frame.size.height/4
            self.localViewWidthConstraint?.constant=self.view.frame.size.width/4
        })
    }
    
    func appClient(_ client: ARDAppClient!, didError error: Error!) {
        let alert = UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "close")
        alert.show()
        self.disconnect()
    }
    
    func appClient(_ client: ARDAppClient!, didGetStats stats: [Any]!) {
    }
    
    
}

extension VideoChatViewController: RTCEAGLVideoViewDelegate {
    func videoView(_ videoView: RTCEAGLVideoView, didChangeVideoSize size: CGSize) {
    }
    
}
