//
//  AnalysisController.swift
//  Mohae
//
//  Created by 이주영 on 10/09/2019.
//  Copyright © 2019 이주영. All rights reserved.
//

import UIKit
import Firebase

class AnalysisController: UIViewController {
    
    let text: UILabel = {
        let tv = UILabel()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.backgroundColor = .red
        tv.textColor = .black
        
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(text)
        view.backgroundColor = .yellow
        text.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(goBack))
    }
    
    func reciveData(data: [String]) {
        self.text.text = data[0] + data[1] + data[2] + data[3]
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let subSurveyController = segue.destination as? SubSurveyController {
            subSurveyController.delegate = self
        }
    }
    */
    @objc private func goBack() {
        dismiss(animated: true, completion: nil)
    }
}
