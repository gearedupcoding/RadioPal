//
//  ViewController.swift
//  RadioPal
//
//  Created by Jami, Dheeraj on 9/20/17.
//  Copyright © 2017 Jami, Dheeraj. All rights reserved.
//

import UIKit
import SnapKit
import Then
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .white
        self.title = "RadioPal"
        
        let label = UILabel().then {
            
            self.view.addSubview($0)
            $0.numberOfLines = 0
            $0.textColor = .black
            $0.text = "Welcome to RadioPal"
            $0.font = UIFont.systemFont(ofSize: 30)
            
            $0.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.view)
                make.top.equalTo(topLayoutGuide.snp.bottom).offset(10)
            }
        }
        
        let instructionsLabel = UILabel().then {
            self.view.addSubview($0)
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.text = "Click on mic icon to speak - Say a genre or country to list out the stations. Go ahead!"
            $0.font = UIFont.systemFont(ofSize: 25)
            
            $0.snp.makeConstraints({ (make) in
                make.centerX.equalTo(label)
                make.top.equalTo(label.snp.bottom).offset(10)
                make.left.equalTo(self.view).offset(15)
                make.right.equalTo(self.view).offset(-15)
            })
        }
        
        let micBtn = UIButton(type: .custom).then {
            self.view.addSubview($0)
            let micImage = UIImage(named: "mic")
            $0.setImage(micImage, for: .normal)
            
            $0.snp.makeConstraints({ (make) in
                make.centerX.equalTo(instructionsLabel)
                make.height.width.equalTo(self.view.snp.width).offset(40)
                make.top.equalTo(instructionsLabel.snp.bottom).offset(20)
            })
            
            
        }
        
        
     
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

