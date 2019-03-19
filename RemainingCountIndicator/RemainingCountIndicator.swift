//
//  RemainingCountIndicator.swift
//  RemainingCountIndicator
//
//  Created by jinsei_shima on 2019/02/18.
//  Copyright © 2019 Jinsei Shima. All rights reserved.
//

import UIKit

public final class RemainigCountIndicator: UIView {

    public enum Behavior : Int {
        case case1 // 残り文字数がborder1以上
        case case2 // 残り文字数が0以上border1以下
        case case3 // 残り文字数がborder2以上0未満
        case case4 // 残り文字数がborder2 以下

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

    public struct Style {

        let progressNormalColor: UIColor
        let progressWarningColor: UIColor
        let progressErrorColor: UIColor

        let placeholderColor: UIColor

        let remainingTextColor: UIColor
        let remainingTextErrorColor: UIColor
        let remainingTextFont: UIFont

        let lineWidth: CGFloat

        init(
            progressNormalColor: UIColor = .init(white: 0, alpha: 0.8),
            progressWarningColor: UIColor = .orange,
            progressErrorColor: UIColor = .red,
            placeholderColor: UIColor = .init(white: 0, alpha: 0.2),
            remainingTextColor: UIColor = UIColor.darkGray.withAlphaComponent(0.8),
            remainingTextErrorColor: UIColor = .red,
            remainingTextFont: UIFont = .systemFont(ofSize: 12, weight: .medium),
            lineWidth: CGFloat = 3
            ) {

            self.progressNormalColor = progressNormalColor
            self.progressWarningColor = progressWarningColor
            self.progressErrorColor = progressErrorColor
            self.placeholderColor = placeholderColor
            self.remainingTextColor = remainingTextColor
            self.remainingTextErrorColor = remainingTextErrorColor
            self.remainingTextFont = remainingTextFont
            self.lineWidth = lineWidth
        }
    }

    public struct Config {

        let threshold1: Int
        let threshold2: Int

        public init(threshold1: Int, threshold2: Int) {

            assert(threshold1 > threshold2, "invalid value, threshold2 is smaller than threshold1")

            self.threshold1 = threshold1
            self.threshold2 = threshold2
        }
    }

    private final class IndicatorView: UIView {

        private let placeholderShapeLayer = CAShapeLayer()
        private let progressShapeLayer = CAShapeLayer()

        private let style: Style

        fileprivate init(config: Config, style: Style) {

            self.style = style

            super.init(frame: .zero)

            layer.addSublayer(placeholderShapeLayer)
            layer.addSublayer(progressShapeLayer)

            placeholderShapeLayer.fillColor = UIColor.clear.cgColor
            placeholderShapeLayer.strokeColor = style.placeholderColor.cgColor
            placeholderShapeLayer.lineWidth = style.lineWidth

            progressShapeLayer.fillColor = UIColor.clear.cgColor
            progressShapeLayer.strokeStart = 0
            progressShapeLayer.strokeEnd = 0
            progressShapeLayer.lineCap = .round
            progressShapeLayer.lineWidth = style.lineWidth

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

        private var oldBehavior: Behavior? = nil

        internal func set(behavior: Behavior, currentNumber: Int, maximumNumber: Int, animated: Bool) {

            defer {
                self.oldBehavior = behavior
            }

            // change progress

            progressShapeLayer.strokeEnd = min(CGFloat(currentNumber) / CGFloat(maximumNumber), 1.0)


            switch behavior {
            case .case1:
                progressShapeLayer.strokeColor = style.progressNormalColor.cgColor
            case .case2:
                progressShapeLayer.strokeColor = style.progressWarningColor.cgColor
            case .case3:
                progressShapeLayer.strokeColor = style.progressErrorColor.cgColor
            case .case4:
                progressShapeLayer.strokeColor = style.progressErrorColor.cgColor
            }

            switch behavior {
            case .case1, .case2, .case3:
                progressShapeLayer.isHidden = false
                placeholderShapeLayer.isHidden = false
            case .case4:
                progressShapeLayer.isHidden = true
                placeholderShapeLayer.isHidden = true
            }

            // change animation

            guard
                let oldBehavior = oldBehavior,
                oldBehavior != behavior,
                animated
                else { return }

            if calcurateTransformIfNeeded(oldBehavior: oldBehavior, currentBehavior: behavior) {

                // animation of circle expand

                let animation = CABasicAnimation.init(keyPath: "transform.scale")
                animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
                animation.duration = 0.14
                animation.toValue = 1.06
                animation.isRemovedOnCompletion = false
                animation.autoreverses = true

                progressShapeLayer.add(animation, forKey: "scale")
                placeholderShapeLayer.add(animation, forKey: "scale")

            }

            do {

                // animation of show/hidden

                let animation = CABasicAnimation.init(keyPath: "hidden")
                animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
                animation.duration = 0.3
                animation.fillMode = .forwards
                animation.isRemovedOnCompletion = false

                switch behavior {
                case .case1, .case2, .case3:
                    animation.toValue = false
                case .case4:
                    animation.toValue = true
                }

                progressShapeLayer.add(animation, forKey: "opacity")
                placeholderShapeLayer.add(animation, forKey: "opacity")

            }

        }

        private func calcurateTransformIfNeeded(oldBehavior: Behavior, currentBehavior: Behavior) -> Bool {
            return oldBehavior.rawValue < currentBehavior.rawValue ? true : false
        }

    }

