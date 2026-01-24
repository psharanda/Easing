//
//  Copyright © 2024-present, Pavel Sharanda. All rights reserved.
//

import UIKit

open class AdaptiveContentView: UIView {
    private class WorkerLabel: UILabel {
        var contentRectForBounds: ((CGRect) -> CGRect)?

        override init(frame: CGRect) {
            super.init(frame: frame)
            numberOfLines = 0
            isHidden = true
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines _: Int) -> CGRect {
            return contentRectForBounds?(bounds) ?? .zero
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
        workerLabel.contentRectForBounds = { [weak self] bounds in
            self?.contentRect(forBounds: bounds) ?? .zero
        }
        addSubview(workerLabel)

        NSLayoutConstraint.activate([
            workerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            workerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            workerLabel.topAnchor.constraint(equalTo: topAnchor),
            workerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    open func invalidateContentRect() {
        workerLabel.text = workerLabel.text == "a" ? "b" : "a"
    }

    open func contentRect(forBounds bounds: CGRect) -> CGRect {
        return bounds
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return workerLabel.sizeThatFits(size)
    }
}
