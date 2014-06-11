//
//  MainTabViewController.swift
//  swift2048
//
//  Created by wuxing on 14-6-11.
//  Copyright (c) 2014年 优才网（www.ucai.cn）. All rights reserved.
//

import UIKit

class MainTabViewController:UITabBarController
{
  
    init()
    {
        super.init(nibName: nil, bundle: nil)
        var viewMain = MainViewController();
        viewMain.title = "2048"
        
        var viewSetting = SettingViewController(mainview: viewMain);
        viewSetting.title = "设置"
        
        var mainSetting =  UINavigationController(rootViewController: viewMain)

        var ctrlSetting = UINavigationController(rootViewController: viewSetting)
        
        
        self.viewControllers = [
           mainSetting,
           ctrlSetting
        ]
        self.selectedIndex = 0;
        
        
        //
    }
}
