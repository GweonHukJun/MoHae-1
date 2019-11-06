//
//  FeelingQuestionController.swift
//  Mohae
//
//  Created by 이주영 on 2019/10/30.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import SnapKit
// 5. 현재 기분은 어떤가요? -> 행복, 슬픔, 차분, 흥분 등 => 4 개 이상
class FeelingQuestionController: UIViewController {
    var feelingQuestionView: FeelingQuestionView?
    var dataAnalysisController: DataAnalysisController?
    var weatherQuestionController: WeatherQuestionController?
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(goBack))
        feelingQuestionView = FeelingQuestionView()
        dataAnalysisController = DataAnalysisController()
        weatherQuestionController = WeatherQuestionController()
        setView()
        navigationItem.title = "현재 상태"
        print("현재 데이터 상태 => \(self.data)")
    }
    
    @objc func goBack() {
        self.data[3] = ""
        if let weatherQuestion = weatherQuestionController {
            weatherQuestion.data = self.data
            self.navigationController?.popViewController(animated: true)
            print("removed array status = > \(weatherQuestion.data)")
        }
    }

    func setView() {
        if let feelingQuestion = feelingQuestionView {
            let surveyBoard = feelingQuestion.surveyScreen
            let questionLabel = feelingQuestion.questionLabel
            let happyButton = feelingQuestion.happyButton
            let sadButton = feelingQuestion.sadButton
            let calmButton = feelingQuestion.calmButton
            let excitingButton = feelingQuestion.excitingButton
            
            feelingQuestion.delegate = self
            
            if let board = surveyBoard, let question = questionLabel, let happyBtn = happyButton, let sadBtn = sadButton, let calmBtn = calmButton, let excitingBtn = excitingButton {
                view.addSubview(board)
                
                board.snp.makeConstraints { (make) in
                    make.centerX.equalTo(view.snp.centerX)
                    make.centerY.equalTo(view.snp.centerY)
                    make.width.equalTo(view.snp.width)
                    make.height.equalTo(view.snp.height)
                }
                
                question.snp.makeConstraints { (make) in
                    make.centerX.equalTo(board.snp.centerX)
                    make.centerY.equalTo(board.snp.centerY).offset(-100)
                    make.width.equalTo(300)
                    make.height.equalTo(50)
                }
                
                happyBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(question.snp.bottom).offset(50)
                    make.centerX.equalTo(board.snp.centerX)
                    make.width.equalTo(150)
                    make.height.equalTo(30)
                }
                
                sadBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(happyBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                    make.width.equalTo(150)
                    make.height.equalTo(30)
                }
                
                calmBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(sadBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                    make.width.equalTo(150)
                    make.height.equalTo(30)
                }
                
                excitingBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(calmBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                    make.width.equalTo(150)
                    make.height.equalTo(30)
                }
            }
        }
    }
    
    func loadTime() -> String {
        let time: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let dateFormatter = DateFormatter()
        let timestampDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: time))
        
        dateFormatter.dateFormat = "hh:mm:ss a"
        
        return dateFormatter.string(from: timestampDate as Date)
    }
    
    func changeView(insert: String) {
        self.data[4] = insert
        self.data[5] = loadTime()
        if let dataAnalysis = dataAnalysisController {
            dataAnalysis.data = self.data
            navigationController?.pushViewController(dataAnalysis, animated: true)
        }
    }
}

extension FeelingQuestionController: FeelingQuestionButtonDelegate {
    func touchHappy() {
        print("I'm So Happy")
        changeView(insert: "행복")
    }
    
    func touchSad() {
        print("ㅠㅠ")
        changeView(insert: "슬픔")
    }
    
    func touchCalm() {
        print("Keep Calm")
        changeView(insert: "차분")
    }
    
    func touchExciting() {
        print("SOOOOOOO Exciting")
        changeView(insert: "흥분")
    }
}
