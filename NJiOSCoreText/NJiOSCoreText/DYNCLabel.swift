//
//  DYNCLabel.swift
//  NJiOSCoreText
//
//  Created by HuXuPeng on 2019/6/4.
//  Copyright © 2019年 hupeng. All rights reserved.
//

import UIKit

class DYNCLabel: UIView {
    
    public var coreText_paragraph: DYNCParagraph? {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let aaCTFrame = self.coreText_paragraph?.ctFrame else {
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
        
        guard let imagesCoreDatas = self.coreText_paragraph?.imagesCoreDatas else {
            return
            
        }
        
        /// 几个图片随意放些位置
        var index = 0
        for imageData in imagesCoreDatas {
            guard let image1 = UIImage(named: imageData.name!)?.cgImage else {
                continue
            }
            switch index {
            case 0:
                textContext.draw(image1, in: CGRect(x: 150, y: 8, width: 20, height: 14))
                break
            case 1:
                textContext.draw(image1, in: CGRect(x: 10, y: 8, width: 20, height: 14))
                break
            case 2:
                textContext.draw(image1, in: CGRect(x: 35, y: 8, width: 20, height: 14))
                break
            case 3:
                textContext.draw(image1, in: CGRect(x: 60, y: 8, width: 20, height: 14))
                break
            case 4:
                textContext.draw(image1, in: CGRect(x: 85, y: 8, width: 20, height: 14))
                break
            case 5:
                textContext.draw(image1, in: CGRect(x: 10, y: 30, width: 20, height: 14))
                break
            case 6:
                textContext.draw(image1, in: CGRect(x: 35, y: 30, width: 20, height: 14))
                break
            case 7:
                textContext.draw(image1, in: CGRect(x: 60, y: 30, width: 20, height: 14))
                break
            case 8:
                textContext.draw(image1, in: CGRect(x: 85, y: 30, width: 20, height: 14))
                break
            case 9:
                textContext.draw(image1, in: CGRect(x: 120, y: 30, width: 20, height: 14))
                break
            default:
                break
            }
            
            index += 1
        }
    }
}
