//
//  ThreesViewController.swift
//  Runner
//
//  Created by RandomJ on 2018/4/5.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

import UIKit

class ThreesViewController: FlutterViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    private func configUI() {
        let scoreLabel = UILabel(frame: CGRect(x: 100, y: 300, width: 100, height: 30))
        scoreLabel.backgroundColor = UIColor.green
        view.addSubview(scoreLabel)

        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.red
        button.frame = CGRect.init(x: 100, y: 100, width: 100, height: 40)
        view.addSubview(button)
    }
}
