//
//  ViewController.swift
//  ItemVisionApp
//
//  Created by Veldanov, Anton on 12/10/20.
//

import UIKit
import AVFoundation
import CoreML
import Vision

enum FlashState {
    case off
    case on
}

class CameraViewController: UIViewController {
    
    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var photoData: Data?
    
    var flashControlState: FlashState = .off
    
    var speechSythesizer =  AVSpeechSynthesizer()
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var captureImageView: RoundedShadowImageView!
    @IBOutlet weak var flashButton: RoundedShadowButton!
    @IBOutlet weak var identificationLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    @IBOutlet weak var roundedLabelView: RoundedShadowView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        previewLayer.frame =  cameraView.bounds // set frame within cameraView
        speechSythesizer.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Gest
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCameraView))
        tap.numberOfTapsRequired = 1
        
        
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
                
                //gest
                cameraView.addGestureRecognizer(tap)
                
                
                captureSession.startRunning()
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
    }
    
    
    @objc func didTapCameraView(){
        let settings = AVCapturePhotoSettings()
        
        
        
        // tiny thumbnail in the right
        settings.previewPhotoFormat = settings.embeddedThumbnailPhotoFormat
        
        if flashControlState == .off{
            settings.flashMode = .off
        }else{
            settings.flashMode = .on
        }
        
        cameraOutput.capturePhoto(with: settings, delegate: self)
        
    }
    
    func resultsMethod(request: VNRequest, error: Error?){
        //handle chaning the label text
        guard let results = request.results as? [VNClassificationObservation] else {
            return
        }
//        print("RESULTS",results)
        identificationLabel.text = "Please try again"
        confidenceLabel.text = "YO"

        for classification in results{

            confidenceLabel.text = "YO"
            if classification.confidence < 0.5{
                let unknownObjectMessage = "Please try again, not sure what is that"
                identificationLabel.text = unknownObjectMessage
                synthesizeSpeech(fromString: unknownObjectMessage)
                confidenceLabel.text = ""
                break
            }else{
                let identificationResult = classification.identifier
                let confidenceResult = Int(classification.confidence*100)
                identificationLabel.text = identificationResult
                confidenceLabel.text = "CONFIDENCE: \(confidenceResult)%"
                let completeSenteceResult = "This looks like a \(identificationResult) and I'm \(confidenceResult) percent confident."
                synthesizeSpeech(fromString: completeSenteceResult)
                break
            }
            
            
        }
        
    }
    
    
    func synthesizeSpeech(fromString string: String){
        let speechUtterance = AVSpeechUtterance(string: string)
        speechSythesizer.speak(speechUtterance)
        
    }
    
    
    
    @IBAction func flashButtonTapped(_ sender: UIButton) {
        switch flashControlState {
        case .off:
            flashButton.setTitle("FLASH ON", for: .normal)
            flashControlState = .on
        case .on:
            flashButton.setTitle("FLASH OFF", for: .normal)
            flashControlState = .off
        }
        
        
    }
    
    
}


extension CameraViewController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error{
            debugPrint(error)
        }else{
            
            // pass photoData to the CoreML model(SqueezNet)
            photoData = photo.fileDataRepresentation()
            do{
                let model = try VNCoreMLModel(for: SqueezeNet().model)
                let request = VNCoreMLRequest(model: model, completionHandler: resultsMethod(request:error:))
                let handler = VNImageRequestHandler(data: photoData!)
                try handler.perform([request])
                
                
            }catch{
                debugPrint(error)
                
            }
            
            
            let image = UIImage(data: photoData!)
            
            captureImageView.image = image
        }
        
    }
    
    
}


extension CameraViewController: AVSpeechSynthesizerDelegate{
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // code to finish utterance
    }
    
    
}

