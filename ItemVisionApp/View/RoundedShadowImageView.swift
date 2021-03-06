//
//  RoundedImageView.swift
//  ItemVisionApp
//
//  Created by Veldanov, Anton on 12/10/20.
//

import UIKit

class RoundedShadowImageView: UIImageView {

    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.green.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.40
        self.layer.cornerRadius = self.frame.height/2
//        self.layer.masksToBounds = true
        self.clipsToBounds = false
    }

}
