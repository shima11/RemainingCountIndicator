//
//  RemainingCountIndicator.swift
//  RemainingCountIndicator
//
//  Created by jinsei_shima on 2019/02/18.
//  Copyright © 2019 Jinsei Shima. All rights reserved.
//

import UIKit

public class RemainigCountIndicator: UIView {

    public var remainingCount: Int {
        return numberOfPages - currentProgress
    }

    private var currentProgress: Int {
        didSet {
            #warning("update layout")
        }
    }

    private let numberOfPages: Int

    private let placeholderShapeLayer = CAShapeLayer()
    private let tickShapeLayer = CAShapeLayer()

    private let lineWidth: CGFloat = 8

    public init(numberOfPages: Int, currentProgress: Int = 0) {

        self.numberOfPages = numberOfPages
        self.currentProgress = currentProgress

        super.init(frame: .zero)

        layer.addSublayer(placeholderShapeLayer)
        layer.addSublayer(tickShapeLayer)

        placeholderShapeLayer.fillColor = UIColor.clear.cgColor
        placeholderShapeLayer.strokeColor = UIColor.init(white: 0, alpha: 0.2).cgColor
        placeholderShapeLayer.lineWidth = lineWidth

        tickShapeLayer.fillColor = UIColor.clear.cgColor
        tickShapeLayer.strokeColor = UIColor.init(white: 0, alpha: 0.3).cgColor
        tickShapeLayer.strokeStart = 0
        tickShapeLayer.strokeEnd = 0.2
        tickShapeLayer.lineCap = .round
        tickShapeLayer.lineWidth = lineWidth

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSublayers(of layer: CALayer) {

        super.layoutSublayers(of: layer)

        placeholderShapeLayer.frame = self.layer.bounds
        tickShapeLayer.frame = self.layer.bounds

        let path = UIBezierPath(roundedRect: self.layer.bounds, cornerRadius: .infinity)
        placeholderShapeLayer.path = path.cgPath
        tickShapeLayer.path = path.cgPath
    }


}
