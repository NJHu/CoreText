//
//  DYNCArticle.swift
//  NJiOSCoreText
//
//  Created by HuXuPeng on 2019/6/3.
//  Copyright © 2019年 hupeng. All rights reserved.
//

import UIKit
import CoreText

class DYNCImageCoreData {
    var name: String?
    var location: Int = 0
    var imagePosition: CGRect?
    var size: CGSize?
}

class DYNCParagraph {
    var contentHeight: CGFloat = 0
    var contentText: NSAttributedString?
    var ctFrame: CTFrame?
    var imagesCoreDatas: [DYNCImageCoreData]?
    init(text: String) {
       contentText = DYNCTextTool.replaceMarriedImages(contentText: text)

        // 解析链接, 并添加点击事件
        
        // 解析话题, 并添加点击事件
                
        let maxSize = CGSize(width: UIScreen.main.bounds.size.width - CGFloat(10.0 * 2), height: CGFloat(MAXFLOAT))
        contentHeight = (contentText?.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size.height ?? 0)
        contentHeight = ceil(contentHeight)
    }
    
    
    init(coreTextText: String) {
        
        let data = DYNCCoreTextTool.replaceMarriedImages(contentText: coreTextText)
        guard let cfAttString = data.cfAttStr else {
            return
            
        }
        
        let framesetter = CTFramesetterCreateWithAttributedString(cfAttString);
        let coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSize(width: UIScreen.main.bounds.size.width - CGFloat(10.0 * 2), height: CGFloat.greatestFiniteMagnitude), nil)
        
        let path = CGMutablePath()
        contentHeight = coreTextSize.height + 10
        path.addRect(CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - CGFloat(10.0 * 2), height: contentHeight))
        
        let actframe = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path, nil)
        
        self.ctFrame = actframe
        
        imagesCoreDatas = data.imageDatas
        fillImagePosition()
    }
    
    
    func fillImagePosition() -> Void {
        guard let imagesCoreData = self.imagesCoreDatas else {
                return
        }
        guard let myCtFrame = self.ctFrame else {
            return
            
        }
        
        var lines = CTFrameGetLines(myCtFrame)
        var lineCount = CFArrayGetCount(lines)
        var lineOrigins = [CGPoint](repeating: CGPoint.zero, count:lineCount)
        CTFrameGetLineOrigins(myCtFrame, CFRangeMake(0, 0), &lineOrigins)
        
        
        var imgIndex: Int = 0;
        var imageData: DYNCImageCoreData? = imagesCoreData[0];
        
        for index in 0..<lineCount {
            if imageData == nil {
                break
            }
            imageData = imagesCoreData[index]
            
            var line = Unmanaged<CTLine>.fromOpaque(CFArrayGetValueAtIndex(lines, index)).takeUnretainedValue() as! CTLine
            
            var runObjArray = CTLineGetGlyphRuns(line)
            var runCount = CFArrayGetCount(runObjArray)
            for runIndex in 0..<runCount {
                var runObj = Unmanaged<CTRun>.fromOpaque(CFArrayGetValueAtIndex(runObjArray, runIndex)).takeUnretainedValue() as! CTRun
                
                
                var runBounds: CGRect = CGRect.zero
                var ascent: CGFloat = 0
                var descent: CGFloat = 0
                
//                runBounds.size.width = CGFloat(CTRunGetTypographicBounds(runObj, CFRangeMake(0, 0), &ascent, &descent, nil))
//                runBounds.size.height = ascent + descent
                runBounds.size.width = 20
                runBounds.size.height = 14
                
                var xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(runObj).location, nil)
                runBounds.origin.x = lineOrigins[index].x + xOffset;
                runBounds.origin.y = lineOrigins[index].y;
                runBounds.origin.y -= descent;
                
                var path = CTFrameGetPath(myCtFrame)
                var colRect = path.boundingBox
                var delegateBounds = runBounds.offsetBy(dx: colRect.origin.x, dy: colRect.origin.y)
                imageData?.imagePosition = delegateBounds
            }
        }
    }
}

class DYNCCoreTextTool{
    
    static func replaceMarriedImages(contentText: String) ->  (cfAttStr: CFAttributedString?, imageDatas: [DYNCImageCoreData]?) {
        
        let font = UIFont.systemFont(ofSize: 14)
        
        let contentTextM = NSMutableAttributedString(string: contentText, attributes: [kCTFontAttributeName as NSAttributedString.Key : CTFontCreateWithName(font.fontName as CFString, 14, nil), kCTForegroundColorAttributeName as NSAttributedString.Key: UIColor.white.cgColor])
        
        // 匹配链接
        guard let urlRegex = try? NSRegularExpression(pattern: "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)", options: NSRegularExpression.Options.caseInsensitive) else {
            return (nil, nil)
        }
        let urlResults = urlRegex.matches(in: contentText, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: contentText.count))
        urlResults.forEach { (urlResult) in
//            let range = Range(urlResult.range, in: contentText)!
//            let regUrlStr = String(contentText[range])
            contentTextM.addAttributes([kCTForegroundColorAttributeName as NSAttributedString.Key: UIColor.red.cgColor], range: urlResult.range)
        }
        
        // 匹配话题
        guard let topicRegex = try? NSRegularExpression(pattern: "\\#.*?\\#", options: NSRegularExpression.Options.caseInsensitive) else {
            return (nil, nil)
        }
        let topicResults = topicRegex.matches(in: contentText, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: contentText.count))
        
        topicResults.forEach { (topicReslut) in
            //            let range = Range(topicReslut.range, in: contentText)!
            //            let topicUrlStr = String(contentText[range])
            contentTextM.addAttributes([kCTForegroundColorAttributeName as NSAttributedString.Key: UIColor.red.cgColor, kCTFontAttributeName as NSAttributedString.Key : CTFontCreateWithName(font.fontName as CFString, 16, nil)], range: topicReslut.range)
        }
        
        var coreImageData = [DYNCImageCoreData]()
        // 解析贵族
        // 解析勋章等级
        // 解析用户等级
        // 解析斗鱼表情
        guard let regex = try? NSRegularExpression(pattern: "\\[.*?\\]", options: NSRegularExpression.Options.caseInsensitive) else {
            return (nil, nil);
        }
        
        let results = regex.matches(in: contentText, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: contentText.count))
        
        results.reversed().forEach { (reslut) in
            
            let range = Range(reslut.range, in: contentText)!
            let regImageStr = String(contentText[range])
            let imageName = self.imageBy(imageStr: regImageStr)
            
            if imageName != nil {
                let imageCoreData = DYNCImageCoreData()
                imageCoreData.location = reslut.range.location
                imageCoreData.name = imageName
                imageCoreData.size = CGSize(width: 20, height: 15)
                coreImageData.append(imageCoreData)
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
        contentTextM.addAttributes([kCTParagraphStyleAttributeName as NSAttributedString.Key : paragraphStyle], range: NSRange(location: 0, length: contentTextM.length))
        
        return (contentTextM as CFAttributedString, coreImageData)
    }
    
    static func imageBy(imageStr: String) -> String? {
        let imageName = imageStr.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        return imageName
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
        
        contentTextM.addAttributes([NSAttributedString.Key.backgroundColor : UIColor.white], range: NSRange(location: 0, length: contentTextM.length))
        
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
