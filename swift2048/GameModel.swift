//
//  GameModel.swift
//  Swift2048-002_V3
//
//  Created by wuxing on 14-6-3.
//  Copyright (c) 2014年 优才网（www.ucai.cn）. All rights reserved.
//

import Foundation

class GameModel{
    
    var dimension:Int  = 0
    var tiles:Array<Int>!
    var mtiles:Array<Int>!
    var scoredelegate:ScoreViewProtocol!
    var bsdelegate:ScoreViewProtocol!
    var score:Int
    var bestscore:Int
    
    init(dimension:Int, score:ScoreViewProtocol, bestscore:ScoreViewProtocol)
    {
        self.scoredelegate = score
        self.bsdelegate=bestscore
        self.score = 0
        self.bestscore = 0
        self.initTiles(dimension)
    }
    
    func setScore(s:Int)
    {
        score+=s
        if(bestscore<score)
        {
            bestscore = score
        }
        scoredelegate.scoreChanged(newScore: score)
        bsdelegate.scoreChanged(newScore: bestscore)
    }
    
    func initTiles(dimension:Int)
    {
        self.dimension = dimension
        
        self.tiles = Array<Int>(count:self.dimension*self.dimension, repeatedValue:0)
        
        self.mtiles = Array<Int>(count:self.dimension*self.dimension, repeatedValue:0)
    }
    func initScore()
    {
        self.score = 0
        scoredelegate.scoreChanged(newScore: 0)
    }
    func copyMtiles()
    {
        var index:Int
        for i in 0..dimension {
            for j in 0..dimension {
                index = self.dimension * i + j
                tiles[index] = mtiles[index]
            }
        }
    }
    func resetMtiles()
    {
        var index:Int
        for i in 0..dimension {
            for j in 0..dimension {
                index = self.dimension * i + j
                mtiles[index] = tiles[index]
            }
        }
    }
    
    //是否满了
    func isFull()->Bool
    {
        if emptyPositions().count == 0
        {
            return true
        }
        return false
    }
    func setPosition(row:Int, col:Int, value:Int) -> Bool
    {
        assert(row >= 0 && row < dimension)
        assert(col >= 0 && col < dimension)
        var index = self.dimension * row + col
        var val = tiles[index]
        if val > 0
        {
            println("该位置已经有值啦！")
            return false
        }
        println(val)
        tiles[index] = value
        return true
    }
    //找出空位置
    func emptyPositions() -> Int[]
    {
        var emptytiles = Array<Int>()
        var index:Int
        for i in 0..dimension {
            for j in 0..dimension {
                index = self.dimension * i + j
                if tiles[index] == 0
                {
                    emptytiles += index
                }
            }
        }
        return emptytiles
    }
    //对数据进行重排
    
    func reflowUp() -> Bool
    {
        var reflowed:Bool = false
        resetMtiles()
        var index:Int
        for var i=dimension-1; i>0; i-- {
            for j in 0..dimension {
                index = self.dimension * i + j
                if (mtiles[index-self.dimension] == 0)
                   && (mtiles[index] > 0)
                {
                    mtiles[index-self.dimension] = mtiles[index]
                    mtiles[index] = 0
                    var subindex:Int = index
                    reflowed = true
                    //对后面的内容进行检查
                    while((subindex+self.dimension)<mtiles.count)
                    {
                        if (mtiles[subindex+self.dimension]>0)
                        {
                            mtiles[subindex] = mtiles[subindex+self.dimension]
                            mtiles[subindex+self.dimension] = 0
                        }
                        subindex += self.dimension
                    }
                    
                }
            }
        }
        copyMtiles()
        return reflowed
    }
    
    func reflowDown() -> Bool
    {
        var reflowed:Bool = false
        resetMtiles()
        var index:Int
        for i in 0..dimension-1 {
            for j in 0..dimension {
                index = self.dimension * i + j
                if (mtiles[index+self.dimension] == 0)
                    && (mtiles[index] > 0)
                {
                    mtiles[index+self.dimension] = mtiles[index]
                    mtiles[index] = 0
                    var subindex:Int = index
                    reflowed = true
                    //对后面的内容进行检查
                    while((subindex-self.dimension)>=0)
                    {
                        if (mtiles[subindex-self.dimension]>0)
                        {
                            mtiles[subindex] = mtiles[subindex-self.dimension]
                            mtiles[subindex-self.dimension] = 0
                        }
                        subindex -= self.dimension
                    }
                    
                }
            }
        }
        copyMtiles()
        return reflowed
    }
    
