//
//  CoupleQuestionView.swift
//  Mohae
//
//  Created by 이주영 on 2019/10/29.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit

protocol CoupleQuestionButtonDelegate {
    func touchYes()
    func touchNo()
}

class CoupleQuestionView: UIView {
    var delegate: CoupleQuestionButtonDelegate?
    var questionLabel: UILabel?
    var yesButton: UIButton?
    var noButton: UIButton?
    var surveyScreen: UIView?
    var prettyView : UIView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure() {
        questionLabel = UILabel()
        yesButton = UIButton(type: .system)
        noButton = UIButton(type: .system)
        surveyScreen = UIView()
        
        if let questionLabel = self.questionLabel {
            questionLabel.translatesAutoresizingMaskIntoConstraints = false
            questionLabel.text = "연인과 같이 있습니까?"
            questionLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            questionLabel.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            questionLabel.layer.masksToBounds = true
            questionLabel.layer.cornerRadius = 20
            questionLabel.textAlignment = .center
        }
        
        if let yesBtn = yesButton {
            yesBtn.translatesAutoresizingMaskIntoConstraints = false
            yesBtn.setTitle("예", for: .normal)
            yesBtn.tintColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            yesBtn.layer.borderColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            yesBtn.layer.cornerRadius = 10
            yesBtn.layer.borderWidth = 2
            yesBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            yesBtn.sizeToFit()
            yesBtn.addTarget(self, action: #selector(touchedYes), for: .touchUpInside)
        }
        
        if let noBtn = noButton {
            noBtn.translatesAutoresizingMaskIntoConstraints = false
            noBtn.setTitle("아니오", for: .normal)
            noBtn.layer.borderColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            noBtn.tintColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            noBtn.layer.cornerRadius = 10
            noBtn.layer.borderWidth = 2
            noBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            noBtn.sizeToFit()
            noBtn.addTarget(self, action: #selector(touchedNo), for: .touchUpInside)
        }
        
        if let screen = surveyScreen {
            screen.translatesAutoresizingMaskIntoConstraints = false
            screen.backgroundColor = .white
            if let yesBtn = yesButton, let noBtn = noButton, let question = questionLabel {
                screen.addSubview(question)
                screen.addSubview(yesBtn)
                screen.addSubview(noBtn)
            }
            
            self.addSubview(screen)
        }
    }
    
    @objc func touchedYes() {
        delegate?.touchYes()
    }
    
    @objc func touchedNo() {
        delegate?.touchNo()
    }
}
