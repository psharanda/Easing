//
//  Copyright © 2024-present, Pavel Sharanda. All rights reserved.
//

import FixFlex
import UIKit

class EasingChartView: AdaptiveHeightView {
    private let easingLayer = CAShapeLayer()
    private let xAxisLayer = CAShapeLayer()
    private let yAxisLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        xAxisLayer.fillColor = nil
        layer.addSublayer(xAxisLayer)

        yAxisLayer.fillColor = nil
        layer.addSublayer(yAxisLayer)

        easingLayer.fillColor = nil
        layer.addSublayer(easingLayer)
        updateColors()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColors()
    }

    private func updateColors() {
        xAxisLayer.strokeColor = UIColor.label.withAlphaComponent(0.2).cgColor
        yAxisLayer.strokeColor = UIColor.label.withAlphaComponent(0.2).cgColor
        easingLayer.strokeColor = UIColor.label.cgColor
    }

    var easing: Easing? {
        didSet {
            setNeedsLayoutSubviewsForWidth()
        }
    }

    override func layoutSubviews(forWidth width: CGFloat) -> CGFloat {
        let xAxisPath = UIBezierPath()
        xAxisPath.move(to: CGPoint(x: 0, y: width))
        xAxisPath.addLine(to: CGPoint(x: width, y: width))
        xAxisLayer.path = xAxisPath.cgPath

        let yAxisPath = UIBezierPath()
        yAxisPath.move(to: .zero)
        yAxisPath.addLine(to: CGPoint(x: 0, y: width))
        yAxisLayer.path = yAxisPath.cgPath

        guard let easing else {
            easingLayer.path = nil
            xAxisLayer.bounds = .zero
            yAxisLayer.bounds = .zero
            return .zero
        }

        let easingPath = UIBezierPath()
        easingPath.move(to: CGPoint(x: 0, y: width))

        var x = 0.0
        while x <= width {
            let progress = x / width
            let y = width - easing.calculate(progress) * width

            easingPath.addLine(to: CGPoint(x: x, y: y))
            x += 1
        }

        easingLayer.path = easingPath.cgPath

        let pathBounds = easingPath.bounds

        xAxisLayer.frame = CGRect(x: 0, y: -pathBounds.minY, width: 0, height: 0)
        yAxisLayer.frame = CGRect(x: 0, y: -pathBounds.minY, width: 0, height: 0)
        easingLayer.frame = CGRect(x: 0, y: -pathBounds.minY, width: 0, height: 0)

        self.pathBounds = pathBounds

        return easingPath.bounds.size.height
    }

    var pathBounds: CGRect?
}
