//
//  SubSurveyCell.swift
//  Mohae
//
//  Created by 이주영 on 28/08/2019.
//  Copyright © 2019 이주영. All rights reserved.
//

import UIKit

class SubSurveyCell: UICollectionViewCell{
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.backgroundColor = .red
        tv.textColor = .black
        tv.isEditable = false
        
        return tv
    }()
    /*
    func makeCheckBox() -> Checkbox {
        let checkBox: Checkbox = {
            let cb = Checkbox(frame: CGRect(x: 30, y: 80, width: 25, height: 25))
            cb.tintColor = .black
            cb.borderStyle = .square
            cb.checkmarkStyle = .tick
            cb.uncheckedBorderColor = .lightGray
            cb.borderLineWidth = 1
            cb.translatesAutoresizingMaskIntoConstraints = false
            
            return cb
        }()
        
        return checkBox
    }*/
    
    func makeLabel() -> UILabel {
        let label: UILabel = {
            let lb = UILabel()
            lb.translatesAutoresizingMaskIntoConstraints = false
            lb.font = UIFont.systemFont(ofSize: 20)
            lb.textColor = .black
            
            return lb
        }()
        
        return label
    }

    //question.2 함께하는 인원은 몇 명인가요? segment
    let personCount: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["1 ~ 2 명", "3 ~ 5 명", "6명 이상"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        //sc.selectedSegmentIndex = 0
        
        return sc
    }()

    //question.5 현재 당신의 기분은 어떤가요? checkbox and text label
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textView)
        
        textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
