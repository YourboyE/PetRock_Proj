//
//  ViewController.swift
//  PetRock_Proj
//
//  Created by Edward Garcia on 8/11/16.
//  Copyright © 2016 Edward Garcia. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var monsterImg: MonsterImg! // name the animation
    @IBOutlet weak var livesPanel: UIImageView!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penatly3Img: UIImageView!
    @IBOutlet weak var tryAgainBtn: UIButton!
    @IBOutlet weak var rockImg: DragImg!
    @IBOutlet weak var rockPetSelectionBtn: UIButton!
    @IBOutlet weak var gopherPetSelectionBtn: UIButton!
    @IBOutlet weak var chooseYourTitle: UIImageView!
    @IBOutlet weak var playerTitle: UIImageView!
    
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = true
    var currentItem: UInt32 = 0
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    var sfxRock: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        


}
    @IBAction func onGopherPetSelectionBtnTapped(sender: AnyObject) {
        
        
        
    }
    
    @IBAction func onRockSelectionBtnTapped(sender: AnyObject) {
        
        hideIntro()
        showRockPet()
        monsterImg.playIdleAnimation()
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        rockImg.dropTarget = monsterImg
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penatly3Img.alpha = DIM_ALPHA
        
        tryAgainBtn.hidden = true
        
        changeGameState()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.itemDroppedOnCharacter(_:)), name: "onTargetDropped", object: nil)
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            try sfxRock = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("powerup", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxSkull.prepareToPlay()
            sfxRock.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        startTimer()
        
    }
    

    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        rockImg.alpha = DIM_ALPHA
        rockImg.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxBite.play()
            monsterImg.playIdleAnimation()
            
        } else if currentItem == 1 {
            sfxHeart.play()
            monsterImg.playIdleAnimation()
        } else {
            sfxRock.play()
            monsterImg.playAttackAnimation()
        }
       
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
    }
    
    func changeGameState(){
        
        
        if !monsterHappy {
            
            penalties = penalties+1
            sfxSkull.play()
            
            if penalties == 1 {
                penalty1Img.alpha = OPAQUE
                penalty2Img.alpha = DIM_ALPHA
            } else if penalties == 2 {
                penalty2Img.alpha = OPAQUE
                penatly3Img.alpha = DIM_ALPHA
            } else if penalties >= 3 {
                penatly3Img.alpha = OPAQUE
            } else {
                penalty1Img.alpha = DIM_ALPHA
                penalty2Img.alpha = DIM_ALPHA
                penatly3Img.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTIES {
                gameOver()
            }

        }
        
        let rand = arc4random_uniform(3) // 0 or 1
                
        if rand == 0 {
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
            
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            rockImg.alpha = DIM_ALPHA
            rockImg.userInteractionEnabled = false
        } else if rand == 1 {
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
            
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            rockImg.alpha = DIM_ALPHA
            rockImg.userInteractionEnabled = false
        } else {
            rockImg.alpha = OPAQUE
            rockImg.userInteractionEnabled = true
            
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
        }
        
        currentItem = rand
        monsterHappy = false
        
    }
    
    func gameOver() {
        timer.invalidate()
        tryAgainBtn.hidden = false
        monsterImg.playDeathAnimation()
        musicPlayer.stop()
        sfxDeath.play()
        
    }
     @IBAction func onTryAgainBtnPressed(sender: AnyObject) {
        restartGame()

    }
    func hideIntro(){
        chooseYourTitle.hidden = true
        playerTitle.hidden = true
        rockPetSelectionBtn.hidden = true
        gopherPetSelectionBtn.hidden = true
    }
    
    func showRockPet() {
        monsterImg.hidden = false
        livesPanel.hidden = false
        penalty1Img.hidden = false
        penalty2Img.hidden = false
        penatly3Img.hidden = false
        foodImg.hidden = false
        heartImg.hidden = false
        rockImg.hidden = false
        
        
    }
    
    func restartGame(){
        
        chooseYourTitle.hidden = false
        playerTitle.hidden = false
        rockPetSelectionBtn.hidden = false
        gopherPetSelectionBtn.hidden = false
        
        
        monsterImg.hidden = true
        livesPanel.hidden = true
        penalty1Img.hidden = true
        penalty2Img.hidden = true
        penatly3Img.hidden = true
        foodImg.hidden = true
        heartImg.hidden = true
        rockImg.hidden = true
        tryAgainBtn.hidden = true
    }
    
}