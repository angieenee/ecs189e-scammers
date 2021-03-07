//
//  GradientProgressView.swift
//  CashCow
//
//  GradientProgressView credited to Rodrigo Giglio
// https://medium.com/academy-poa/how-to-create-a-uiprogressview-with-gradient-progress-in-swift-2d1fa7d26f24
//
//

import UIKit

class GradientProgressView: UIProgressView {
    
    @IBInspectable var firstColor: UIColor = UIColor.red {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.green {
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
