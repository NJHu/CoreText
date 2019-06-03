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
        return tableView
    }()
    var articles: [DYNCParagraph] = [DYNCParagraph]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 90, width: view.bounds.width, height: view.bounds.height - 300)
    }
}

extension DYNCViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension DYNCViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let textCell = DYNCTextCell.cell(tableView: tableView)
        
        return textCell
    }
}

extension DYNCViewController {
    
}
