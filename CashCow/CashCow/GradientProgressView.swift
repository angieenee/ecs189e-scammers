//
//  GradientProgressView.swift
//  CashCow
//
//  Created by Angie Ni on 2/17/21.
//

import UIKit

class GradientProgressView: UIProgressView {
    
    @IBInspectable var firstColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.black {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
                
        if let gradientImage = UIImage(bounds: self.bounds, colors: [firstColor, secondColor]) {
            self.progressImage = gradientImage
        }
    }
}