    func reflowLeft() -> Bool
    {
        var reflowed:Bool = false
        resetMtiles()
        var index:Int
        for i in 0..dimension {
            for var j=dimension-1; j>0; j-- {
                index = self.dimension * i + j
                if (mtiles[index-1] == 0)
                    && (mtiles[index] > 0)
                {
                    mtiles[index-1] = mtiles[index]
                    mtiles[index] = 0
                    var subindex:Int = index
                    reflowed = true
                    //对后面的内容进行检查
                    while((subindex+1) < i*dimension+dimension)
                    {
                        if (mtiles[subindex+1]>0)
                        {
                            mtiles[subindex] = mtiles[subindex+1]
                            mtiles[subindex+1] = 0
                        }
                        subindex += 1
                    }
                    
                }
            }
        }
        copyMtiles()
        return reflowed
    }
    
    
    func reflowRight() -> Bool
    {
        var reflowed:Bool = false
        resetMtiles()
        var index:Int
        for i in 0..dimension {
            for j in 0..dimension-1 {
                index = self.dimension * i + j
                if (mtiles[index+1] == 0)
                    && (mtiles[index] > 0)
                {
                    mtiles[index+1] = mtiles[index]
                    mtiles[index] = 0
                    var subindex:Int = index
                    reflowed = true
                    //对后面的内容进行检查
                    while((subindex-1) > i*dimension-1)
                    {
                        if (mtiles[subindex-1]>0)
                        {
                            mtiles[subindex] = mtiles[subindex-1]
                            mtiles[subindex-1] = 0
                        }
                        subindex -= 1
                    }
                    
                }
            }
        }
        copyMtiles()
        return reflowed
    }
    
    func mergeUp() -> Bool
    {
        var merged:Bool = false
        resetMtiles()
        var index:Int
        for var i=dimension-1; i>0; i-- {
            for j in 0..dimension {
                index = self.dimension * i + j
                if (mtiles[index] > 0 && mtiles[index-self.dimension] == mtiles[index])
                {
                    setScore(mtiles[index]*2)
                    mtiles[index-self.dimension] = mtiles[index] * 2
                    mtiles[index] = 0
                    merged = true
                }
            }
        }
        copyMtiles()
        return merged
    }
    
    func mergeDown() -> Bool
    {
        var merged:Bool = false
        resetMtiles()
        var index:Int
        for i in 0..dimension-1 {
            for j in 0..dimension {
                index = self.dimension * i + j
                if (mtiles[index] > 0 && mtiles[index+self.dimension] == mtiles[index])
                {
                    setScore(mtiles[index]*2)
                    mtiles[index+self.dimension] = mtiles[index] * 2
                    mtiles[index] = 0
                    merged = true
                }
            }
        }
        copyMtiles()
        return merged

    }
    
    func mergeLeft() -> Bool
    {
        var merged:Bool = false
        resetMtiles()
        var index:Int
        for i in 0..dimension {
            for var j=dimension-1; j>0; j-- {
                index = self.dimension * i + j
                if (mtiles[index] > 0 && mtiles[index-1] == mtiles[index])
                {
                    setScore(mtiles[index]*2)
                    mtiles[index-1] = mtiles[index] * 2
                    mtiles[index] = 0
                    merged = true
                }
            }
        }
        copyMtiles()
        return merged
    }
    
    func mergeRight()->Bool
    {
        var merged:Bool = false
        resetMtiles()
        var index:Int
        for i in 0..dimension {
            for j in 0..dimension-1 {
                index = self.dimension * i + j
                if (mtiles[index] > 0 && mtiles[index+1] == mtiles[index])
                {
                    setScore(mtiles[index]*2)
                    mtiles[index+1] = mtiles[index] * 2
                    mtiles[index] = 0
                    merged = true
                }
            }
        }
        copyMtiles()
        return merged
    }
}