    public override var intrinsicContentSize: CGSize {
        return .init(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }

    override public class var requiresConstraintBasedLayout: Bool {
        return true
    }

    public var remainingCount: Int {
        return maximumNumber - currentNumber
    }

    public var alwaysAnimation: Bool = true

    public var currentNumber: Int = 0 {
        didSet {

            let behavior = Behavior.init(
                remainingCount: remainingCount,
                threshold1: config.threshold1,
                threshold2: config.threshold2
            )

            indicatorView.set(
                behavior: behavior,
                currentNumber: currentNumber,
                maximumNumber: maximumNumber,
                animated: alwaysAnimation
            )

            switch behavior {
            case .case1:
                remainingCountLabel.textColor = style.remainingTextColor
                remainingCountLabel.isHidden = true
            case .case2:
                remainingCountLabel.textColor = style.remainingTextColor
                remainingCountLabel.isHidden = false
            case .case3:
                remainingCountLabel.textColor = style.remainingTextErrorColor
                remainingCountLabel.isHidden = false
            case .case4:
                remainingCountLabel.textColor = style.remainingTextErrorColor
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
    private let style: Style

    public init(maximumNumber: Int, config: Config, style: Style) {

        self.maximumNumber = maximumNumber
        self.config = config
        self.style = style

        self.indicatorView = .init(config: config, style: style)

        super.init(frame: .zero)

        addSubview(indicatorView)
        addSubview(remainingCountLabel)

        remainingCountLabel.font = style.remainingTextFont

        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        remainingCountLabel.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false

        indicatorView.setContentCompressionResistancePriority(.required, for: .horizontal)
        indicatorView.setContentHuggingPriority(.required, for: .horizontal)
        remainingCountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        remainingCountLabel.setContentHuggingPriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .horizontal)

        let indicatorViewLeftAnchor = indicatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
        indicatorViewLeftAnchor.priority = .defaultHigh

        let indicatorViewRightAnchor = indicatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
        indicatorViewRightAnchor.priority = .defaultHigh

        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            indicatorView.widthAnchor.constraint(equalToConstant: 24),
            indicatorView.heightAnchor.constraint(equalToConstant: 24),
            indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorViewLeftAnchor,
            indicatorViewRightAnchor
            ])

        NSLayoutConstraint.activate([
            remainingCountLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 0),
            remainingCountLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: 0),
            remainingCountLabel.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 0),
            remainingCountLabel.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: 0),
            remainingCountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            remainingCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
