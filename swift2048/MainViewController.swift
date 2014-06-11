//
//  MainViewController.swift
//  Swift2048-002_V1
//
//  Created by wuxing on 14-6-7.
//  Copyright (c) 2014年 优才网（www.ucai.cn）. All rights reserved.
//
import UIKit

class MainViewController : UIViewController
{
    
    //间距
    var padding:CGFloat = 6
    //一个方向上的方格数
    var dimension:UInt32 = 4
    //通关的数字
    var maxnumber:Int = 2048
    //方格宽度
    let width: CGFloat = 50
    
    var gmodel:GameModel! = nil
    
    var score:ScoreViewProtocol! = nil
    var bestscore:ScoreViewProtocol! = nil
    var btnreset:UIButton! = nil
    var btngen: UIButton! = nil
    
    var tiles: Dictionary<NSIndexPath, TileView>
    var tileVals: Dictionary<NSIndexPath,Int>
    var backgrounds:Array<UIView>
    
    enum AnimationType {
        case None
        case NewTile
        case MergeTile
    }
    
    
    init()
    {
        self.backgrounds = Array<UIView>()
        self.tiles =  Dictionary()
        self.tileVals =  Dictionary()
        super.init(nibName: nil, bundle: nil)
    }
    
    // View Controller
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        setupGame()
        gmodel = GameModel(dimension: Int(dimension),score:score, bestscore:bestscore)
        //预先生成两个数字
        genNumber()
        genNumber()

    }
    func setupGame()
    {
        setupBackground()
        setupScoreBoard()
        setupButtons()
        setupSwipeControls()
    }
    
    func setupBackground() {
        
        var xCursor:CGFloat = 30
        var yCursor:CGFloat = 150
        
        for i in 0...dimension-1 {
            yCursor = 150
            for j in 0...dimension-1 {
                //画方格
                var background = UIView(frame: CGRectMake(xCursor, yCursor, width, width))
                background.backgroundColor = UIColor.darkGrayColor()
                self.view.addSubview(background)
                backgrounds += background
                yCursor += padding + width
            }
            xCursor += padding + width
        }
    }
    
    func setupScoreBoard()
    {
        score = ScoreView()
        var v = score as ScoreView
        v.frame.origin.x = 50
        v.frame.origin.y = 80
        self.view.addSubview(v)
        score.scoreChanged(newScore: 0)
        
        bestscore = BestScoreView()
        v = bestscore as BestScoreView
        v.frame.origin.x = 150
        v.frame.origin.y = 80
        self.view.addSubview(v)
        bestscore.scoreChanged(newScore: 0)
        
    }
    
    func setupButtons()
    {
        var cv = ControlView()
        btnreset = cv.createButton("重置", action: "resetTapped:", sender: self)
        btnreset.frame.origin.x = 50
        btnreset.frame.origin.y = 450
        
        self.view.addSubview(btnreset)
        btngen = cv.createButton("新数", action: "genTapped:", sender: self)
        btngen.frame.origin.x = 150
        btngen.frame.origin.y = 450
        self.view.addSubview(btngen)
      
    }
    
    func setupSwipeControls() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("SwipeUp"))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("SwipeDown"))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(downSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("SwipeLeft"))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("SwipeRight"))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    func SwipeUp()
    {
        println("向上拉")
        var ret = gmodel.reflowUp()
        var retm = gmodel.mergeUp()
        
        //需要重排
        gmodel.reflowUp()
        var ok = drawFlowTiles()
        if !ok && (retm || ret)
        {
            genNumber()
        }
        else
        {
            checkFail()
        }
    }
    
    func printTiles(tiles:Array<Int>)
    {
        var count = tiles.count
        for var i=0; i<count; i++
        {
            if (i+1) % Int(dimension) == 0
            {
                println(tiles[i])
            }
            else
            {
                print("\(tiles[i])\t")
            }
        }
        
        println("")
        
    }
    func SwipeDown()
    {
        println("向下拉")
        var ret = gmodel.reflowDown()
        var retm = gmodel.mergeDown()
        gmodel.reflowDown()
        var ok = drawFlowTiles()
        if !ok && (retm || ret)
        {
            genNumber()
        }
        else
        {
            checkFail()
        }
        
    }
    func SwipeLeft()
    {
        println("向左拉")
        var ret = gmodel.reflowLeft()
        var retm = gmodel.mergeLeft()
        gmodel.reflowLeft()
        var ok = drawFlowTiles()
        if !ok && (retm || ret)
        {
            genNumber()
        }
        else
        {
            checkFail()
        }
    }
    func SwipeRight()
    {
        println("向右拉")
        var ret = gmodel.reflowRight()
        var retm = gmodel.mergeRight()
        gmodel.reflowRight()
        var ok = drawFlowTiles()
        if !ok && (retm || ret)
        {
            genNumber()
        }
        else
        {
            checkFail()
        }
        
    }
    func checkFail()
    {
        if gmodel.isFull()
        {
            //提示游戏已经结束
            let alertView = UIAlertView()
            alertView.title = "结束"
            alertView.message = "Game Over!"
            alertView.addButtonWithTitle("确定")
            alertView.show()
            
        }
    }
    
    func drawFlowTiles() -> Bool
    {
        //最笨的办法，把所有的都删除了，重新绘制新的
        //resetUI()
        printTiles(gmodel.tiles)
        printTiles(gmodel.mtiles)
        var ok = drawTiles()
        if(ok)
        {
            
            let alertView = UIAlertView()
            alertView.title = "过关"
            alertView.message = "嘿，很棒，你通关了!"
            alertView.addButtonWithTitle("确定")
            alertView.show()
            return true
        }
        return false
    }
    func drawTiles() -> Bool
    {
        var index:Int
        var key:NSIndexPath
        var tile:TileView
        var tileval:Int
        var success:Bool = false
        for row in 0..Int(dimension) {
            for col in 0..Int(dimension) {
                index = Int(dimension) * row + col
                key  = NSIndexPath(forRow: row, inSection: col)
                //原来没有，现在有了
                if((gmodel.tiles[index] > 0) && (tileVals.indexForKey(key) == nil))
                {
                    justInsertTile((row, col), value: gmodel.tiles[index], showNew:AnimationType.MergeTile)
                }
                //原来有，现在没有了
                if((gmodel.tiles[index] == 0) && (tileVals.indexForKey(key) != nil))
                {
                    tile = tiles[key]!
                    tile.removeFromSuperview()
                    tiles.removeValueForKey(key)
                    tileVals.removeValueForKey(key)
                }
                //原来有，现在值变了
                
                if((gmodel.tiles[index] > 0) && (tileVals.indexForKey(key) != nil))
                {
                    tileval = tileVals[key]!
                    if(tileval != gmodel.tiles[index])
                    {
                        tile = tiles[key]!
                        tile.removeFromSuperview()
                        tiles.removeValueForKey(key)
                        tileVals.removeValueForKey(key)
                        
                        justInsertTile((row, col), value: gmodel.tiles[index], showNew:AnimationType.MergeTile)
                    }
                }
                if(gmodel.tiles[index] >= maxnumber)
                {
                    success = true
                }
            }
        }
        return success
    }
    func resetUI()
    {
        println("\"resetTapped button\"")
        for (key, tile) in tiles {
            tile.removeFromSuperview()
        }
        tiles.removeAll(keepCapacity: true)
        tileVals.removeAll(keepCapacity: true)
        
        for background in backgrounds {
            background.removeFromSuperview()
        }
        //background.removeFromSuperview()
        setupBackground()
        resetData()
        genNumber()
        genNumber()
    }
    func resetData()
    {
        gmodel.initTiles(Int(self.dimension))
        gmodel.initScore()
    }
    func resetTapped(sender: UIButton!) {
        
        resetUI()
       
    }
    
    
    func genTapped(sender: UIButton!) {
        genNumber()
    }
    
  
    func genNumber()
    {
        var seedNumbers = [2,4]
        let randomVal = Int(arc4random_uniform(10))
        println(randomVal)
        var seed = seedNumbers[randomVal == 1 ? 1 : 0]
        println(seed)
        
        let col = Int(arc4random_uniform(dimension))
        let row = Int(arc4random_uniform(dimension))
        //产生种子
        insertTile((row, col), value:seed)
    }
    
    func insertTile(pos: (Int, Int), value: Int) {
        
        
        
            let (row, col) = pos
            var ret = gmodel.setPosition(row, col: col, value:value)
            if !ret
            {
                //重复生成
                genNumber()
                return
            }
            justInsertTile(pos, value: value, showNew:AnimationType.NewTile)
            println(gmodel.emptyPositions())
            println(gmodel.tiles)
        
    }
    
    func justInsertTile(pos: (Int, Int), value: Int, showNew:AnimationType = AnimationType.None)
    {
        let (row, col) = pos
        let x = 30 + CGFloat(col)*(width + padding)
        let y = 150 + CGFloat(row)*(width + padding)
        
        let tile = TileView(position: CGPointMake(x, y), width: width, value: value)
        
        self.view.addSubview(tile)
        self.view.bringSubviewToFront(tile)
        var index = NSIndexPath(forRow: row, inSection: col)
        tiles[index] = tile
        tileVals[index] = value
        
        if(showNew == AnimationType.None)
        {
            return
        }
        if(showNew == AnimationType.NewTile)
        {
            tile.layer.setAffineTransform(CGAffineTransformMakeScale(0.1, 0.1))
        }
        else
        {
            tile.layer.setAffineTransform(CGAffineTransformMakeScale(1, 1))
        }
        UIView.animateWithDuration(0.3, delay: 0.1, options: UIViewAnimationOptions.TransitionNone,
            animations: { () -> Void in
                tile.layer.setAffineTransform(CGAffineTransformMakeScale(1.1, 1.1))
            },
            completion: { (finished: Bool) -> Void in
                UIView.animateWithDuration(0.08, animations: { () -> Void in
                    tile.layer.setAffineTransform(CGAffineTransformIdentity)
                    })
            })
    }
    
    
    
}