//
//  ViewController.swift
//  NJiOSCoreText
//
//  Created by HuXuPeng on 2019/6/3.
//  Copyright © 2019年 hupeng. All rights reserved.
//

import UIKit

class DYNCViewController: UIViewController {

    lazy var tableView: UITableView = {
       let tableView = UITableView(frame: view.bounds, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.blue
        return tableView
    }()
    var articles: [DYNCParagraph] = [DYNCParagraph]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 90, width: view.bounds.width, height: view.bounds.height - 200)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getData()
    }
}



extension DYNCViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return articles[indexPath.row].contentHeight + 20
    }
}

extension DYNCViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let textCell = DYNCTextCell.cell(tableView: tableView)
        // TextKit,set赋值
        textCell.paragraph = articles[indexPath.row]
        // CoreText, set赋值
//        textCell.coreText_paragraph = articles[indexPath.row]
        return textCell
    }
}

extension DYNCViewController {
    func getData() -> Void {
      let path =  Bundle.main.path(forResource: "articles", ofType: "json")
        let dataArray = try? JSONSerialization.jsonObject(with: Data.init(contentsOf: URL.init(fileURLWithPath: path!), options: Data.ReadingOptions.alwaysMapped), options: JSONSerialization.ReadingOptions.allowFragments)
        
        for data in (dataArray as! [[String: String]]) {
            // TextKit 数据初始化
            let p: DYNCParagraph = DYNCParagraph(text: (data["content"])!)
            // CoreText 数据初始化
//            let p: DYNCParagraph = DYNCParagraph(coreTextText: (data["content"])!)
            articles.append(p)
        }
        tableView.reloadData()
        print(articles)
    }
    
}
