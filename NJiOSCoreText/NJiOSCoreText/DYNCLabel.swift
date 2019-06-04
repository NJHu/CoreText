//
//  DYNCLabel.swift
//  NJiOSCoreText
//
//  Created by HuXuPeng on 2019/6/4.
//  Copyright © 2019年 hupeng. All rights reserved.
//

import UIKit

class DYNCLabel: UIView {
    
    var aCTFrame: CTFrame? {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let aaCTFrame = self.aCTFrame else {
            return
        }

        //获取当前(View)上下文以便于之后的绘画，这个是一个离屏。
        guard let textContext = UIGraphicsGetCurrentContext() else {
            return
        }

        textContext.textMatrix = CGAffineTransform.identity;
        
        //压栈，压入图形状态栈中.每个图形上下文维护一个图形状态栈，并不是所有的当前绘画环境的图形状态的元素都被保存。图形状态中不考虑当前路径，所以不保存
        //保存现在得上下文图形状态。不管后续对context上绘制什么都不会影响真正得屏幕。
        textContext.saveGState()
        
        //x，y轴方向移动
        textContext.translateBy(x: 0, y: rect.height)
        
        //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
        textContext.scaleBy(x: 1.0, y: -1.0)

        CTFrameDraw(aaCTFrame, textContext)
    }
}
