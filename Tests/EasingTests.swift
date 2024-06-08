//
//  Copyright © 2016-present, Pavel Sharanda. All rights reserved.
//

import Easing
import Foundation
import XCTest

class EasingTests: XCTestCase {
    func test1() {
        let val = Easing.linear.calculate(0.5)
        XCTAssertEqual(val, 0.5)
    }

    func test2() {
        let val = Easing.linear.calculate(d1: 0, d2: 1, g: 0.5)
        XCTAssertEqual(val, 0.5)
    }

    func test3() {
        let val = Easing.linear.calculate(g1: 0, d1: 0, g2: 1, d2: 1, g: 0.5)
        XCTAssertEqual(val, 0.5)
    }
}
