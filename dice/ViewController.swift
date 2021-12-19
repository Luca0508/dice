//
//  ViewController.swift
//  dice
//
//  Created by 蕭鈺蒖 on 2021/12/15.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    
    
    @IBOutlet weak var SumLabel: UILabel!
    @IBOutlet weak var DiceLabel: UILabel!
    @IBOutlet weak var DiceStepper: UIStepper!
    
    var numOfDice:Int = 1
    var prevNumOfDice: Int = 1
    let player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DiceStepper.value = 1
        DiceLabel.text = Int(DiceStepper.value).description
        
        // Do any additional setup after loading the view.
    }


    @IBAction func getNumberOfDices(_ sender: UIStepper) {
        DiceLabel.text = Int(sender.value).description
        
        SumLabel.isHidden = true
        cleanDice()
    }
    
    func cleanDice(){
        for subView in view.subviews{
            for prev in 1...(prevNumOfDice + 6){
                if let subView = subView.viewWithTag(prev){
                    subView.removeFromSuperview()
                }
            }
        }
    }
    
    
    func moveDice(diceImage :UIImageView, xEnd: Int, yEnd:Int){
        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.fromValue = [Int.random(in: 20...370), Int.random(in: 30...630)]
        
        
        moveAnimation.toValue = [xEnd, yEnd]
        
        moveAnimation.duration = 1.5
        
        moveAnimation.fillMode = .forwards
        moveAnimation.isRemovedOnCompletion = false
       
        
        diceImage.layer.add(moveAnimation, forKey: nil)
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = Double.pi*2
        rotateAnimation.duration = 1.5
        
        rotateAnimation.fillMode = .forwards
        rotateAnimation.isRemovedOnCompletion = false
        diceImage.layer.add(rotateAnimation, forKey: nil)
        
    }
    
    func getRandomPosition(positionArray:Array<CGRect>) -> (Int, Int){
        var x = Int.random(in: 30...370)
        var y = Int.random(in: 60...630)
        
        var arrayIndex = 0
        while arrayIndex < positionArray.count{
            if positionArray[arrayIndex].intersection(CGRect(x: x, y: y, width: 65, height:65)).isNull{
                arrayIndex += 1
            }else{
                x = Int.random(in: 30...370)
                y = Int.random(in: 60...630)
                arrayIndex = 0
            }
        }
        
        return (x,y)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake{
            cleanDice()
            makeDiceRoll()
            addSoundEffect()
        }
    }
    
    func makeDiceRoll(){
        numOfDice = Int(DiceStepper.value)
        prevNumOfDice = numOfDice
        var sum = 0
        
        var diceArray :[Int] = []
        var positionArray :[CGRect] = [SumLabel.frame]
        // genterate the random int
        for i in 1...numOfDice{
            let diceValue = Int.random(in: 1...6)
            diceArray.append(diceValue)
            
            let diceImageView = UIImageView(image: UIImage(systemName: "die.face.\(diceValue).fill"))
            
            let randomPosition = getRandomPosition(positionArray: positionArray)
            diceImageView.frame = CGRect(x: randomPosition.0 , y: randomPosition.1, width: 65, height: 65)
            positionArray.append(diceImageView.frame)
            
            
            diceImageView.tintColor = UIColor.black
            
            // create the tag for removing the imageView later
            diceImageView.tag = i
            
            
            view.addSubview(diceImageView)
            
            moveDice(diceImage: diceImageView, xEnd: randomPosition.0, yEnd: randomPosition.1)
            
            sum += diceValue
            
        }
        
        SumLabel.text = "Sum: \(sum)\n\n"
        SumLabel.isHidden = false
        self.view.bringSubviewToFront(SumLabel)
        
        
        // for the small dice in the SumLabel
        var imageIndex = 0
        for diceValue in diceArray.sorted(){
            let smallDiceImageView = UIImageView(image: UIImage(systemName: "die.face.\(diceValue)"))
            
            // setting the position for small dice by imageIndex
            smallDiceImageView.frame = CGRect(x: 77 + 44 * imageIndex, y: 327 , width: 40, height: 40)
            
            smallDiceImageView.tintColor = UIColor.white
            
            smallDiceImageView.tag = imageIndex + 7
            imageIndex += 1
            view.addSubview(smallDiceImageView)
            self.view.bringSubviewToFront(smallDiceImageView)
        }
    }
    
    // add sound effect while rolling the dice
    func addSoundEffect(){
        
        let fileUrl = Bundle.main.url(forResource: "rollDiceSound", withExtension: "mp3")
        player.replaceCurrentItem(with: AVPlayerItem(url: fileUrl!))
        player.volume = 0.9
        player.play()
    }
    
    @IBAction func roll(_ sender: UIButton) {
        
        cleanDice()
        makeDiceRoll()
        addSoundEffect()
        
    }
    
    
}

