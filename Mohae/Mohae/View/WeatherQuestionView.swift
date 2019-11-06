//
//  WeatherQuestionView.swift
//  Mohae
//
//  Created by 이주영 on 2019/10/30.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
// 4. 현재 날씨는 어떤가요? -> 맑음, 흐림, 비, 눈, 자연재해 => 5 개
protocol WeatherQuestionButtonDelegate {
    func touchSunny()
    func touchCloudy()
    func touchRain()
    func touchSnow()
    func touchDisaster()
}

class WeatherQuestionView: UIView {
    var delegate: WeatherQuestionButtonDelegate?
    var surveyScreen: UIView?
    var questionLabel: UILabel?
    var sunnyButton: UIButton?
    var cloudyButton: UIButton?
    var rainButton: UIButton?
    var snowButton: UIButton?
    var disasterButton: UIButton?
    
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
        sunnyButton = UIButton(type: .system)
        cloudyButton = UIButton(type: .system)
        rainButton = UIButton(type: .system)
        snowButton = UIButton(type: .system)
        disasterButton = UIButton(type: .system)
        
        if let questionLabel = self.questionLabel {
            questionLabel.translatesAutoresizingMaskIntoConstraints = false
            questionLabel.text = "현재 날씨는 어떤가요?"
            questionLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            questionLabel.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            questionLabel.layer.masksToBounds = true
            questionLabel.layer.cornerRadius = 20
            questionLabel.textAlignment = .center
        }
        
        if let sunnyBtn = sunnyButton {
            sunnyBtn.translatesAutoresizingMaskIntoConstraints = false
            sunnyBtn.setTitle("맑음", for: .normal)
            sunnyBtn.layer.borderColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
                 sunnyBtn.tintColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
                 sunnyBtn.layer.cornerRadius = 10
                 sunnyBtn.layer.borderWidth = 2
                 sunnyBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            sunnyBtn.addTarget(self, action: #selector(touchedSunny), for: .touchUpInside)
        }
        
        if let cloudyBtn = cloudyButton {
            cloudyBtn.translatesAutoresizingMaskIntoConstraints = false
            cloudyBtn.setTitle("흐림", for: .normal)
            cloudyBtn.layer.borderColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
                 cloudyBtn.tintColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
                 cloudyBtn.layer.cornerRadius = 10
                 cloudyBtn.layer.borderWidth = 2
                 cloudyBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cloudyBtn.addTarget(self, action: #selector(touchedCloudy), for: .touchUpInside)
        }
        
        if let rainBtn = rainButton {
            rainBtn.translatesAutoresizingMaskIntoConstraints = false
            rainBtn.setTitle("비", for: .normal)
            rainBtn.layer.borderColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
                 rainBtn.tintColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
                 rainBtn.layer.cornerRadius = 10
                 rainBtn.layer.borderWidth = 2
                 rainBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            rainBtn.addTarget(self, action: #selector(touchedRain), for: .touchUpInside)
        }
        
        if let snowBtn = snowButton {
            snowBtn.translatesAutoresizingMaskIntoConstraints = false
            snowBtn.setTitle("눈", for: .normal)
            snowBtn.layer.borderColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            snowBtn.tintColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            snowBtn.layer.cornerRadius = 10
            snowBtn.layer.borderWidth = 2
            snowBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            snowBtn.addTarget(self, action: #selector(touchedSnow), for: .touchUpInside)
        }
        
        if let disasterBtn = disasterButton {
            disasterBtn.translatesAutoresizingMaskIntoConstraints = false
            disasterBtn.setTitle("자연재해", for: .normal)
            disasterBtn.layer.borderColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            disasterBtn.tintColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
            disasterBtn.layer.cornerRadius = 10
            disasterBtn.layer.borderWidth = 2
            disasterBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            disasterBtn.addTarget(self, action: #selector(touchedDisaster), for: .touchUpInside)
        }
        
        if let screen = surveyScreen {
            screen.translatesAutoresizingMaskIntoConstraints = false
            screen.backgroundColor = .white
            
            if let sunnyBtn = sunnyButton, let cloudyBtn = cloudyButton, let rainBtn = rainButton, let snowBtn = snowButton, let disasterBtn = disasterButton, let questionLabel = self.questionLabel {
                screen.addSubview(questionLabel)
                screen.addSubview(sunnyBtn)
                screen.addSubview(cloudyBtn)
                screen.addSubview(rainBtn)
                screen.addSubview(snowBtn)
                screen.addSubview(disasterBtn)
            }
            
            self.addSubview(screen)
        }
    }
    
    @objc func touchedSunny() {
        delegate?.touchSunny()
    }
    
    @objc func touchedCloudy() {
        delegate?.touchCloudy()
    }
    
    @objc func touchedRain() {
        delegate?.touchRain()
    }
    
    @objc func touchedSnow() {
        delegate?.touchSnow()
    }
    
    @objc func touchedDisaster() {
        delegate?.touchDisaster()
    }
}
