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
    @IBOutlet weak var displayDescriptions: UILabel!
    
    private var brain = CalculatorBrain()
    
    var isUserInMiddleTyping: Bool = false
    
    var disPlayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if isUserInMiddleTyping {
            let currentDisplayText = display.text!
            display.text = (digit == "." && currentDisplayText.contains(".")) ? currentDisplayText : currentDisplayText + digit
        }
        else {
            display.text = (digit == ".") ? "0" + digit : digit
            isUserInMiddleTyping = true
        }
    }
    
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
        
        if let resultDescription = brain.descriptions {
            if brain.resultsPending {
                displayDescriptions.text = resultDescription + "..."
            }
            else{
                displayDescriptions.text = resultDescription + "="
            }
        }
        else{
            displayDescriptions.text = " "
        }
    }
}

