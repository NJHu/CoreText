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
        contentHeight = (contentText?.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size.height ?? 0)
        contentHeight = ceil(contentHeight)
    }
}


class DYNCTextTool {
    static func replaceMarriedImages(contentText: String) ->  NSAttributedString? {
        
        let contentTextM = NSMutableAttributedString(string: contentText, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
        
        // 匹配链接
        guard let urlRegex = try? NSRegularExpression(pattern: "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)", options: NSRegularExpression.Options.caseInsensitive) else {
            return nil
        }
        let urlResults = urlRegex.matches(in: contentText, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: contentText.count))
        urlResults.forEach { (urlResult) in
            let range = Range(urlResult.range, in: contentText)!
            let regUrlStr = String(contentText[range])
            contentTextM.addAttributes([NSAttributedString.Key.link : regUrlStr, NSAttributedString.Key.foregroundColor: UIColor.red], range: urlResult.range)
        }
        
        // 匹配话题
        guard let topicRegex = try? NSRegularExpression(pattern: "\\#.*?\\#", options: NSRegularExpression.Options.caseInsensitive) else {
            return nil
        }
        let topicResults = topicRegex.matches(in: contentText, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: contentText.count))
        
        topicResults.forEach { (topicReslut) in
//            let range = Range(topicReslut.range, in: contentText)!
//            let topicUrlStr = String(contentText[range])
            contentTextM.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], range: topicReslut.range)
        }
        
        
        // 解析贵族
        // 解析勋章等级
        // 解析用户等级
        // 解析斗鱼表情
        guard let regex = try? NSRegularExpression(pattern: "\\[.*?\\]", options: NSRegularExpression.Options.caseInsensitive) else {
            return nil;
        }
        
        let results = regex.matches(in: contentText, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: contentText.count))
        
        results.reversed().forEach { (reslut) in
         
            let range = Range(reslut.range, in: contentText)!
            let regImageStr = String(contentText[range])
            let image = self.imageBy(imageStr: regImageStr)
            if image != nil {
                let imageAttStr = self.imageAttStr(image: image!)
                contentTextM.replaceCharacters(in: reslut.range, with: imageAttStr)
            }
        }
        
        // 设置段落
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.paragraphSpacing = 5
        paragraphStyle.alignment = .left
        paragraphStyle.minimumLineHeight = 14
        paragraphStyle.maximumLineHeight = 20
        
        // 设置段落
        contentTextM.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: contentTextM.length))
        
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
