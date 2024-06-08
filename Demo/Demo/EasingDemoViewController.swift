//
//  Copyright © 2024-present, Pavel Sharanda. All rights reserved.
//

import FixFlex
import UIKit

class EasingDemoViewController: UITableViewController {
    let items = [
        EasingDemoItem(name: "linear", easing: .linear),

        EasingDemoItem(name: "smoothStep", easing: .smoothStep),
        EasingDemoItem(name: "smootherStep", easing: .smootherStep),

        EasingDemoItem(name: "quadraticEaseIn", easing: .quadraticEaseIn),
        EasingDemoItem(name: "quadraticEaseOut", easing: .quadraticEaseOut),
        EasingDemoItem(name: "quadraticEaseInOut", easing: .quadraticEaseInOut),

        EasingDemoItem(name: "cubicEaseIn", easing: .cubicEaseIn),
        EasingDemoItem(name: "cubicEaseOut", easing: .cubicEaseOut),
        EasingDemoItem(name: "cubicEaseInOut", easing: .cubicEaseInOut),

        EasingDemoItem(name: "quarticEaseIn", easing: .quarticEaseIn),
        EasingDemoItem(name: "quarticEaseOut", easing: .quarticEaseOut),
        EasingDemoItem(name: "quarticEaseInOut", easing: .quarticEaseInOut),

        EasingDemoItem(name: "quinticEaseIn", easing: .quinticEaseIn),
        EasingDemoItem(name: "quinticEaseOut", easing: .quinticEaseOut),
        EasingDemoItem(name: "quinticEaseInOut", easing: .quinticEaseInOut),

        EasingDemoItem(name: "sineEaseIn", easing: .sineEaseIn),
        EasingDemoItem(name: "sineEaseOut", easing: .sineEaseOut),
        EasingDemoItem(name: "sineEaseInOut", easing: .sineEaseInOut),

        EasingDemoItem(name: "circularEaseIn", easing: .circularEaseIn),
        EasingDemoItem(name: "circularEaseOut", easing: .circularEaseOut),
        EasingDemoItem(name: "circularEaseInOut", easing: .circularEaseInOut),

        EasingDemoItem(name: "exponentialEaseIn", easing: .exponentialEaseIn),
        EasingDemoItem(name: "exponentialEaseOut", easing: .exponentialEaseOut),
        EasingDemoItem(name: "exponentialEaseInOut", easing: .exponentialEaseInOut),

        EasingDemoItem(name: "elasticEaseIn", easing: .elasticEaseIn),
        EasingDemoItem(name: "elasticEaseOut", easing: .elasticEaseOut),
        EasingDemoItem(name: "elasticEaseInOut", easing: .elasticEaseInOut),

        EasingDemoItem(name: "backEaseIn", easing: .backEaseIn),
        EasingDemoItem(name: "backEaseOut", easing: .backEaseOut),
        EasingDemoItem(name: "backEaseInOut", easing: .backEaseInOut),

        EasingDemoItem(name: "bounceEaseIn", easing: .bounceEaseIn),
        EasingDemoItem(name: "bounceEaseOut", easing: .bounceEaseOut),
        EasingDemoItem(name: "bounceEaseInOut", easing: .bounceEaseInOut),

        EasingDemoItem(name: "caEaseIn", easing: .caEaseIn),
        EasingDemoItem(name: "caEaseOut", easing: .caEaseOut),
        EasingDemoItem(name: "caEaseInEaseOut", easing: .caEaseInEaseOut),

        EasingDemoItem(name: "cubicBezier(0.11, 0.87, 0.21,-0.88)", easing: .cubicBezier(0.11, 0.87, 0.21, -0.88)),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Easing Demo"

        tableView.register(EasingDemoCell.self, forCellReuseIdentifier: "CellId")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 32
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as! EasingDemoCell
        cell.demoItem = items[indexPath.row]
        return cell
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        items.count
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EasingViewController(demoItem: items[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}

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
