//
//  ViewController.swift
//  Demo
//
//  Created by jinsei_shima on 2019/02/18.
//  Copyright © 2019 Jinsei Shima. All rights reserved.
//

import UIKit
import RemainingCountIndicator

class ViewController: UIViewController {

    let remaingCountIndicator = RemainigCountIndicator(numberOfPages: 10, currentProgress: 2)

    override func viewDidLoad() {
        super.viewDidLoad()

        remaingCountIndicator.frame = .init(x: 0, y: 0, width: 60, height: 60)
        remaingCountIndicator.center = view.center
        
        view.addSubview(remaingCountIndicator)

    }


}

