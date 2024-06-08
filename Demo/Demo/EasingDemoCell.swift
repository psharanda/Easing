//
//  Copyright © 2024-present, Pavel Sharanda. All rights reserved.
//

import FixFlex
import UIKit

struct EasingDemoItem {
    let name: String
    let easing: Easing
}

class EasingDemoCell: UITableViewCell {
    private let demoView = EasingChartView()
    private let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        contentView.addSubview(demoView)
        contentView.addSubview(titleLabel)

        contentView.fx.hstack(Fill(), Flex(titleLabel), Fill())

        contentView.fx.hstack(Fill(), Fix(demoView, 60), Fill())
        contentView.fx.vstack(Fix(10), Flex(titleLabel), Fix(10), Flex(demoView), Fix(10))
    }

    var demoItem: EasingDemoItem? {
        didSet {
            titleLabel.text = demoItem?.name
            demoView.easing = demoItem?.easing
        }
    }
}
