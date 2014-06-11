//
//  SetViewController.swift
//  swift2048
//
//  Created by wuxing on 14-6-11.
//  Copyright (c) 2014年 优才网（www.ucai.cn）. All rights reserved.
//

import UIKit

class SettingViewController:UIViewController,UITextFieldDelegate
{
    var mainview:MainViewController
    var txtNum:UITextField!
    var segDimension:UISegmentedControl!
    
    init(mainview:MainViewController)
    {
        self.mainview = mainview
        super.init(nibName: nil, bundle: nil)
        
    }
    override func viewDidLoad()  {
        super.viewDidLoad()
         self.view.backgroundColor = UIColor.whiteColor();
        setupTextControl()
    }
    
    func setupTextControl()
    {
        var cv = ControlView()
        txtNum = cv.createTextField(String(self.mainview.maxnumber),action:"numChanged:", sender:self)
        txtNum.frame.origin.x = 50
        txtNum.frame.origin.y = 100
        txtNum.frame.size.width = 200
        txtNum.returnKeyType = UIReturnKeyType.Done
        
        
        self.view.addSubview(txtNum)
        segDimension = cv.createSegment(["3x3", "4x4", "5x5"], action:"dimensionChanged:", sender:self)
        
        segDimension.frame.origin.x = 50
        segDimension.frame.origin.y = 200
        segDimension.frame.size.width = 200
        
        self.view.addSubview(segDimension)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        textField.resignFirstResponder()
        println("numChanged")
        if(textField.text != "\(mainview.maxnumber)")
        {
          var numberFromString = textField.text.toInt()
          mainview.maxnumber = numberFromString!
        }
        return true
    }
    
    func dimensionChanged(sender:SettingViewController)
    {
        var segVals = [3,4,5]
        mainview.dimension = UInt32(segVals[segDimension.selectedSegmentIndex])
        mainview.resetUI()
        println("dimensionChanged")
    }
}
