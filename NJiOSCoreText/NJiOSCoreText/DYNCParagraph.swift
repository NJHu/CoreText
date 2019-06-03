//
//  DYNCArticle.swift
//  NJiOSCoreText
//
//  Created by HuXuPeng on 2019/6/3.
//  Copyright © 2019年 hupeng. All rights reserved.
//

import UIKit

class DYNCParagraph {
    var contentHeight: CGFloat = 0
    var contentText: NSAttributedString?
    init(text: String) {
       contentText = DYNCTextTool.replaceMarriedImages(contentText: text)

        // 解析链接, 并添加点击事件
        
        // 解析话题, 并添加点击事件
                
        let maxSize = CGSize(width: UIScreen.main.bounds.size.width - CGFloat(10.0 * 2), height: CGFloat(MAXFLOAT))
        contentHeight = (contentText?.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size.height ?? 0) + 20
    }
}


class DYNCTextTool {
    static func replaceMarriedImages(contentText: String) ->  NSAttributedString? {
        
        guard let regex = try? NSRegularExpression(pattern: "\\[.*?\\]", options: NSRegularExpression.Options.caseInsensitive) else {
            return nil;
        }
        
        let contentTextM = NSMutableAttributedString(string: contentText, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
        
        let results = regex.matches(in: contentText, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: contentText.count))
        
        // 解析贵族
        // 解析勋章等级
        // 解析用户等级
        // 解析斗鱼表情
        results.reversed().forEach { (reslut) in
         
            let range = Range(reslut.range, in: contentText)!
            let regImageStr = String(contentText[range])
            let image = self.imageBy(imageStr: regImageStr)
            if image != nil {
                let imageAttStr = self.imageAttStr(image: image!)
                contentTextM.replaceCharacters(in: reslut.range, with: imageAttStr)
            }
        }
        
        return contentTextM
    }
    
    static func imageAttStr(image: UIImage) -> NSAttributedString {
        let att = NSTextAttachment()
        att.image = image
        att.bounds = CGRect(x: 0, y: -4, width: 20, height: UIFont.systemFont(ofSize: 14).lineHeight)
        return NSAttributedString(attachment: att)
    }
    
    static func imageBy(imageStr: String) -> UIImage? {
        
        let imageName = imageStr.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        return UIImage(named: imageName)
    }
}
