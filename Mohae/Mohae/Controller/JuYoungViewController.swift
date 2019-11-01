//
//  JuYoungViewController.swift
//  Mohae
//
//  Created by 권혁준 on 2019/11/01.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit

class JuYoungViewController: UIViewController {

    var search = "bank"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.add,target: self, action:#selector(moveDate))
        // Do any additional setup after loading the view.
    }
    

    @objc func moveDate(){
        let view = AgreeViewController()
        view.search = self.search
        self.navigationController?.pushViewController(view, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
