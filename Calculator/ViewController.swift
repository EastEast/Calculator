//
//  ViewController.swift
//  Calculator
//
//  Created by WEI-SHUO LEE on 2017/3/2.
//  Copyright © 2017年 WEI-SHUO LEE. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var display: UILabel!

    var isUserInMiddleTyping: Bool = false
    
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if isUserInMiddleTyping {
            let currentDisplayText = display.text!
            display.text = currentDisplayText + digit
        }
        else {
            display.text = digit
            isUserInMiddleTyping = true
        }
        
    }
    
    var disPlayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if isUserInMiddleTyping {
            brain.setOperand(disPlayValue)
            isUserInMiddleTyping = false
        }
        
        if let mathmaticalSymbol = sender.currentTitle {
            brain.performOperation(mathmaticalSymbol)
        }
        
        if let result = brain.result {
            disPlayValue = result
        }
        
    }


}

