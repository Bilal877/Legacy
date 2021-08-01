//
//  RecordingVC.swift
//  Legacy
//
//  Created by Bilal Zafar on 01/08/2021.
//

import UIKit
import Photos
import SceneKit
import ARKit
import SceneKitVideoRecorder

class RecordingVC: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!

    var recorder: SceneKitVideoRecorder?
    @IBOutlet weak var redoSubmitView: UIStackView!
    @IBOutlet weak var startRecordBtn: UIButton!
    
    @IBOutlet weak var stopRecordBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
//        sceneView.delegate = self
//
//        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
//
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
//
//        recorder = try! SceneKitVideoRecorder(withARSCNView: sceneView)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    
    @IBAction func startRecord(_ sender: Any) {
        startRecordBtn.isHidden = true
        stopRecordBtn.isHidden = false
        _ = self.recorder?.startWriting()
    }
    
    
    @IBAction func StopRecordClicked(_ sender: Any) {
        redoSubmitView.isHidden = false
        stopRecordBtn.isHidden = true
        self.recorder?.finishWriting().onSuccess { [weak self] url in
          print("Recording Finished", url)
          self?.checkAuthorizationAndPresentActivityController(toShare: url, using: self!)
        }
        
    }
    
    
    @IBAction func redoClicked(_ sender: Any) {
        
    }
    
    @IBAction func SubmittedClicked(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThankyouVC") as! ThankyouVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:- DELEGATE METHODS
    
    private func checkAuthorizationAndPresentActivityController(toShare data: Any, using presenter: UIViewController) {
      switch PHPhotoLibrary.authorizationStatus() {
      case .authorized:
        let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.print]
        presenter.present(activityViewController, animated: true, completion: nil)
      case .restricted, .denied:
        let libraryRestrictedAlert = UIAlertController(title: "Photos access denied",
                                                       message: "Please enable Photos access for this application in Settings > Privacy to allow saving screenshots.",
                                                       preferredStyle: UIAlertController.Style.alert)
        libraryRestrictedAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        presenter.present(libraryRestrictedAlert, animated: true, completion: nil)
      case .notDetermined:
        PHPhotoLibrary.requestAuthorization({ (authorizationStatus) in
          if authorizationStatus == .authorized {
            let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
              activityViewController.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.print]
              presenter.present(activityViewController, animated: true, completion: nil)
          }
        })
      case .limited: break
          
      }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)

      // Pause the view's session
      sceneView.session.pause()
    }

    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate

    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()

     return node
     }
     */

    func session(_ session: ARSession, didFailWithError error: Error) {
      // Present an error message to the user

    }

    func sessionWasInterrupted(_ session: ARSession) {
      // Inform the user that the session has been interrupted, for example, by presenting an overlay

    }

    func sessionInterruptionEnded(_ session: ARSession) {
      // Reset tracking and/or remove existing anchors if consistent tracking is required

    }

}
