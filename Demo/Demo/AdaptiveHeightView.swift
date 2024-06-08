//
//  Copyright © 2024-present, Pavel Sharanda. All rights reserved.
//

import UIKit

open class AdaptiveHeightView: UIView {
    private class WorkerLabel: UILabel {
        var layoutSubviewsForWidth: ((CGFloat) -> CGFloat)?

        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }

        private func commonInit() {
            numberOfLines = 0
        }

        override func draw(_: CGRect) {}

        override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines _: Int) -> CGRect {
            let size = bounds.size
            if size.width > 10000 {
                return bounds
            }
            let resultSize = layoutSubviewsForWidth?(size.width) ?? 0
            return CGRect(origin: .zero, size: CGSize(width: size.width, height: resultSize))
        }
    }

    private let workerLabel = WorkerLabel()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        workerLabel.translatesAutoresizingMaskIntoConstraints = false
        workerLabel.layoutSubviewsForWidth = { [weak self] width in
            self?.layoutSubviews(forWidth: width) ?? 0
        }
        addSubview(workerLabel)

        NSLayoutConstraint.activate([
            workerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            workerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            workerLabel.topAnchor.constraint(equalTo: topAnchor),
            workerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    open func setNeedsLayoutSubviewsForWidth() {
        workerLabel.text = "\(arc4random())"
    }

    open func layoutSubviews(forWidth _: CGFloat) -> CGFloat {
        return 0
    }
}
