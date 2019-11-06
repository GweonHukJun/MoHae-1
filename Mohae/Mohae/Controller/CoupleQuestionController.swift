//
//  CoupleQuestionController.swift
//  Mohae
//
//  Created by 이주영 on 2019/10/29.
//  Copyright © 2019 이주영. All rights reserved.
//

import UIKit
import SnapKit

class CoupleQuestionController: UIViewController {
    var coupleQuestionView: CoupleQuestionView?
    var peopleQuestionController: PeopleQuestionController?
    var data = ["", "", "", "", "", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coupleQuestionView = CoupleQuestionView()
        peopleQuestionController = PeopleQuestionController()
        setView()
        navigationItem.title = "현재 상태"
        print("현재 데이터 상태 => \(self.data)")
    }
    
    func setView() {
        if let coupleQuestion = coupleQuestionView {
            let surveyBoard = coupleQuestion.surveyScreen
            let questionLabel = coupleQuestion.questionLabel
            let yesButton = coupleQuestion.yesButton
            let noButton = coupleQuestion.noButton

            coupleQuestion.delegate = self
            if let board = surveyBoard, let question = questionLabel, let yesBtn = yesButton, let noBtn = noButton {
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
                
                yesBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(question.snp.bottom).offset(50)
                    make.centerX.equalTo(board.snp.centerX)
                    make.width.equalTo(150)
                    make.height.equalTo(30)
                }
                
                noBtn.snp.makeConstraints { (make) in
                    make.top.equalTo(yesBtn.snp.bottom).offset(20)
                    make.centerX.equalTo(board.snp.centerX)
                    make.width.equalTo(150)
                                     make.height.equalTo(30)
                }
            }
        }
    }
    
    func changeView(insert: String) {
        self.data[0] = insert
        if let peopleQuestion = peopleQuestionController {
            peopleQuestion.data = self.data
            //let navController = UINavigationController(rootViewController: peopleQuestion)
            navigationController?.pushViewController(peopleQuestion, animated: true)
            //present(navController, animated: true, completion: nil)
        }
    }
}

extension CoupleQuestionController: CoupleQuestionButtonDelegate {
    func touchYes() {
        print("Yes !!")
        changeView(insert: "Y")
        print(self.data)
    }
    
    func touchNo() {
        print("No...")
        changeView(insert: "N")
        print(self.data)
    }
}
