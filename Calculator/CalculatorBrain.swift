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
    
    var descriptions: String?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case allClear
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
        "AC": Operation.allClear
    ]
    
    mutating func performOperation(_ symbol: String) {
        
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                descriptions = symbol
            case .unaryOperation(let function):
                if accumulator != nil {
                    if !resultsPending {
                        descriptions = symbol + "(" + descriptions! + ")"
                    }
                    else {
                        print(descriptions!)
                        descriptions = descriptions! + symbol + "(" + String(accumulator!) + ")"
                    }
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    if resultsPending {
                        performPendingBinaryOperation()
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    }
                    else{
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    }
                    descriptions = descriptions! + symbol
                    accumulator = nil
                    resultsPending = true
                }
            case .equals:
                performPendingBinaryOperation()
                resultsPending = false
            case .allClear:
                descriptions = " "
                resultsPending = false
                pendingBinaryOperation = nil
                accumulator = 0.0
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
        
        if descriptions != nil {
            descriptions = descriptions! + String(accumulator!)
        }
        else{
            descriptions = String(accumulator!)
        }
        
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    
}
