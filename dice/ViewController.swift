//
//  ViewController.swift
//  dice
//
//  Created by 蕭鈺蒖 on 2021/12/15.
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet weak var SumLabel: UILabel!
    @IBOutlet weak var DiceLabel: UILabel!
    @IBOutlet weak var DiceStepper: UIStepper!
    
    var numOfDice:Int = 1
    var prevNumOfDice: Int = 1
    
    
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
    
    func getRandomPosition() -> (Int, Int){
        var x = Int.random(in: 30...370)
        var y = Int.random(in: 50...630)
//        print("orig x \(x), orgin y \(y)")
        while x > 50, x < 345,
                y > 230, y < 400 {
            x = Int.random(in: 30...370)
            y = Int.random(in: 50...630)
//            print("while x \(x), while y \(y)")
        }
        return (x,y)
    }
    
    
    @IBAction func roll(_ sender: UIButton) {
        cleanDice()
        
        
        numOfDice = Int(DiceStepper.value)
        prevNumOfDice = numOfDice
        var sum = 0
        
        var diceArray :[Int] = []
        // genterate the random int
        for i in 1...numOfDice{
            let diceValue = Int.random(in: 1...6)
            diceArray.append(diceValue)
            
            let diceImageView = UIImageView(image: UIImage(systemName: "die.face.\(diceValue).fill"))
            
            let randomPosition = getRandomPosition()
            diceImageView.frame = CGRect(x: randomPosition.0 , y: randomPosition.1, width: 65, height: 65)
            
            diceImageView.tintColor = UIColor.black
            diceImageView.tag = i
            
            
            view.addSubview(diceImageView)
            
            moveDice(diceImage: diceImageView, xEnd: randomPosition.0, yEnd: randomPosition.1)
            
            sum += diceValue
            
        }
        
        SumLabel.text = "Sum: \(sum)"
        SumLabel.isHidden = false
        self.view.bringSubviewToFront(SumLabel)
        
        var imageIndex = 0
        for diceValue in diceArray.sorted(){
            let smallDiceImageView = UIImageView(image: UIImage(systemName: "die.face.\(diceValue)"))
            print("die.face.\(diceValue)")
            
            
            smallDiceImageView.frame = CGRect(x: 77 + 44 * imageIndex, y: 327 , width: 40, height: 40)
            
            smallDiceImageView.tintColor = UIColor.white
            
            smallDiceImageView.tag = imageIndex + 7
            imageIndex += 1
            view.addSubview(smallDiceImageView)
            self.view.bringSubviewToFront(smallDiceImageView)
        }
//        let sumLabel = UILabel(frame: CGRect(x: 130, y: 300, width: 155, height: 80))
//
//        sumLabel.alpha = 0.75
//        sumLabel.isOpaque = true
//        sumLabel.layer.cornerRadius = 15
//        sumLabel.numberOfLines = 0
//        sumLabel.textColor = .white
//        sumLabel.backgroundColor = .black
//        sumLabel.textAlignment = .center
//        sumLabel.font = UIFont(name: "System-Heavy", size: 21.0)
//        sumLabel.text = "Sum:\n\(sum)"
//
//        view.addSubview(sumLabel)
    }
}

