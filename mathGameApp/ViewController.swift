//
//  ViewController.swift
//  mathGameApp
//
//  Created by CheChenLiu on 2021/9/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var leftNumberLabel: UILabel!
    @IBOutlet weak var rightNumberLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var currentIndexLabel: UILabel!

    @IBOutlet var optionButtons: [UIButton]!
    
    private var currentIndex:Int = 0
    private var options = [String]()
    private var option1:Int = 0
    private var option2:Int = 0
    private var option3:Int = 0
    private var leftNumber:Int = 0
    private var rightNumber:Int = 0
    private var symbolArray = ["➕","➖","✖️","➗"]
    private var answer:Int = 0
    private var score:Int = 0
    private var correctCount:Int = 0
    private var consecutiveCorrectCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBoardFrame()
        updateButtonFrame()
    }

    private func updateBoardFrame() {
        
        symbolArray.shuffle()
        
        checkSymbolToMakeAnswer()
        
        symbolLabel.text = symbolArray[0]
        
        options = ["\(answer)", "\(answer + 2)", "\(answer - 1)", "\(answer + 3)"]
        options.shuffle()
        
        for i in 0...3 {
            
            optionButtons[i].setTitle(options[i], for: UIControl.State.normal)
            
        }
        
        leftNumberLabel.text = "\(leftNumber)"
        rightNumberLabel.text = "\(rightNumber)"
        scoreLabel.text = "分數：\(score)分"
        currentIndexLabel.text = "\(currentIndex + 1) / 10題"
        
    }
    
    private func checkSymbolToMakeAnswer() {
        
        if symbolArray[0] == "➕" {
            
            leftNumber = Int.random(in: 1...9)
            rightNumber = Int.random(in: 1...99)
            answer = leftNumber + rightNumber
            
        } else if symbolArray[0] == "➖" {
            
            leftNumber = Int.random(in: 1...99)
            rightNumber = Int.random(in: 1...9)
            
            if rightNumber > leftNumber {
                
                let tempNumber = rightNumber
                rightNumber = leftNumber
                leftNumber = tempNumber
                
            } else if leftNumber == rightNumber {
                
                leftNumber = Int.random(in: 1...99)
                rightNumber = Int.random(in: 1...9)
                
            }
            
            answer = leftNumber - rightNumber
            
        } else if symbolArray[0] == "✖️" {
            
            leftNumber = Int.random(in: 1...9)
            rightNumber = Int.random(in: 1...9)
            answer = leftNumber * rightNumber
            
        } else if symbolArray[0] == "➗" {
            
            rightNumber = Int.random(in: 1...9)
            let tempNumber = Int.random(in: 1...9)
            leftNumber = rightNumber * tempNumber
            answer = leftNumber / rightNumber
            
        }
        
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        
        print("currentIndex =", currentIndex)
        
        if sender.currentTitle == String(answer) {
            
            updateCorrectCountAndCalculateScore()
            
        } else {
            
            if consecutiveCorrectCount < 1 {
                
                consecutiveCorrectCount = 0
                
            } else {
                
                consecutiveCorrectCount -= 1
                
            }
            
            score -= 10
        
        }
        
        currentIndex += 1
        
        let finishAnswer = currentIndex > 9
        
        if finishAnswer {
            
            checkScoreLevel()
            
        } else {
            
            updateBoardFrame()
            
        }
        
    }
    
    private func updateCorrectCountAndCalculateScore() {
        
        correctCount += 1
        consecutiveCorrectCount += 1
        
        if consecutiveCorrectCount >= 3 {
            
            score += 30
            
        } else {
            
            score += 10
            
        }
        
        print("correctCount = ", correctCount)
        print("consecutiveCorrectCount =", consecutiveCorrectCount)
        
    }
    
    private func checkScoreLevel() {
        
        if correctCount > 8 || score > 230 {
            
            showResultAlert(title: "您是算術大師~", message: "答對題數：\(correctCount)\n總共獲得：\(score)分")
            
        } else if correctCount > 5 || score > 180 {
            
            showResultAlert(title: "您是算術專家~", message: "答對題數：\(correctCount)\n總共獲得：\(score)分")
            
        } else if correctCount > 3 || score > 130 {
            
            showResultAlert(title: "您蠻會算數的喔~", message: "答對題數：\(correctCount)\n總共獲得：\(score)分")
            
        } else {
            
            showResultAlert(title: "再多練習一下吧！", message: "答對題數：\(correctCount)\n總共獲得：\(score)分")
            
        }
        
    }
    
    private func showResultAlert(title: String, message: String) {
        
        let resultAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let againAlert = UIAlertAction(title: "Again", style: UIAlertAction.Style.default) { UIAlertAction in
            self.reset()
        }
        
        resultAlert.addAction(againAlert)
        
        self.present(resultAlert, animated: true, completion: nil)
        
    }
    
    private func reset() {
        
        score = 0
        currentIndex = 0
        correctCount = 0
        consecutiveCorrectCount = 0
        currentIndexLabel.text = "\(currentIndex)"
        scoreLabel.text = "\(score)"
        updateBoardFrame()
        
    }
    
    private func updateButtonFrame() {
        
        for button in optionButtons {
            
            button.layer.cornerRadius = 15
            button.layer.backgroundColor = UIColor.yellow.cgColor
            button.layer.borderWidth = 2
            button.tintColor = UIColor.black
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            
        }
        
    }
    
}
