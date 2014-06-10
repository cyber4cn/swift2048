//
//  ScoreView.swift
//  Swift2048-002_V4
//
//  Created by wuxing on 14-6-3.
//  Copyright (c) 2014年 优才网（www.ucai.cn）. All rights reserved.
//

import Foundation

import UIKit

protocol ScoreViewProtocol {
    func scoreChanged(newScore s: Int)
}



class ScoreView : UIView,ScoreViewProtocol{
    var score: Int = 0 {
    didSet {
        label.text = "分数: \(score)"
    }
    }
    
    let defaultFrame = CGRectMake(0, 0, 100, 30)
    var label: UILabel
    
    init() {
        label = UILabel(frame: defaultFrame)
        label.textAlignment = NSTextAlignment.Center
        super.init(frame: defaultFrame)
        backgroundColor = UIColor.blackColor()
        label.font =  UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.textColor = UIColor.whiteColor()
        self.addSubview(label)
    }
    
    func scoreChanged(newScore s: Int)  {
        score = s
    }
}

class BestScoreView:ScoreView{
    var bestscore:Int = 0 {
    didSet{
        label.text = "最高分:\(bestscore)"
    }
    }
    
    override func scoreChanged(newScore s: Int)  {
        bestscore = s
    }
}
