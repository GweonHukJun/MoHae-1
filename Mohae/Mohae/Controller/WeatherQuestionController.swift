//
//  WeatherQuestionController.swift
//  Mohae
//
//  Created by 이주영 on 2019/10/30.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import SnapKit
// 4. 현재 날씨는 어떤가요? -> 맑음, 흐림, 비, 눈, 자연재해 => 5 개
class WeatherQuestionController: UIViewController {
    var weatherQuestionView: WeatherQuestionView?
    var feelingQuestionController: FeelingQuestionController?
    var moneyQuestionController: MoneyQuestionController?
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(goBack))
        weatherQuestionView = WeatherQuestionView()
        feelingQuestionController = FeelingQuestionController()
        moneyQuestionController = MoneyQuestionController()
        setView()
        navigationItem.title = "현재 상태"
        print("현재 데이터 상태 => \(self.data)")
    }
    
    @objc func goBack() {
        self.data[2] = ""
        if let moneyQuestion = moneyQuestionController {
            moneyQuestion.data = self.data
            self.navigationController?.popViewController(animated: true)
            print("removed array status = > \(moneyQuestion.data)")
        }
    }
    
    func setView() {
        if let weatherQuestion = weatherQuestionView {
            let surveyBoard = weatherQuestion.surveyScreen
            let questionLabel = weatherQuestion.questionLabel
            let sunnyButton  = weatherQuestion.sunnyButton
            let cloudyButton = weatherQuestion.cloudyButton
            let rainButton = weatherQuestion.rainButton
            let snowButton = weatherQuestion.snowButton
            let disasterButton = weatherQuestion.disasterButton
            
            weatherQuestion.delegate = self
            
            if let board = surveyBoard, let question = questionLabel, let sunnyBtn = sunnyButton, let cloudyBtn = cloudyButton, let rainBtn = rainButton, let snowBtn = snowButton, let disasterBtn = disasterButton {
                view.addSubview(board)
                board.snp.makeConstraints { (make) in
                    make.centerX.equalTo(view.snp.centerX)
                    make.centerY.equalTo(view.snp.centerY)
                    make.width.equalTo(view.snp.width)
                    make.height.equalTo(view.snp.height)
                }
                
                question.snp.makeConstraints { (make) in
                    make.centerX.equalTo(view.snp.centerX)
                    make.centerY.equalTo(view.snp.centerY).offset(-100)
                    make.width.equalTo(300)
                    make.height.equalTo(50)
                }
                
                sunnyBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(question.snp.bottom).offset(50)
                    make.centerX.equalTo(board.snp.centerX)
                    make.width.equalTo(150)
                    make.height.equalTo(30)
                }
                
                cloudyBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(sunnyBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                    make.width.equalTo(150)
                    make.height.equalTo(30)
                }
                
                rainBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(cloudyBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                    make.width.equalTo(150)
                    make.height.equalTo(30)
                }
                
                snowBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(rainBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                    make.width.equalTo(150)
                    make.height.equalTo(30)
                }
                
                disasterBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(snowBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                    make.width.equalTo(150)
                    make.height.equalTo(30)
                }
            }
        }
    }
    
    func changeView(insert: String) {
        self.data[3] = insert
        if let feelingQuestion = feelingQuestionController {
            feelingQuestion.data = self.data
            navigationController?.pushViewController(feelingQuestion, animated: true)
        }
    }
}

extension WeatherQuestionController: WeatherQuestionButtonDelegate {
    func touchSunny() {
        print("sunny <<~ ^ㅡ^ ~>>")
        changeView(insert: "맑음")
        print(data)
    }
    
    func touchCloudy() {
        print("cloud -_-")
        changeView(insert: "흐림")
        print(data)
    }
    
    func touchRain() {
        print("rain ;ㅇ")
        changeView(insert: "비")
        print(data)
    }
    
    func touchSnow() {
        print("~~~ snow ~~~")
        changeView(insert: "눈")
        print(data)
    }
    
    func touchDisaster() {
        print("OMG THIS IS DISASTER!!")
        changeView(insert: "자연재해")
        print(data)
    }
}
