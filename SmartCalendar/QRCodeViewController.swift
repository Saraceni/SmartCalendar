//
//  ViewController.swift
//  SmartCalendar
//
//  Created by Rafael Saraceni on 4/14/16.
//  Copyright © 2016 Rafael Saraceni. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController {
    
    
    // MARK: - Layout Variables
    @IBOutlet var qrCodePreview: UIView!
    
    // MARK: - QRCode Variables
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var isReading = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        qrCodePreview.layer.cornerRadius = 5.0
        qrCodePreview.layer.masksToBounds = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.startReading()
    }

    func startReading() -> Bool {
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            
            let input  = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            
            captureSession?.addOutput(captureMetadataOutput)
            
            let dispatchQueue = dispatch_queue_create("Queue", nil)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatchQueue)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = qrCodePreview.layer.bounds
            qrCodePreview.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            isReading = true
            
            return true
            
        }
        catch let error as NSError { print(error); return false }
        
    }


}

extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        guard isReading else { return }
        
        if let metadaObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject  {
            
            self.isReading = false
            let data = metadaObject.stringValue
            print(data)
            
            let stringData = EventHelper.decodeEventData(data)
            let objectData = EventHelper.decodeEventData(stringData)
            if EventHelper.addEvent(objectData) {
                
            }
            
            
        }
        
    }
}












