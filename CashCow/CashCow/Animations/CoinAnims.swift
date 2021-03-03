//
//  CoinAnims.swift
//  CashCow
//
//  Created by Jarod Heng on 3/2/21.
//

import Foundation
import UIKit

// general class for holding sequence of images, like for an animation
class ImgSeqContainer {
    var imageNames: [String]
    var imageSequences: [[UIImage]]
    init() {
        imageNames = []
        imageSequences = [[]]
    }
    
    init(imgNames: [String]) {
        imageNames = imgNames
        imageSequences = [[]]
        for name in imageNames {
            let imageSet = setAnimatedImages(for: name)
            imageSequences.append(imageSet)
        }
        // print(imageSequences)
    }
    
    func setAnimatedImages(for name: String) -> [UIImage] {
        var idx = 0
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(name)_\(String(format: "%02d", idx))") {
            print("\(name)_\(String(format: "%02d", idx))")
            images.append(image)
            idx += 1
        }
        return images
    }
}
