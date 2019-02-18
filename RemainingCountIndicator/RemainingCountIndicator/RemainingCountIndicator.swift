//
//  RemainingCountIndicator.swift
//  RemainingCountIndicator
//
//  Created by jinsei_shima on 2019/02/18.
//  Copyright © 2019 Jinsei Shima. All rights reserved.
//

import UIKit

public final class RemainigCountIndicator: UIView {

    private enum Behavior {
        case case1 // 残り文字数がborder1以上
        case case2 // 残り文字数が0以上border1以下
        case case3 // 残り文字数がborder2以上0未満
        case case4 // 残り文字数がborder2以下

        init(remainingCount: Int, border1: Int, border2: Int) {

            if remainingCount > border1 {
                self = .case1
            }
            else if remainingCount > 0 {
                self = .case2
            }
            else if remainingCount > border2 {
                self = .case3
            }
            else {
                self = .case4
            }
        }
    }

    private enum Config {

        #warning("Make it settable from outside.")

        static let progressNormalColor = UIColor.init(white: 0, alpha: 0.8).cgColor
        static let progressWarningColor = UIColor.orange.cgColor
        static let progressErrorColor = UIColor.red.cgColor

        static let placeholderColor = UIColor.init(white: 0, alpha: 0.2).cgColor

        static let remainingTextColor = UIColor.darkGray.withAlphaComponent(0.8)
        static let remainingTextErrorColor = UIColor.red

        static let remainingTextFont = UIFont.systemFont(ofSize: 14, weight: .regular)

        static let border1: Int = 5
        static let border2: Int = -5

        static let lineWidth: CGFloat = 6
    }

    public var remainingCount: Int {
        return maximumNumber - currentNumber
    }

    public var currentNumber: Int = 0 {
        didSet {

            let behavior = Behavior.init(remainingCount: remainingCount, border1: Config.border1, border2: Config.border2)
            switch behavior {
            case .case1:
                progressShapeLayer.strokeColor = Config.progressNormalColor
                remainingCountLabel.textColor = Config.remainingTextColor
                remainingCountLabel.isHidden = true
                placeholderShapeLayer.isHidden = false
                progressShapeLayer.isHidden = false
            case .case2:
                progressShapeLayer.strokeColor = Config.progressWarningColor
                remainingCountLabel.textColor = Config.remainingTextColor
                remainingCountLabel.isHidden = false
                placeholderShapeLayer.isHidden = false
                progressShapeLayer.isHidden = false
            case .case3:
                progressShapeLayer.strokeColor = Config.progressErrorColor
                remainingCountLabel.textColor = Config.remainingTextErrorColor
                remainingCountLabel.isHidden = false
                placeholderShapeLayer.isHidden = false
                progressShapeLayer.isHidden = false
            case .case4:
                progressShapeLayer.strokeColor = Config.progressErrorColor
                remainingCountLabel.textColor = Config.remainingTextErrorColor
                remainingCountLabel.isHidden = false
                placeholderShapeLayer.isHidden = true
                progressShapeLayer.isHidden = true
            }

            progressShapeLayer.strokeEnd = min(CGFloat(currentNumber) / CGFloat(maximumNumber), 1.0)

            remainingCountLabel.text = "\(remainingCount)"
            remainingCountLabel.sizeToFit()
        }
    }

    private let maximumNumber: Int

    private let placeholderShapeLayer = CAShapeLayer()
    private let progressShapeLayer = CAShapeLayer()
    private let remainingCountLabel = UILabel()

    public init(maximumNumber: Int, currentNumber: Int = 0) {

        self.maximumNumber = maximumNumber
        self.currentNumber = currentNumber

        super.init(frame: .zero)

        layer.addSublayer(placeholderShapeLayer)
        layer.addSublayer(progressShapeLayer)
        addSubview(remainingCountLabel)

        placeholderShapeLayer.fillColor = UIColor.clear.cgColor
        placeholderShapeLayer.strokeColor = Config.placeholderColor
        placeholderShapeLayer.lineWidth = Config.lineWidth

        progressShapeLayer.fillColor = UIColor.clear.cgColor
        progressShapeLayer.strokeStart = 0
        progressShapeLayer.strokeEnd = 0
        progressShapeLayer.lineCap = .round
        progressShapeLayer.lineWidth = Config.lineWidth

        remainingCountLabel.font = Config.remainingTextFont

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {

        super.layoutSubviews()

        remainingCountLabel.center = .init(x: bounds.width / 2, y: bounds.height / 2)
    }

    public override func layoutSublayers(of layer: CALayer) {

        super.layoutSublayers(of: layer)

        placeholderShapeLayer.frame = layer.bounds
        progressShapeLayer.frame = layer.bounds

        let path = UIBezierPath(roundedRect: layer.bounds, cornerRadius: .infinity)
        placeholderShapeLayer.path = path.cgPath
        progressShapeLayer.path = path.cgPath
    }

}
