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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DiceStepper.value = 1
        DiceLabel.text = Int(DiceStepper.value).description
        // Do any additional setup after loading the view.
    }


    @IBAction func getNumberOfDices(_ sender: UIStepper) {
        DiceLabel.text = Int(sender.value).description
        
        SumLabel.isHidden = true
    }
    
    
    @IBAction func roll(_ sender: UIButton) {
        numOfDice = Int(DiceStepper.value)
        var sum = 0
        
        // genterate the random int
        for i in 1...numOfDice{
            let diceValue = Int.random(in: 1...6)
            print(diceValue)
            sum += diceValue
            let diceIndex = i
        }
        print(sum)
        SumLabel.text = "Sum:\n\(sum)"
        SumLabel.isHidden = false
    }
}

