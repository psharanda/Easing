//
//  Copyright © 2024-present, Pavel Sharanda. All rights reserved.
//

import FixFlex
import UIKit

private let PINK_BALL_SIZE: CGFloat = 30.0

class EasingViewController: UIViewController {
    private let chartView = EasingChartView()
    let rectDemoContainer = UIView()

    private let rectDemoView = UIView()

    let transformDemoContainer = UIView()
    private let transformDemoView = UIView()

    private let demoItem: EasingDemoItem

    private var displaylink: CADisplayLink?
    private var startTime: CFTimeInterval = 0

    private var progress: Double = 0 {
        didSet {
            view.setNeedsLayout()
        }
    }

    init(demoItem: EasingDemoItem) {
        self.demoItem = demoItem
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = demoItem.name

        chartView.easing = demoItem.easing
        view.addSubview(chartView)

        view.addSubview(rectDemoContainer)

        view.addSubview(transformDemoContainer)

        view.fx.hstack(Fix(20), Flex(chartView), Fix(20), Fix(rectDemoContainer, PINK_BALL_SIZE), Fix(20))
        view.fx.hstack(Fix(20), Flex(transformDemoContainer), Fix(20))
        view.fx.vstack(startAnchor: view.safeAreaLayoutGuide.topAnchor,
                       endAnchor: view.safeAreaLayoutGuide.bottomAnchor,
                       Fix(20),
                       Flex([chartView, rectDemoContainer]),
                       Fix(20),
                       Flex(transformDemoContainer),
                       Fix(20))

        rectDemoView.backgroundColor = UIColor.systemPink
        rectDemoView.layer.cornerRadius = PINK_BALL_SIZE / 2
        rectDemoContainer.addSubview(rectDemoView)

        transformDemoView.backgroundColor = UIColor.systemMint
        transformDemoContainer.addSubview(transformDemoView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTime = CACurrentMediaTime()
        progress = 0
        let displaylink = CADisplayLink(target: self, selector: #selector(step))
        displaylink.add(to: .current, forMode: .default)
        self.displaylink = displaylink
    }

    override func viewWillDisappear(_: Bool) {
        displaylink?.invalidate()
        displaylink = nil
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let pathBounds = chartView.pathBounds ?? .zero

        let startRect = CGRect(x: 0, y: -pathBounds.minY + chartView.bounds.width - PINK_BALL_SIZE / 2, width: PINK_BALL_SIZE, height: PINK_BALL_SIZE)
        let endRect = CGRect(x: 0, y: -pathBounds.minY - PINK_BALL_SIZE / 2, width: PINK_BALL_SIZE, height: PINK_BALL_SIZE)

        rectDemoView.frame = startRect.interpolate(to: endRect, progress: progress, easing: demoItem.easing)

        let startTransform = CGAffineTransform.identity
        let endTransform = CGAffineTransform(scaleX: 2, y: 2)

        transformDemoView.transform = startTransform.interpolate(to: endTransform, progress: progress, easing: demoItem.easing)

        let size = transformDemoContainer.bounds.height / 4
        transformDemoView.layer.cornerRadius = size / 2
        transformDemoView.bounds = CGRect(x: 0, y: 0, width: size, height: size)
        transformDemoView.center = CGPoint(x: transformDemoContainer.bounds.midX, y: transformDemoContainer.bounds.midY)
    }

    @objc private func step(_: CADisplayLink) {
        let newCurrentTime = CACurrentMediaTime()
        progress = (newCurrentTime - startTime).truncatingRemainder(dividingBy: 1)
    }
}
