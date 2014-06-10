//
//  TileView.swift
//  Swift2048-002_V2
//
//  Created by wuxing on 14-6-7.
//  Copyright (c) 2014年 优才网（www.ucai.cn）. All rights reserved.
//

import Foundation

import UIKit

class TileView : UIView {
    let colorMap = [
        2:UIColor.redColor(),
        4:UIColor.orangeColor(),
        8:UIColor.yellowColor(),
        16: UIColor.greenColor(),
        32:UIColor.brownColor(),
        64:UIColor.blueColor(),
        128:UIColor.purpleColor(),
        256:UIColor.cyanColor(),
        512:UIColor.lightGrayColor(),
        1024:UIColor.magentaColor(),
        2048:UIColor.blackColor()
    ]
    
    var value: Int = 0 {
    didSet {
        backgroundColor = colorMap[value]
        numberLabel.textColor = UIColor.whiteColor()
        numberLabel.text = "\(value)"
    }
    }
    var numberLabel: UILabel
    
    init(position: CGPoint, width: CGFloat, value: Int) {
        numberLabel = UILabel(frame: CGRectMake(0, 0, width, width))
        numberLabel.textAlignment = NSTextAlignment.Center
        numberLabel.minimumScaleFactor = 0.5
        numberLabel.font =  UIFont(name: "HelveticaNeue-Bold", size: 20)
        numberLabel.textColor = UIColor.whiteColor()
        numberLabel.text = "\(value)"
        
        super.init(frame: CGRectMake(position.x, position.y, width, width))
        addSubview(numberLabel)
        self.value = value
        backgroundColor = colorMap[value]
        
    }
}
