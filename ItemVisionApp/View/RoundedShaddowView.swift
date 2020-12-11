//
//  RoundedShaddowView.swift
//  ItemVisionApp
//
//  Created by Veldanov, Anton on 12/10/20.
//

import UIKit

class RoundedShadowView: UIView {

    override class func awakeFromNib() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 15
    }

}
