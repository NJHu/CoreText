//
//  DYNCTextCell.swift
//  NJiOSCoreText
//
//  Created by HuXuPeng on 2019/6/3.
//  Copyright © 2019年 hupeng. All rights reserved.
//

import UIKit

let margin: CGFloat = 10.0;

class DYNCTextCell: UITableViewCell {
    
   private lazy var contentAttLabel: UILabel = {
        var label = UILabel()
        self.contentView.addSubview(label)
        label.frame = CGRect(origin: CGPoint(x: margin, y: margin), size: CGSize(width: UIScreen.main.bounds.size.width - CGFloat(2 * margin), height: 1))
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width - CGFloat(2 * margin)
        return label;
    }()
    
    private lazy var ncLabel: DYNCLabel = {
       var label = DYNCLabel()
        self.contentView.addSubview(label)
        label.frame = CGRect(origin: CGPoint(x: margin, y: margin), size: CGSize(width: UIScreen.main.bounds.size.width - CGFloat(2 * margin), height: 10))
        return label;
    }()
    
   public var paragraph: DYNCParagraph? {
        didSet {

            var frame = contentAttLabel.frame
            frame.size.height = paragraph?.contentHeight ?? 0
            contentAttLabel.frame = frame
            
            contentAttLabel.attributedText = paragraph?.contentText
        }
    }
    
    public var coreText_paragraph: DYNCParagraph? {
        didSet {
            var frame = ncLabel.frame
            frame.size.height = coreText_paragraph?.contentHeight ?? 0
            ncLabel.frame = frame
            
            ncLabel.coreText_paragraph = coreText_paragraph
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}

extension DYNCTextCell
{
    private func setupUI()
    {
        selectionStyle = .none
    }
}

extension DYNCTextCell
{
   public static func cell(tableView: UITableView) -> DYNCTextCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(self))
        if cell == nil {
            cell = DYNCTextCell(style: .default, reuseIdentifier: NSStringFromClass(self))
        }
        return cell as! DYNCTextCell
    }
}
