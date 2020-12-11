//
//  ViewController.swift
//  ItemVisionApp
//
//  Created by Veldanov, Anton on 12/10/20.
//

import UIKit

class CameraViewController: UIViewController {

    @IBOutlet weak var cameraView: RoundedShadowView!
    @IBOutlet weak var captureImageView: UIImageView!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var identificationLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
}

