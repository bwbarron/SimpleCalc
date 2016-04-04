//
//  main.swift
//  simplecalc
//
//  Created by Barron, Brandon on 4/3/16.
//  Copyright © 2016 Barron, Brandon. All rights reserved.
//

import Foundation


// add number formatting to strings
extension String {
    struct NumberFormatter {
        static let instance = NSNumberFormatter()
    }
    var intValue : Int? {
        return NumberFormatter.instance.numberFromString(self)?.integerValue
    }
}

// store possible operators
let basicOps = NSSet(array: ["+", "-", "*", "/", "%"])
let operators = NSSet(array: ["count", "avg", "fact"])

let errMsg = "please enter operation in the correct format"


// prints error message and exits program
func err(msg : String) {
    print(msg)
    exit(1)
}


// validates an operation's elements
func validOp(operation : [String]) -> Bool {
    for elem in operation {
        if !basicOps.containsObject(elem) && !operators.containsObject(elem) && elem.intValue == nil {
            return false
        }
    }
    return true
}


// reads input until a full operation is given
func readFullOp() -> [String] {
    print("Enter an expression:")
    var operation = [String]()
    var opIsComplete = false
    
    // build operation from inputs
    while !opIsComplete {
        let args = readLine(stripNewline: true)!.characters.split(" ").map(String.init)
        if args.count == 1 {
            // exit program
            if args[0] == "exit" { return [args[0]] }
            
            // add operand or operator to expression
            operation.append(args[0])
            if operation.count == 3 {
                basicOps.containsObject(operation[1]) ? opIsComplete = true : err(errMsg)
            }
        } else if !args.isEmpty && operators.containsObject(args.last!) {
            if args.count >= 2 {
                // factorial operation only takes in one number
                if args.last! == "fact" && args.count != 2 { err(errMsg) }
                
                operation = args
                opIsComplete = true
            }
        } else {
            err(errMsg)
        }
    }
    
    if !validOp(operation) { err(errMsg) }
    return operation
}


// sums elements in array of strings
func sum(nums : [String]) -> Int {
    var result = 0
    for elem in nums {
        result += elem.intValue!
    }
    return result
}


// calculates the result of the given operation
func calculate(operation : [String]) -> Int {
    var result = Int()
    let operandSet = NSSet(array: operation)
    if operandSet.intersectsSet(basicOps as Set<NSObject>) { // basic operation
        let operand1 = operation[0].intValue!
        let operand2 = operation[2].intValue!
        switch operation[1] {
        case "+":
            result = operand1 + operand2
        case "-":
            result = operand1 - operand2
        case "*":
            result = operand1 * operand2
        case "/":
            result = operand1 / operand2
        case "%":
            result = operand1 % operand2
        default:
            err("error calculating result")
        }
    } else if operandSet.intersectsSet(operators as Set<NSObject>) { // extended operation
        switch operation.last! {
        case "count":
            result = sum(Array(operation[0 ..< operation.endIndex - 1]))
        case "avg":
            result = sum(Array(operation[0 ..< operation.endIndex - 1])) / (operation.count - 1)
        case "fact":
            result = 1
            for i in 1 ... operation[0].intValue! {
                result *= i
            }
        default:
            err("error calculating result")
        }
    }
    
    return result
}


var input = [String]()

// read input and calculate results until user exits
repeat {
    input = readFullOp()
    var result = calculate(input)
    
    //print("-------------------------")
    print("\n\(result)")
    print("-------------------------\n")
} while input[0] != "exit"

