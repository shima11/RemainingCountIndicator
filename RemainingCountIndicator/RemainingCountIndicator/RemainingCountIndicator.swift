//
//  RemainingCountIndicator.swift
//  RemainingCountIndicator
//
//  Created by jinsei_shima on 2019/02/18.
//  Copyright © 2019 Jinsei Shima. All rights reserved.
//

import UIKit

public final class RemainigCountIndicator: UIView {

    enum Behavior {
        case case1 // 残り文字数がborder1以上
        case case2 // 残り文字数が0以上border1以下
        case case3 // 残り文字数がborder2以上0未満
        case case4 // 残り文字数がborder2以下

        init(remainingCount: Int, threshold1: Int, threshold2: Int) {

            if remainingCount > threshold1 {
                self = .case1
            }
            else if remainingCount > 0 {
                self = .case2
            }
            else if remainingCount > threshold2 {
                self = .case3
            }
            else {
                self = .case4
            }
        }
    }

    private enum Style {

        static let progressNormalColor = UIColor.init(white: 0, alpha: 0.8)
        static let progressWarningColor = UIColor.orange
        static let progressErrorColor = UIColor.red

        static let placeholderColor = UIColor.init(white: 0, alpha: 0.2)

        static let remainingTextColor = UIColor.darkGray.withAlphaComponent(0.8)
        static let remainingTextErrorColor = UIColor.red

        static let remainingTextFont = UIFont.systemFont(ofSize: 12, weight: .medium)
    }

    public struct Config {

        let threshold1: Int
        let threshold2: Int

        let lineWidth: CGFloat

        public init(threshold1: Int, threshold2: Int, lineWidth: CGFloat) {

            #warning("assert")
            #warning("threathhold or different interface")

            self.threshold1 = threshold1
            self.threshold2 = threshold2
            self.lineWidth = lineWidth
        }
    }

    final class IndicatorView: UIView {

        private let placeholderShapeLayer = CAShapeLayer()
        private let progressShapeLayer = CAShapeLayer()

        init(config: Config) {

            super.init(frame: .zero)

            layer.addSublayer(placeholderShapeLayer)
            layer.addSublayer(progressShapeLayer)

            placeholderShapeLayer.fillColor = UIColor.clear.cgColor
            placeholderShapeLayer.strokeColor = Style.placeholderColor.cgColor
            placeholderShapeLayer.lineWidth = config.lineWidth

            progressShapeLayer.fillColor = UIColor.clear.cgColor
            progressShapeLayer.strokeStart = 0
            progressShapeLayer.strokeEnd = 0
            progressShapeLayer.lineCap = .round
            progressShapeLayer.lineWidth = config.lineWidth

        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func layoutSublayers(of layer: CALayer) {

            super.layoutSublayers(of: layer)

            placeholderShapeLayer.frame = layer.bounds
            progressShapeLayer.frame = layer.bounds

            let path = UIBezierPath(roundedRect: layer.bounds, cornerRadius: .infinity)
            placeholderShapeLayer.path = path.cgPath
            progressShapeLayer.path = path.cgPath
        }

        func set(behavior: Behavior, currentNumber: Int, maximumNumber: Int) {

            switch behavior {
            case .case1:
                progressShapeLayer.strokeColor = Style.progressNormalColor.cgColor
                progressShapeLayer.isHidden = false
                placeholderShapeLayer.isHidden = false
            case .case2:
                progressShapeLayer.strokeColor = Style.progressWarningColor.cgColor
                progressShapeLayer.isHidden = false
                placeholderShapeLayer.isHidden = false
            case .case3:
                progressShapeLayer.strokeColor = Style.progressErrorColor.cgColor
                progressShapeLayer.isHidden = false
                placeholderShapeLayer.isHidden = false
            case .case4:
                progressShapeLayer.strokeColor = Style.progressErrorColor.cgColor
                progressShapeLayer.isHidden = true
                placeholderShapeLayer.isHidden = true
            }

            progressShapeLayer.strokeEnd = min(CGFloat(currentNumber) / CGFloat(maximumNumber), 1.0)
        }
    }

    override public class var requiresConstraintBasedLayout: Bool {
        return true
    }

    public var remainingCount: Int {
        return maximumNumber - currentNumber
    }

    public var currentNumber: Int = 0 {
        didSet {

            let behavior = Behavior.init(remainingCount: remainingCount, threshold1: config.threshold1, threshold2: config.threshold2)

            indicatorView.set(behavior: behavior, currentNumber: currentNumber, maximumNumber: maximumNumber)

            switch behavior {
            case .case1:
                remainingCountLabel.textColor = Style.remainingTextColor
                remainingCountLabel.isHidden = true
            case .case2:
                remainingCountLabel.textColor = Style.remainingTextColor
                remainingCountLabel.isHidden = false
            case .case3:
                remainingCountLabel.textColor = Style.remainingTextErrorColor
                remainingCountLabel.isHidden = false
            case .case4:
                remainingCountLabel.textColor = Style.remainingTextErrorColor
                remainingCountLabel.isHidden = false
            }

            // for digit overflow
            if (-99...99).contains(remainingCount) {
                remainingCountLabel.text = "\(remainingCount)"
                remainingCountLabel.sizeToFit()
                invalidateIntrinsicContentSize()
            }
        }
    }

    private let maximumNumber: Int

    private let indicatorView: IndicatorView
    private let remainingCountLabel = UILabel()

    private let config: Config

    #warning("add feedback when change state, ex. animation, hapticfeedback like twitter")

    public init(maximumNumber: Int, config: Config) {

        self.maximumNumber = maximumNumber
        self.config = config

        self.indicatorView = .init(config: config)

        super.init(frame: .zero)

        addSubview(indicatorView)
        addSubview(remainingCountLabel)

        remainingCountLabel.font = Style.remainingTextFont

        indicatorView.setContentCompressionResistancePriority(.required, for: .horizontal)
        indicatorView.setContentHuggingPriority(.required, for: .horizontal)

        [
        indicatorView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
        indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        remainingCountLabel.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 0),
        remainingCountLabel.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: 0),
        indicatorView.widthAnchor.constraint(equalToConstant: 24),
        indicatorView.heightAnchor.constraint(equalToConstant: 24),
        indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor)
            ].forEach { $0.isActive = true }

        let a = indicatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
        a.isActive = true
        a.priority = .defaultHigh

        let b = indicatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
        b.isActive = true
        b.priority = .defaultHigh


//        indicatorView.easy.layout(
//            Top(),
//            Bottom(),
//            Left().with(.high),
//            Right().with(.high),
//            Left(>=0),
//            Right(<=0),
//            Size(24),
//            CenterX()
//        )

        remainingCountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        remainingCountLabel.setContentHuggingPriority(.required, for: .horizontal)


        [
            remainingCountLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 0),
            remainingCountLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: 0),
            remainingCountLabel.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 0),
            remainingCountLabel.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: 0),
            remainingCountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            remainingCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ].forEach { $0.isActive = true }

//        remainingCountLabel.easy.layout(
//            Top(>=0),
//            Bottom(<=0),
//            Left(>=0),
//            Right(<=0),
//            Center()
//        )

        setContentHuggingPriority(.required, for: .horizontal)

    }



    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var intrinsicContentSize: CGSize {
        return .init(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }

}
