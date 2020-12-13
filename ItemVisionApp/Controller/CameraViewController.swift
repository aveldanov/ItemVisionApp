//
//  ViewController.swift
//  ItemVisionApp
//
//  Created by Veldanov, Anton on 12/10/20.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var captureImageView: RoundedShadowImageView!
    @IBOutlet weak var flashButton: RoundedShadowButton!
    @IBOutlet weak var identificationLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    @IBOutlet var roundedLabelView: RoundedShadowView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        previewLayer.frame =  cameraView.bounds // set frame within cameraView
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080 //capture to full screen
        
        let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            let input = try AVCaptureDeviceInput(device: backCamera!)
            if captureSession.canAddInput(input) == true{ //checking if input can be added
                captureSession.addInput(input)
            }
            
            cameraOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddOutput(cameraOutput) == true{
                captureSession.addOutput(cameraOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                cameraView.layer.addSublayer(previewLayer)
                
                captureSession.startRunning()
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
    }
    
    
    func didTapCameraView(){
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first // basic IOS photo. Can be HDR etc
        
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType, kCVPixelBufferWidthKey as String: 160, kCVPixelBufferHeightKey as String: 160]
        
        settings.previewPhotoFormat = previewFormat
        
        
        
    }
    
}

