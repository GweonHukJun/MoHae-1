//
//  PeopleQuestionView.swift
//  Mohae
//
//  Created by 이주영 on 2019/10/30.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
// 2. 함께하는 인원은 몇 명인가요? -> 1 ~ 2명/ 3 ~ 5명/ 6명 이상 => 3 개
protocol PeopleQuestionButtonDelegat {
    func touchOneToTwo()
    func touchThreeToFive()
    func touchMoreThanSix()
}

class PeopleQuestionView: UIView {
    var delegate: PeopleQuestionButtonDelegat?
    var surveyScreen: UIView?
    var questionLabel: UILabel?
    var oneToTwoButton: UIButton?
    var threeToFiveButton: UIButton?
    var moreThanSixButton: UIButton?
    
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
        oneToTwoButton = UIButton(type: .system)
        threeToFiveButton = UIButton(type: .system)
        moreThanSixButton = UIButton(type: .system)
        
        if let questionLabel = self.questionLabel {
            questionLabel.translatesAutoresizingMaskIntoConstraints = false
            questionLabel.text = "함께하는 인원은 몇 명인가요?"
            questionLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            questionLabel.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            questionLabel.layer.masksToBounds = true
            questionLabel.layer.cornerRadius = 20
            questionLabel.textAlignment = .center
        }
        
        if let oneToTwoBtn = oneToTwoButton {
            oneToTwoBtn.translatesAutoresizingMaskIntoConstraints = false
            oneToTwoBtn.setTitle("1 명 ~ 2 명", for: .normal)
            oneToTwoBtn.layer.borderColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            oneToTwoBtn.tintColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            oneToTwoBtn.layer.cornerRadius = 10
            oneToTwoBtn.layer.borderWidth = 2
            oneToTwoBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            oneToTwoBtn.sizeToFit()
            oneToTwoBtn.addTarget(self, action: #selector(touchedOneToTwo), for: .touchUpInside)
        }
        
        if let threeToFiveBtn = threeToFiveButton {
            threeToFiveBtn.translatesAutoresizingMaskIntoConstraints = false
            threeToFiveBtn.setTitle("3 명 ~ 5 명", for: .normal)
            threeToFiveBtn.layer.borderColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            threeToFiveBtn.tintColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            threeToFiveBtn.layer.cornerRadius = 10
            threeToFiveBtn.layer.borderWidth = 2
            threeToFiveBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            threeToFiveBtn.sizeToFit()
            threeToFiveBtn.addTarget(self, action: #selector(touchedThreeToFive), for: .touchUpInside)
        }
        
        if let moreThanSixBtn = moreThanSixButton {
            moreThanSixBtn.translatesAutoresizingMaskIntoConstraints = false
            moreThanSixBtn.setTitle("6 명 이상", for: .normal)
            moreThanSixBtn.layer.borderColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            moreThanSixBtn.tintColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            moreThanSixBtn.layer.cornerRadius = 10
            moreThanSixBtn.layer.borderWidth = 2
            moreThanSixBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            moreThanSixBtn.sizeToFit()
            moreThanSixBtn.addTarget(self, action: #selector(touchedMoreThanSix), for: .touchUpInside)
        }
        
        if let screen = surveyScreen {
            screen.translatesAutoresizingMaskIntoConstraints = false
            screen.backgroundColor = .white
            
            if let oneToTwoBtn = oneToTwoButton, let threeToFiveBtn = threeToFiveButton, let moreThanSixBtn = moreThanSixButton, let questionLabel = self.questionLabel {
                
                screen.addSubview(questionLabel)
                screen.addSubview(oneToTwoBtn)
                screen.addSubview(threeToFiveBtn)
                screen.addSubview(moreThanSixBtn)
            }
            
            self.addSubview(screen)
         }
    }
    
    @objc func touchedOneToTwo() {
        delegate?.touchOneToTwo()
    }
    
    @objc func touchedThreeToFive() {
        delegate?.touchThreeToFive()
    }
    
    @objc func touchedMoreThanSix() {
        delegate?.touchMoreThanSix()
    }
}
