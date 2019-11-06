//
//  MapSearchCell.swift
//  Mohae
//
//  Created by 권혁준 on 25/09/2019.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit
import SnapKit

class MapSearchCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder :) has not been implemented")
    }
    
    var lat : Double?
    var lng : Double?
    var id : String?
    var place_id : String?
    
    var photo: UIImageView = {
        let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.backgroundColor = .black
        photo.layer.masksToBounds = true
        photo.contentMode = .scaleAspectFill
        photo.layer.cornerRadius = 20
        return photo
    }()
    
    var squad: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
       return view
    }()
    
    var name: UILabel = {
       let name  = UILabel()
       name.translatesAutoresizingMaskIntoConstraints = false
       return name
    }()
    
    var address: UILabel = {
        let type = UILabel()
        type.translatesAutoresizingMaskIntoConstraints = false
        return type
    }()

    
    func setupView(){
        addSubview(squad)
        squad.addSubview(photo)
        squad.addSubview(name)
        //addSubview(icon)
        squad.addSubview(address)
        
        squad.snp.makeConstraints { (make) in
            make.height.equalTo(self.snp.height).offset(-10)
            make.width.equalTo(self.snp.width).offset(-10)
            make.top.equalTo(self.snp.top).offset(5)
            make.bottom.equalTo(self.snp.bottom).offset(-5)
            make.right.equalTo(self.snp.right).offset(-5)
            make.left.equalTo(self.snp.left).offset(5)
        }
        
        photo.snp.makeConstraints { (make) in
            make.top.equalTo(squad.snp.top).offset(5)
            make.left.equalTo(squad.snp.left).offset(5)
            make.height.equalTo(squad.snp.height).offset(-10)
            make.width.equalTo(squad.snp.height).offset(-10)
        }
        
        name.snp.makeConstraints { (make) in
            make.top.equalTo(squad.snp.top).offset(10)
            make.left.equalTo(photo.snp.right).offset(3)
            make.width.equalTo(250)
            make.height.equalTo(20)
        }
        
        address.snp.makeConstraints { (make) in
            make.top.equalTo(name.snp.bottom)
            make.left.equalTo(photo.snp.right).offset(3)
            make.width.equalTo(250)
            make.height.equalTo(20)
        }
    
        /*
        name.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        name.widthAnchor.constraint(equalToConstant: 400).isActive = true
        name.heightAnchor.constraint(equalToConstant: 20).isActive = true
        /*
        icon.topAnchor.constraint(equalTo: type.bottomAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 200).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        */
        type.topAnchor.constraint(equalTo: name.bottomAnchor).isActive = true
        type.widthAnchor.constraint(equalToConstant: 100).isActive = true
        type.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        type2.topAnchor.constraint(equalTo: type.topAnchor).isActive = true
        type2.leftAnchor.constraint(equalTo: type.rightAnchor).isActive = true
        type2.widthAnchor.constraint(equalToConstant: 100).isActive = true
        type2.heightAnchor.constraint(equalToConstant: 20).isActive = true
 */
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name.text = nil
        address.text = nil
    }
}
