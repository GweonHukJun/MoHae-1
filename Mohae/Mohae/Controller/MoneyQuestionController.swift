//
//  MoneyQuestionController.swift
//  Mohae
//
//  Created by 이주영 on 2019/10/30.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import SnapKit
// 3. 사용할 돈은 얼마 정도 생각하고 계신가요? -> 무료, 1 ~ 5, 6 ~ 10, 10 이상 => 4 개
class MoneyQuestionController: UIViewController {
    var moneyQuestionView: MoneyQuestionView?
    var weatherQuestionController: WeatherQuestionController?
    var peopleQuestionController: PeopleQuestionController?
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(goBack))
        moneyQuestionView = MoneyQuestionView()
        weatherQuestionController = WeatherQuestionController()
        peopleQuestionController = PeopleQuestionController()
        setView()
        navigationItem.title = "현재 상태"
        print("현재 데이터 상태 => \(self.data)")
    }
    
    @objc func goBack() {
        self.data[1] = ""
        if let peopleQuestion = peopleQuestionController {
            peopleQuestion.data = self.data
            self.navigationController?.popViewController(animated: true)
            print("removed array status = > \(peopleQuestion.data)")
        }
    }
    
    func setView() {
        if let moneyQuestion = moneyQuestionView {
            let surveyBoard = moneyQuestion.surveyScreen
            let questionLabel = moneyQuestion.questionLabel
            let freeButton = moneyQuestion.freeButton
            let oneToFiveButton = moneyQuestion.oneToFiveButton
            let sixToTenButton = moneyQuestion.sixToTenButton
            let moreThanTenButton = moneyQuestion.moreThanTenButton
            
            moneyQuestion.delegate = self
            if let board = surveyBoard, let question = questionLabel, let freeBtn = freeButton, let oneToFiveBtn = oneToFiveButton, let sixToTenBtn = sixToTenButton, let moreThanTenBtn = moreThanTenButton {
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
                
                freeBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(question.snp.bottom).offset(50)
                    make.centerX.equalTo(board.snp.centerX)
                    make.width.equalTo(150)
                    make.height.equalTo(30)
                }
                
                oneToFiveBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(freeBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                    make.width.equalTo(150)
                    make.height.equalTo(30)
                }
                
                sixToTenBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(oneToFiveBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                    make.width.equalTo(150)
                    make.height.equalTo(30)
                }
                
                moreThanTenBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(sixToTenBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                    make.width.equalTo(150)
                    make.height.equalTo(30)
                }
            }
        }
    }
    
    func changeView(insert: String) {
        self.data[2] = insert
        if let weatherQuestion = weatherQuestionController {
            weatherQuestion.data = self.data
            navigationController?.pushViewController(weatherQuestion, animated: true)
        }
    }
}

extension MoneyQuestionController: MoneyQuestionButtonDelegate {
    func touchFree() {
        print("Free!!")
        changeView(insert: "무료")
        print(data)
    }
    
    func touchOneToFive() {
        print("1 ~ 5 만")
        changeView(insert: "1 ~ 5 만 원")
        print(data)
    }
    
    func touchSixToTen() {
        print("6 ~ 10 만")
        changeView(insert: "6 ~ 10 만 원")
        print(data)
    }
    
    func touchMoreThanTen() {
        print("10 만 이상")
        changeView(insert: "10 만 원 이상")
        print(data)
    }
}
