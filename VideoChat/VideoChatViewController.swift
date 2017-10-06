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
    
    var roomUrl:String?;
    var client:ARDAppClient?;
    var _roomName:NSString=NSString(format: "")
    var roomName:NSString?
    var localVideoTrack:RTCVideoTrack?;
    var remoteVideoTrack:RTCVideoTrack?;
    var localVideoSize:CGSize?;
    var remoteVideoSize:CGSize?;
    
    override func viewDidLoad() {
        print("ViewDidLoadbegan");
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.roomName="907207548"
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
        print("Successfully Connected to room \(self.roomName!)!")
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
            self.localView?.renderFrame(nil)
            self.remoteView?.renderFrame(nil)
            self.client?.disconnect()
        }
        print("Successfully Disconnected from room \(self.roomName!)!")
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
    }
    
    func appClient(_ client: ARDAppClient!, didChange state: RTCIceConnectionState) {
    }
    
    func appClient(_ client: ARDAppClient!, didCreateLocalCapturer localCapturer: RTCCameraVideoCapturer!) {
    }
    
    func appClient(_ client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
    }
    
    func appClient(_ client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!) {
    }
    
    func appClient(_ client: ARDAppClient!, didError error: Error!) {
    }
    
    func appClient(_ client: ARDAppClient!, didGetStats stats: [Any]!) {
    }
    
    
}

extension VideoChatViewController: RTCEAGLVideoViewDelegate {
    func videoView(_ videoView: RTCEAGLVideoView, didChangeVideoSize size: CGSize) {
    }
    
}
