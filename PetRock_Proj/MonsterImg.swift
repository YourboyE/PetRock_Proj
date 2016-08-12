//
//  MonsterImg.swift
//  PetRock_Proj
//
//  Created by Edward Garcia on 8/11/16.
//  Copyright © 2016 Edward Garcia. All rights reserved.
//

import Foundation
import UIKit

class MonsterImg: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playIdleAnimation()
    }
    
    func playIdleAnimation() {
        
        self.image = UIImage(named: "idle1.png")
        self.animationImages = nil
        
        var imageArr = [UIImage]() // create an empty array
        
        for x in 1...4 {                               // use a 4 loop to call in the images
            let img = UIImage(named: "idle\(x).png")
            imageArr.append(img!)                       // save the images in the loop
        }
        
        self.animationImages = imageArr
        self.animationImages = imageArr           // use these commands to set up the animation
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
        
    }
    
    func playDeathAnimation() {
        
        self.image = UIImage(named: "dead5.png")
        self.animationImages = nil
        
        var imageArr = [UIImage]() // create an empty array
        
        for x in 1...5 {                               // use a 4 loop to call in the images
            let img = UIImage(named: "dead\(x).png")
            imageArr.append(img!)                       // save the images in the loop
        }
        
        self.animationImages = imageArr
        self.animationImages = imageArr           // use these commands to set up the animation
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
    }
}
    