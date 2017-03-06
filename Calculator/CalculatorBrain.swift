//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by WEI-SHUO LEE on 2017/3/2.
//  Copyright © 2017年 WEI-SHUO LEE. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    var result: Double? {
        get{
            return accumulator
        }
    }
    
    var resultsPending: Bool = false
    
    var descriptions: String = ""
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case AC
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "log" : Operation.unaryOperation(log10),
        "x²" : Operation.unaryOperation({ pow($0, 2) }),
        "±" : Operation.unaryOperation({ -$0 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "−" : Operation.binaryOperation({ $0 - $1 }),
        "×" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "=" : Operation.equals,
        "AC": Operation.AC
    ]
    
    
    mutating func performOperation(_ symbol: String) {
        
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                if resultsPending {
                    descriptions = symbol + "(" + descriptions + String(accumulator!) + ")"
                }
                else{
                    descriptions = symbol
                }
                
            case .unaryOperation(let function):
                if accumulator != nil {
                    //descriptions = symbol + "(" + descriptions + ")"                    
                    descriptions = symbol + "(" + (descriptions.contains("=") ? descriptions.substring(to: descriptions.index(before: descriptions.endIndex)) : descriptions) + ")" + "="
                    accumulator = function(accumulator!)
                    
                }
            case .binaryOperation(let function):
                resultsPending = true
                if accumulator != nil {
                    if resultsPending {
                        performPendingBinaryOperation()
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    }
                    else{
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    }
                    
                    let currentDescription = descriptions
                    descriptions = currentDescription + String(accumulator!) + symbol
                    accumulator = nil
                }
            case .equals:
                let currentDescription = descriptions
                descriptions =  currentDescription + String(accumulator!) + symbol
                performPendingBinaryOperation()
                resultsPending = false
            case .AC:
                descriptions = " "
                resultsPending = false
                pendingBinaryOperation = nil
                accumulator = nil
            }
            
            
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
        
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    
}
