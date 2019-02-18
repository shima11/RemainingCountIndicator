//
//  RemainingCountIndicator.swift
//  RemainingCountIndicator
//
//  Created by jinsei_shima on 2019/02/18.
//  Copyright © 2019 Jinsei Shima. All rights reserved.
//

import UIKit

public class RemainigCountIndicator: UIView {

    enum Behavior {
        case case1 // 残り文字数がborder1以上
        case case2 // 残り文字数が0以上border1以下
        case case3 // 残り文字数がborder2以上0未満
        case case4 // 残り文字数がborder2以下

        static func behavior(remainingCount: Int, border1: Int, border2: Int) -> RemainigCountIndicator.Behavior {

            if remainingCount >= border1 {
                return .case1
            }
            else if remainingCount >= 0 {
                return .case2
            }
            else if remainingCount >= border2 {
                return .case3
            }
            else {
                return .case4
            }
        }
    }

    public var remainingCount: Int {
        return numberOfPages - currentProgress
    }

    public var currentProgress: Int = 0 {
        didSet {

            let behavior = Behavior.behavior(remainingCount: remainingCount, border1: border1, border2: border2)
            switch behavior {
            case .case1:
                print("case1")
                progressShapeLayer.strokeColor = UIColor.init(white: 0, alpha: 0.8).cgColor
            case .case2:
                print("case2")
                progressShapeLayer.strokeColor = UIColor.orange.withAlphaComponent(0.8).cgColor
            case .case3:
                print("case3")
                progressShapeLayer.strokeColor = UIColor.red.withAlphaComponent(0.8).cgColor
            case .case4:
                progressShapeLayer.strokeColor = UIColor.red.withAlphaComponent(0.8).cgColor
                print("case4")
            }

            remainingCountLabel.isHidden = (remainingCount < border1) ? false : true
            placeholderShapeLayer.isHidden = (remainingCount < border2) ? true : false
            progressShapeLayer.isHidden = (remainingCount < border2) ? true : false

            progressShapeLayer.strokeEnd = min(CGFloat(currentProgress) / CGFloat(numberOfPages), 1.0)

            remainingCountLabel.text = "\(remainingCount)"
        }
    }

    private let numberOfPages: Int

    private let border1: Int = 5
    private let border2: Int = -5

    private let lineWidth: CGFloat = 8

    private let placeholderShapeLayer = CAShapeLayer()
    private let progressShapeLayer = CAShapeLayer()
    private let remainingCountLabel = UILabel()

    public init(numberOfPages: Int, currentProgress: Int = 0) {

        self.numberOfPages = numberOfPages
        self.currentProgress = currentProgress

        super.init(frame: .zero)

        layer.addSublayer(placeholderShapeLayer)
        layer.addSublayer(progressShapeLayer)
        addSubview(remainingCountLabel)

        placeholderShapeLayer.fillColor = UIColor.clear.cgColor
        placeholderShapeLayer.strokeColor = UIColor.init(white: 0, alpha: 0.2).cgColor
        placeholderShapeLayer.lineWidth = lineWidth

        progressShapeLayer.fillColor = UIColor.clear.cgColor
        progressShapeLayer.strokeColor = UIColor.init(white: 0, alpha: 0.3).cgColor
        progressShapeLayer.strokeStart = 0
        progressShapeLayer.strokeEnd = 0
        progressShapeLayer.lineCap = .round
        progressShapeLayer.lineWidth = lineWidth

        remainingCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        remainingCountLabel.textColor = UIColor.darkText

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {

        super.layoutSubviews()

        remainingCountLabel.center = center
    }

    public override func layoutSublayers(of layer: CALayer) {

        super.layoutSublayers(of: layer)

        placeholderShapeLayer.frame = self.layer.bounds
        progressShapeLayer.frame = self.layer.bounds

        let path = UIBezierPath(roundedRect: self.layer.bounds, cornerRadius: .infinity)
        placeholderShapeLayer.path = path.cgPath
        progressShapeLayer.path = path.cgPath
    }


}
