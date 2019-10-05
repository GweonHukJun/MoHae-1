
//
//  FirstMapCellCollectionViewCell.swift
//  Mohae
//
//  Created by 권혁준 on 02/10/2019.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import GoogleMaps
import SnapKit

class FirstMapCellCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        myCustomInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder :) has not been implemented")
    }
    
    var mapView : GMSMapView = {
        let view = GMSMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func myCustomInit() {
        print("hello there from SupView")
    }
    
    func setup(){
        addSubview(mapView)
        
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(self.snp.height)
        }
    }
}
