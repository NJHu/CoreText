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
        contentText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
        let maxSize = CGSize(width: UIScreen.main.bounds.size.width - CGFloat(10.0 * 2), height: CGFloat(MAXFLOAT))
        contentHeight = (contentText?.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size.height ?? 0) + 20
    }
}
