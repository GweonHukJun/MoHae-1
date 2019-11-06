//
//  DataAnalysisController.swift
//  Mohae
//
//  Created by 이주영 on 2019/10/31.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import SnapKit

class DataAnalysisController: UIViewController {
    var data = [String]()
    var resultLabels = [UILabel]()
    var key = ["커플 : ", "인원 : ", "자금 : ", "날씨 : ", "기분 : ", "현재 시간 : "]
    var feelingQuestionController: FeelingQuestionController?
    
    let attributedString = NSMutableAttributedString.init(string: "Apply UnderLining")
   
    
    let formatter = DateFormatter()
    
    let logoImage : UIImageView = {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.image = #imageLiteral(resourceName: "logo")
        return logo
    }()
    
    let guideLabel: UILabel = {
        let tl = UILabel()
        tl.translatesAutoresizingMaskIntoConstraints = false
        tl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tl.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        tl.layer.masksToBounds = true
        tl.layer.cornerRadius = 20
        tl.textAlignment = .center
        tl.text = "다음과 같이 선택하셨습니다."
        return tl
    }()
    
    let completeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("완  료", for: .normal)
        btn.tintColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
        btn.layer.borderColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 2
        btn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(complete), for: .touchUpInside)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feelingQuestionController = FeelingQuestionController()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(goBack))
        navigationItem.title = "입력 확인"
        view.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setView()
        print("현재 데이터 상태 => \(self.data)")
    }
    
    @objc func goBack() {
        self.data[4] = ""
        self.data[5] = ""
        if let feelingQuestion = feelingQuestionController {
            feelingQuestion.data = self.data
            self.navigationController?.popViewController(animated: true)
            print("removed array status = > \(feelingQuestion.data)")
        }
    }
    
    var navBarHeight: CGFloat?
    
    func setView() {
        
        view.addSubview(logoImage)
        view.addSubview(guideLabel)
        view.addSubview(completeButton)
        
        logoImage.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(70)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(300)
            make.height.equalTo(150)
        }
        
        for labelNumber in 0 ... 5 {
            resultLabels.append(UILabel())
            resultLabels[labelNumber].translatesAutoresizingMaskIntoConstraints = false
            resultLabels[labelNumber].textColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
            view.addSubview(resultLabels[labelNumber])
        }
        
        if let navigationBarHeight = navigationController?.navigationBar.frame.height {
            navBarHeight = UIApplication.shared.statusBarFrame.height + navigationBarHeight
        }
        
        guideLabel.snp.makeConstraints { (make) in
            if let navBarHeight = self.navBarHeight {
                make.top.equalTo(view.snp.top).offset(navBarHeight + 200)
            }
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
        resultLabels[0].snp.makeConstraints { (make) in
            make.top.equalTo(guideLabel.snp.bottom).offset(50)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        resultLabels[0].text = key[0] + data[0]
        
        for labelNumber in 1 ... 4 {
            resultLabels[labelNumber].snp.makeConstraints { (make) in
                make.top.equalTo(resultLabels[labelNumber - 1].snp.bottom).offset(30)
                make.centerX.equalTo(view.snp.centerX)
            }
            
            resultLabels[labelNumber].text = key[labelNumber] + data[labelNumber]
        }
        
        completeButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom).offset(-70)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
    }
    
    @objc func complete() {
        print("complete")
        let recommendingController = RecommendingController()
        let navController = UINavigationController(rootViewController: recommendingController)
        navigationController?.pushViewController(recommendingController, animated: true)
    }
}


