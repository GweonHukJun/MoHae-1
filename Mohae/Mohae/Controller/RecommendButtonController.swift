//
//  RecommendButtonController.swift
//  Mohae
//
//  Created by 이주영 on 18/08/2019.
//  Copyright © 2019 이주영. All rights reserved.
//

import UIKit

class RecommendButtonController: UIViewController {
    
    lazy var recommendView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
        containerView.backgroundColor = UIColor.white
        /*
        let recommendBack = UIView()
        recommendBack.layer.cornerRadius = 50
        recommendBack.backgroundColor = UIColor.systemBlue
        recommendBack.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(recommendBack)
        recommendBack.widthAnchor.constraint(equalToConstant: 150).isActive = true
        recommendBack.heightAnchor.constraint(equalToConstant: 150).isActive = true
        recommendBack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        recommendBack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        */
        let recommendButton = UIButton(type: .system)
        recommendButton.setTitle("추     천", for: .normal)
        recommendButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        recommendButton.tintColor = .white
        recommendButton.layer.cornerRadius = 50
        recommendButton.backgroundColor = #colorLiteral(red: 1, green: 0.1743637621, blue: 0.4743173122, alpha: 1)
        recommendButton.translatesAutoresizingMaskIntoConstraints = false
        recommendButton.addTarget(self, action: #selector(setButton), for: .touchUpInside)
        containerView.addSubview(recommendButton)
        recommendButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        recommendButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        recommendButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        recommendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        recommendButton.startAnimatingPressActions()
        //recommendButton.animating(recommendButton)
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(recommendView)
    }

    
    @objc private func setButton() { // 현재 기분을 물어보는 질문지를 작성할 수 있는 화면으로 전환 되도록 작상헌다.
        let coupleQuestionController = CoupleQuestionController()
       // let navController = UINavigationController(rootViewController: coupleQuestionController)
        self.navigationController?.pushViewController(coupleQuestionController, animated: true)
    }
}

extension UIButton {

        func startAnimatingPressActions() {
            addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
            addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
        }
        
        @objc private func animateDown(sender: UIButton) {
            animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95))
            
        }
        
        @objc private func animateUp(sender: UIButton) {
            animate(sender, transform: .identity)
        }
        
        private func animate(_ button: UIButton, transform: CGAffineTransform) {
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 3,
                           options: [.curveEaseInOut],
                           animations: {
                            button.transform = transform
                }, completion: nil)
        }
        
    //반복 애니메이션인데 이 애니메이션 적용실 클릭이 안됌
    func animating(_ button: UIButton) {
          
            UIView.animate(withDuration: 1.0, delay:0.5, options: [.repeat, .autoreverse], animations: {
                button.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }, completion: nil)
    }
     
}
