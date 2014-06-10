//
//  ViewController.swift
//  swift2048
//
//  Created by wuxing on 14-6-10.
//  Copyright (c) 2014年 优才网（www.ucai.cn）. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startGameButtonTapped(sender : UIButton) {
        println("按下了开始游戏键")
        let alertView = UIAlertView()
        alertView.title = "开始！"
        alertView.message = "游戏就要开始，你准备好了吗!"
        alertView.addButtonWithTitle("Ready, Go！")
        alertView.show()
        alertView.delegate=self
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        println("buttonIndex:\(buttonIndex)")
        self.presentViewController(MainViewController(), animated: true, completion: nil)
    }

}

