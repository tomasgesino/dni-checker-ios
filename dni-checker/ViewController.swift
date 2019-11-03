//
//  ViewController.swift
//  dni-checker
//
//  Created by Tomas Gesino on 02/10/2019.
//  Copyright © 2019 Tomas Gesino. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet var videoPreview: UIView!

    var stringCode = String()
    
    enum error: Error {
        case noCamraAvailable
        case videoInputInitFail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try scanQRCode() 
        } catch {
            print("Failed to scan QR")
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            let machineReadableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if machineReadableCode.type == AVMetadataObject.ObjectType.pdf417 {
                stringCode = machineReadableCode.stringValue!
                performSegue(withIdentifier: "openLink", sender: self)
            }
        }
    }
    
    func scanQRCode() throws {
        let avCaptureSession = AVCaptureSession()
        
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("no camera")
            throw error.noCamraAvailable
        }
        
        guard let avCaptureInput = try? AVCaptureDeviceInput(device: avCaptureDevice) else {
            print("no video input")
            throw error.videoInputInitFail
        }
        
        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        avCaptureSession.addInput(avCaptureInput)
        avCaptureSession.addOutput(avCaptureMetadataOutput)
        
        avCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.pdf417]
        
        let avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avCaptureVideoPreviewLayer.frame = videoPreview.bounds
        self.videoPreview.layer.addSublayer(avCaptureVideoPreviewLayer)
        
        avCaptureSession.startRunning()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openLink" {
            let destination = segue.destination as! WebViewController
            destination.stringCodeDni = stringCode
        }
    }

}

