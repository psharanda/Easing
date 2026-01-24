//
//  Copyright © 2024-present, Pavel Sharanda. All rights reserved.
//

import FixFlex
import UIKit

class EasingChartView: AdaptiveContentView {
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
            invalidateContentRect()
        }
    }

    override func contentRect(forBounds bounds: CGRect) -> CGRect {
        if bounds.width > UIView.layoutFittingExpandedSize.width {
            return bounds
        }

        let chartWidth = bounds.width - 2

        let xAxisPath = UIBezierPath()
        xAxisPath.move(to: CGPoint(x: 0, y: chartWidth))
        xAxisPath.addLine(to: CGPoint(x: chartWidth, y: chartWidth))
        xAxisLayer.path = xAxisPath.cgPath

        let yAxisPath = UIBezierPath()
        yAxisPath.move(to: .zero)
        yAxisPath.addLine(to: CGPoint(x: 0, y: chartWidth))
        yAxisLayer.path = yAxisPath.cgPath

        guard let easing else {
            easingLayer.path = nil
            xAxisLayer.bounds = .zero
            yAxisLayer.bounds = .zero
            return .zero
        }

        let easingPath = UIBezierPath()
        easingPath.move(to: CGPoint(x: 0, y: chartWidth))

        var x = 0.0
        while x <= chartWidth {
            let progress = x / chartWidth
            let y = chartWidth - easing.calculate(progress) * chartWidth

            easingPath.addLine(to: CGPoint(x: x, y: y))
            x += 1
        }

        easingLayer.path = easingPath.cgPath

        let pathBounds = easingPath.bounds

        xAxisLayer.frame = CGRect(x: 1, y: -pathBounds.minY + 1, width: 0, height: 0)
        yAxisLayer.frame = CGRect(x: 1, y: -pathBounds.minY + 1, width: 0, height: 0)
        easingLayer.frame = CGRect(x: 1, y: -pathBounds.minY + 1, width: 0, height: 0)

        self.pathBounds = pathBounds

        return CGRect(x: 0, y: 0, width: bounds.width, height: pathBounds.height + 2)
    }

    var pathBounds: CGRect?
}
