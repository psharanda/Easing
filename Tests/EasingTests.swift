//
//  Copyright © 2016-present, Pavel Sharanda. All rights reserved.
//

import Easing
import Foundation
import XCTest
#if canImport(QuartzCore)
import QuartzCore
#endif

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

    func testQuadraticEaseIn() {
        let val = Easing.quadraticEaseIn.calculate(0.5)
        XCTAssertEqual(val, 0.25, accuracy: 1e-12)
    }

    func testCalculateZeroRangeReturnsD1() {
        let val = Easing.linear.calculate(g1: 1, d1: 10, g2: 1, d2: 20, g: 0.5)
        XCTAssertEqual(val, 10)
    }

    #if canImport(QuartzCore)
    func testCAEaseOutMatchesCAMediaTimingFunction() {
        let timing = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        var controlPoint1: [Float] = [0, 0]
        var controlPoint2: [Float] = [0, 0]
        timing.getControlPoint(at: 1, values: &controlPoint1)
        timing.getControlPoint(at: 2, values: &controlPoint2)

        let expected = Easing.cubicBezier(
            Double(controlPoint1[0]),
            Double(controlPoint1[1]),
            Double(controlPoint2[0]),
            Double(controlPoint2[1])
        )

        let val = Easing.caEaseOut.calculate(0.25)
        XCTAssertEqual(val, expected.calculate(0.25), accuracy: 1e-9)
    }
    #endif

    func testPiecewiseLinearExplicitStops() {
        let easing = Easing.piecewiseLinear([
            PiecewiseLinearStop(0, at: 0),
            PiecewiseLinearStop(1, at: 0.5),
            PiecewiseLinearStop(0, at: 1),
        ])

        let val = easing.calculate(0.25)
        XCTAssertEqual(val, 0.5, accuracy: 1e-12)
    }

    func testPiecewiseLinearImplicitStops() {
        let easing = Easing.piecewiseLinear([
            PiecewiseLinearStop(0),
            PiecewiseLinearStop(1),
            PiecewiseLinearStop(0),
        ])

        let val = easing.calculate(0.75)
        XCTAssertEqual(val, 0.5, accuracy: 1e-12)
    }
}
