//
//  MoneyQuestionView.swift
//  Mohae
//
//  Created by 이주영 on 2019/10/30.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
// 3. 사용할 돈은 얼마 정도 생각하고 계신가요? -> 무료, 1 ~ 5, 6 ~ 10, 10 이상 => 4 개
protocol MoneyQuestionButtonDelegate {
    func touchFree()
    func touchOneToFive()
    func touchSixToTen()
    func touchMoreThanTen()
}

class MoneyQuestionView: UIView {
    var delegate: MoneyQuestionButtonDelegate?
    var surveyScreen: UIView?
    var questionLabel: UILabel?
    var freeButton: UIButton?
    var oneToFiveButton: UIButton?
    var sixToTenButton: UIButton?
    var moreThanTenButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    override required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure() {
        surveyScreen = UIView()
        questionLabel = UILabel()
        freeButton = UIButton(type: .system)
        oneToFiveButton = UIButton(type: .system)
        sixToTenButton = UIButton(type: .system)
        moreThanTenButton = UIButton(type: .system)
        
        if let questionLabel = self.questionLabel {
            questionLabel.translatesAutoresizingMaskIntoConstraints = false
            questionLabel.text = "사용할 돈은 얼마 정도 생각하고 계신가요?"
            questionLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            questionLabel.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            questionLabel.layer.masksToBounds = true
            questionLabel.layer.cornerRadius = 20
            questionLabel.textAlignment = .center
        }
        
        if let freeBtn = freeButton {
            freeBtn.translatesAutoresizingMaskIntoConstraints = false
            freeBtn.sizeToFit()
            freeBtn.setTitle("무료", for: .normal)
            freeBtn.layer.borderColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            freeBtn.tintColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            freeBtn.layer.cornerRadius = 10
            freeBtn.layer.borderWidth = 2
            freeBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            freeBtn.addTarget(self, action: #selector(touchedFree), for: .touchUpInside)
        }
        
        if let oneToFiveBtn = oneToFiveButton {
            oneToFiveBtn.translatesAutoresizingMaskIntoConstraints = false
            oneToFiveBtn.sizeToFit()
            oneToFiveBtn.setTitle("1 만 원 ~ 5 만 원", for: .normal)
            oneToFiveBtn.layer.borderColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            oneToFiveBtn.tintColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            oneToFiveBtn.layer.cornerRadius = 10
            oneToFiveBtn.layer.borderWidth = 2
            oneToFiveBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            oneToFiveBtn.addTarget(self, action: #selector(touchedOneToFive), for: .touchUpInside)
        }
        
        if let sixToTenBtn = sixToTenButton {
            sixToTenBtn.translatesAutoresizingMaskIntoConstraints = false
            sixToTenBtn.sizeToFit()
            sixToTenBtn.setTitle("6 만 원 ~ 10 만 원", for: .normal)
            sixToTenBtn.layer.borderColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            sixToTenBtn.tintColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            sixToTenBtn.layer.cornerRadius = 10
            sixToTenBtn.layer.borderWidth = 2
            sixToTenBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            sixToTenBtn.addTarget(self, action: #selector(touchedSixToTen), for: .touchUpInside)
        }
        
        if let moreThanTenBtn = moreThanTenButton {
            moreThanTenBtn.translatesAutoresizingMaskIntoConstraints = false
            moreThanTenBtn.sizeToFit()
            moreThanTenBtn.setTitle("10 만 원 이상", for: .normal)
            moreThanTenBtn.layer.borderColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            moreThanTenBtn.tintColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            moreThanTenBtn.layer.cornerRadius = 10
            moreThanTenBtn.layer.borderWidth = 2
            moreThanTenBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            moreThanTenBtn.addTarget(self, action: #selector(touchedMoreThanTen), for: .touchUpInside)
        }
        
        if let screen = surveyScreen {
            screen.translatesAutoresizingMaskIntoConstraints = false
            screen.backgroundColor = .white
            
            if let freeBtn = freeButton, let oneToFiveBtn = oneToFiveButton, let sixToTenBtn = sixToTenButton, let moreThanTenBtn = moreThanTenButton, let questionLabel = self.questionLabel {
                
                screen.addSubview(questionLabel)
                screen.addSubview(freeBtn)
                screen.addSubview(oneToFiveBtn)
                screen.addSubview(sixToTenBtn)
                screen.addSubview(moreThanTenBtn)
            }
            
            self.addSubview(screen)
        }
    }
    
    @objc func touchedFree() {
        delegate?.touchFree()
    }
    
    @objc func touchedOneToFive() {
        delegate?.touchOneToFive()
    }
    
    @objc func touchedSixToTen() {
        delegate?.touchSixToTen()
    }
    
    @objc func touchedMoreThanTen() {
        delegate?.touchMoreThanTen()
    }
}
