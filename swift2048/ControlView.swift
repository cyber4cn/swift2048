//
//  ControlView.swift
//  Swift2048-002_V4
//
//  Created by wuxing on 14-6-3.
//  Copyright (c) 2014年 优才网（www.ucai.cn）. All rights reserved.
//

import Foundation

import UIKit

class ControlView:UIView
{
    let defaultFrame = CGRectMake(0, 0, 70, 30)
    var button: UIButton!
    
    init(title:String, action:Selector, sender:UIViewController) {
        super.init(frame:defaultFrame);
        button = createButton(title, posSize:self.defaultFrame, action: action, sender: sender)
        self.addSubview(button)
    }
    
    
    func createButton(title:String, posSize:CGRect, action:Selector, sender:UIViewController) -> UIButton{
        var button:UIButton = UIButton(frame: posSize);
        button.backgroundColor = UIColor.darkGrayColor();
        button.setTitle("\(title)",forState:.Normal);
        
        button.titleLabel.textColor = UIColor.whiteColor()
        button.titleLabel.font = UIFont.systemFontOfSize(14)
        button.targetForAction(action, withSender: sender)
        button.addTarget(sender,action:action,forControlEvents:UIControlEvents.TouchUpInside);
       
        return button;
    }
}