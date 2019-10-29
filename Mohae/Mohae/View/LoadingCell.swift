//
//  LoadingCell.swift
//  Mohae
//
//  Created by 권혁준 on 2019/10/24.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import SnapKit

class LoadingCell: UICollectionViewCell {
    
    let indicator : UIActivityIndicatorView = {
        let indi = UIActivityIndicatorView()
        indi.translatesAutoresizingMaskIntoConstraints = false
        return indi
    }()
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           setupView()
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder :) has not been implemented")
       }
       
    func setupView(){
        
        addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalTo(self.center)
        }
        
    }
}
