//
//  ViewController.swift
//  InstaShare
//
//  Created by William Bui on 3/13/19.
//  Copyright © 2019 William Bui. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let captureSession = AVCaptureSession()
    
    var previewLayer:CALayer!
    
    var frontCamera:AVCaptureDevice!
    var backCamera:AVCaptureDevice!
    var captureDevice:AVCaptureDevice!
    
    @IBOutlet weak var switchCamera: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var contactsButton: UIButton!
    
    var takePhoto = false
    var connection:AVCaptureConnection!
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCamera()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func prepareCamera(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified).devices
        
        for device in availableDevices{
            if device.position == .back{
                backCamera = device
            } else if device.position == .front{
                frontCamera = device
            }
        }
        //default Camera
        captureDevice = backCamera
        beginSession()
        
    }
    
    
    @IBAction func switchCamera(_ sender: Any) {
        let currentCamera = captureSession.inputs[0]
        captureSession.removeInput(currentCamera)
        if (captureDevice == backCamera){
            captureDevice = frontCamera
        }
        else if (captureDevice == frontCamera){
            captureDevice = backCamera
        }
        do{
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func beginSession(){
        do{
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        } catch{
            print(error.localizedDescription)
        }
        
        let previewLayer=AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = previewLayer
        self.view.layer.addSublayer(self.previewLayer)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer.frame = self.view.layer.frame
        view.bringSubviewToFront(cameraButton)
        view.bringSubviewToFront(switchCamera)
        view.bringSubviewToFront(contactsButton)
        captureSession.startRunning()
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):NSNumber(value:kCVPixelFormatType_32BGRA)] as [String : Any]
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(dataOutput){
            captureSession.addOutput(dataOutput)
            let connection = dataOutput.connection(with: AVFoundation.AVMediaType.video)
            connection?.videoOrientation = .landscapeRight
        }
        
        
        
        captureSession.commitConfiguration()
        
        let queue = DispatchQueue(label: "com.InstaShare.captureQueue")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
        
    }
    
    
    @IBAction func takePhoto(_ sender: Any) {
        takePhoto=true
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if takePhoto{
            takePhoto = false
            if let image = self.getImageFromBuffer(buffer: sampleBuffer){
                
                let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
                photoVC.takenPhoto = image
                DispatchQueue.main.async {
                    self.present(photoVC,animated: true,completion: nil)
                    
                }
            }
        }
    }
    
    func getImageFromBuffer(buffer: CMSampleBuffer)->UIImage?{
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer){
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect){
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }
        return nil
    }


}

