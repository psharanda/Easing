//
//  Copyright © 2016-present, Pavel Sharanda. All rights reserved.
//

import Easing
import Foundation
import XCTest
import CoreGraphics
#if canImport(QuartzCore)
import QuartzCore
#endif
#if canImport(UIKit)
import UIKit
#endif

class EasingTests: XCTestCase {
    private func assertClose(_ lhs: Double, _ rhs: Double, accuracy: Double = 1e-9, _ message: String = "", file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(lhs, rhs, accuracy: accuracy, message, file: file, line: line)
    }

    private func assertFinite(_ value: Double, name: String, progress: Double, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(value.isFinite, "\(name) produced non-finite at g=\(progress)", file: file, line: line)
    }

    private func assertEasingEndpoints(_ easing: Easing, name: String, accuracy: Double = 1e-9) {
        assertClose(easing.calculate(0), 0, accuracy: accuracy, "\(name) start mismatch")
        assertClose(easing.calculate(1), 1, accuracy: accuracy, "\(name) end mismatch")
        for p in [0.0, 0.25, 0.5, 0.75, 1.0] {
            assertFinite(easing.calculate(p), name: name, progress: p)
        }
    }

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

    func testCalculateClampBehavior() {
        let easing = Easing.linear
        let clampedLow = easing.calculate(g1: 0, d1: 0, g2: 1, d2: 1, g: -1)
        let clampedHigh = easing.calculate(g1: 0, d1: 0, g2: 1, d2: 1, g: 2)
        assertClose(clampedLow, 0)
        assertClose(clampedHigh, 1)

        let unclampedLow = easing.calculate(g1: 0, d1: 0, g2: 1, d2: 1, g: -1, clamp: false)
        let unclampedHigh = easing.calculate(g1: 0, d1: 0, g2: 1, d2: 1, g: 2, clamp: false)
        assertClose(unclampedLow, -1)
        assertClose(unclampedHigh, 2)
    }

    func testCalculateWithReversedRange() {
        let val = Easing.linear.calculate(g1: 1, d1: 0, g2: 0, d2: 1, g: 0.25)
        assertClose(val, 0.75)
    }

    func testBuiltInEasingsHaveValidEndpoints() {
        let easings: [(String, Easing)] = [
            ("linear", .linear),
            ("smoothStep", .smoothStep),
            ("smootherStep", .smootherStep),
            ("quadraticEaseIn", .quadraticEaseIn),
            ("quadraticEaseOut", .quadraticEaseOut),
            ("quadraticEaseInOut", .quadraticEaseInOut),
            ("cubicEaseIn", .cubicEaseIn),
            ("cubicEaseOut", .cubicEaseOut),
            ("cubicEaseInOut", .cubicEaseInOut),
            ("quarticEaseIn", .quarticEaseIn),
            ("quarticEaseOut", .quarticEaseOut),
            ("quarticEaseInOut", .quarticEaseInOut),
            ("quinticEaseIn", .quinticEaseIn),
            ("quinticEaseOut", .quinticEaseOut),
            ("quinticEaseInOut", .quinticEaseInOut),
            ("sineEaseIn", .sineEaseIn),
            ("sineEaseOut", .sineEaseOut),
            ("sineEaseInOut", .sineEaseInOut),
            ("circularEaseIn", .circularEaseIn),
            ("circularEaseOut", .circularEaseOut),
            ("circularEaseInOut", .circularEaseInOut),
            ("exponentialEaseIn", .exponentialEaseIn),
            ("exponentialEaseOut", .exponentialEaseOut),
            ("exponentialEaseInOut", .exponentialEaseInOut),
            ("elasticEaseIn", .elasticEaseIn),
            ("elasticEaseOut", .elasticEaseOut),
            ("elasticEaseInOut", .elasticEaseInOut),
            ("backEaseIn", .backEaseIn),
            ("backEaseOut", .backEaseOut),
            ("backEaseInOut", .backEaseInOut),
            ("bounceEaseIn", .bounceEaseIn),
            ("bounceEaseOut", .bounceEaseOut),
            ("bounceEaseInOut", .bounceEaseInOut),
        ]

        for (name, easing) in easings {
            assertEasingEndpoints(easing, name: name)
        }
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

    func testCAEasingsHaveValidEndpoints() {
        let easings: [(String, Easing)] = [
            ("caEaseIn", .caEaseIn),
            ("caEaseOut", .caEaseOut),
            ("caEaseInEaseOut", .caEaseInEaseOut),
        ]
        for (name, easing) in easings {
            assertEasingEndpoints(easing, name: name, accuracy: 1e-6)
        }
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
        assertClose(val, 0.5, accuracy: 1e-12)
    }

    func testPiecewiseLinearEmptyStopsFallsBackToLinear() {
        let easing = Easing.piecewiseLinear([])
        assertClose(easing.calculate(0.25), 0.25)
    }

    func testPiecewiseLinearSingleStopIsConstant() {
        let easing = Easing.piecewiseLinear([PiecewiseLinearStop(0.42)])
        assertClose(easing.calculate(0), 0.42)
        assertClose(easing.calculate(0.5), 0.42)
        assertClose(easing.calculate(1), 0.42)
    }

    func testPiecewiseLinearInterpolatesMissingBetweenAnchors() {
        let easing = Easing.piecewiseLinear([
            PiecewiseLinearStop(0, at: 0),
            PiecewiseLinearStop(1),
            PiecewiseLinearStop(0, at: 1),
        ])
        assertClose(easing.calculate(0.5), 1, accuracy: 1e-12)
    }

    func testPiecewiseLinearDuplicateStopPositionsStep() {
        let easing = Easing.piecewiseLinear([
            PiecewiseLinearStop(0, at: 0),
            PiecewiseLinearStop(1, at: 0.5),
            PiecewiseLinearStop(0, at: 0.5),
            PiecewiseLinearStop(0, at: 1),
        ])
        assertClose(easing.calculate(0.5), 0, accuracy: 1e-12)
        XCTAssertLessThan(easing.calculate(0.5001), 0.1)
    }

    func testPiecewiseLinearUsesExplicitFirstStop() {
        let easing = Easing.piecewiseLinear([
            PiecewiseLinearStop(0),
            PiecewiseLinearStop(1, at: 0.3),
            PiecewiseLinearStop(0),
        ])
        assertClose(easing.calculate(0), 0, accuracy: 1e-12)
        assertClose(easing.calculate(0.3), 1, accuracy: 1e-12)
    }

    func testPiecewiseLinearUsesExplicitLastStop() {
        let easing = Easing.piecewiseLinear([
            PiecewiseLinearStop(0, at: 0),
            PiecewiseLinearStop(1),
            PiecewiseLinearStop(0, at: 0.7),
        ])
        assertClose(easing.calculate(0.7), 0, accuracy: 1e-12)
        XCTAssertLessThan(easing.calculate(0.9), 0.1)
    }

    func testPiecewiseLinearNegativeAndOverOneStopsExtrapolate() {
        let easing = Easing.piecewiseLinear([
            PiecewiseLinearStop(0, at: -0.2),
            PiecewiseLinearStop(1, at: 0.5),
            PiecewiseLinearStop(0, at: 1.2),
        ])
        let expected = 0.2 / 0.7
        assertClose(easing.calculate(0, clamp: false), expected, accuracy: 1e-12)
        assertClose(easing.calculate(1, clamp: false), expected, accuracy: 1e-12)
    }

    func testPiecewiseLinearClampsDecreasingInputs() {
        let easing = Easing.piecewiseLinear([
            PiecewiseLinearStop(0, at: 0.6),
            PiecewiseLinearStop(1, at: 0.2),
            PiecewiseLinearStop(2, at: 0.4),
        ])
        assertClose(easing.calculate(0.6), 2, accuracy: 1e-12)
        assertClose(easing.calculate(0.5), 1, accuracy: 1e-12)
    }

    func testPiecewiseLinearExtrapolatesOutsideRange() {
        let easing = Easing.piecewiseLinear([
            PiecewiseLinearStop(0, at: 0),
            PiecewiseLinearStop(0.5, at: 0.25),
            PiecewiseLinearStop(1, at: 1),
        ])
        assertClose(easing.calculate(-0.25, clamp: false), -0.5, accuracy: 1e-12)
        assertClose(easing.calculate(1.5, clamp: false), 4.0 / 3.0, accuracy: 1e-12)
    }

    func testPiecewiseLinearDuplicateEndStopsUseLastValue() {
        let easing = Easing.piecewiseLinear([
            PiecewiseLinearStop(0, at: 0),
            PiecewiseLinearStop(1, at: 0.5),
            PiecewiseLinearStop(0, at: 1),
            PiecewiseLinearStop(2, at: 1),
        ])
        assertClose(easing.calculate(1), 2, accuracy: 1e-12)
    }

    func testCubicBezierLinearIdentity() {
        let easing = Easing.cubicBezier(0.25, 0.25, 0.75, 0.75)
        assertClose(easing.calculate(0.0), 0.0, accuracy: 1e-12)
        assertClose(easing.calculate(0.3), 0.3, accuracy: 1e-6)
        assertClose(easing.calculate(0.7), 0.7, accuracy: 1e-6)
        assertClose(easing.calculate(1.0), 1.0, accuracy: 1e-12)
    }

    func testSpringWrappersMatch() {
        let ratio = 0.7
        let response = 0.4
        let velocity = 0.2
        let a = Easing.spring(dampingRatio: ratio, response: response, initialVelocity: velocity)
        let b = Easing.spring(response: response, dampingFraction: ratio, initialVelocity: velocity)
        assertClose(a.calculate(0.3), b.calculate(0.3), accuracy: 1e-12)
    }

    func testSpringPresetMatchesWrapper() {
        let preset = Easing.spring(.swiftUISpring, initialVelocity: 0)
        let direct = Easing.spring(response: 0.5, dampingFraction: 0.825, initialVelocity: 0)
        assertClose(preset.calculate(0.4), direct.calculate(0.4), accuracy: 1e-12)
    }

    func testSpringNormalizesToOneAtEnd() {
        let easing = Easing.spring(
            mass: 1,
            stiffness: 100,
            damping: 10,
            initialVelocity: 0,
            duration: 1,
            overshootClamping: false
        )

        XCTAssertEqual(easing.calculate(0), 0, accuracy: 1e-12)
        XCTAssertEqual(easing.calculate(1), 1, accuracy: 1e-9)
    }

    func testSpringOvershootClamping() {
        let easing = Easing.spring(
            mass: 1,
            stiffness: 100,
            damping: 1,
            initialVelocity: 0,
            duration: 1,
            overshootClamping: false
        )
        let clamped = Easing.spring(
            mass: 1,
            stiffness: 100,
            damping: 1,
            initialVelocity: 0,
            duration: 1,
            overshootClamping: true
        )
        var maxValue = -Double.greatestFiniteMagnitude
        var minValue = Double.greatestFiniteMagnitude
        var maxSample: Double = 0

        for i in 0 ... 100 {
            let p = Double(i) / 100.0
            let value = easing.calculate(p)
            if value > maxValue {
                maxValue = value
                maxSample = p
            }
            minValue = min(minValue, value)
        }

        if maxValue > 1 || minValue < 0 {
            let unclamped = easing.calculate(maxSample)
            let clampedValue = clamped.calculate(maxSample)
            XCTAssertLessThanOrEqual(clampedValue, 1)
            XCTAssertGreaterThanOrEqual(clampedValue, 0)
            XCTAssertNotEqual(unclamped, clampedValue)
        } else {
            assertClose(clamped.calculate(0.6), easing.calculate(0.6), accuracy: 1e-12)
        }
    }

    func testSpringInvalidParametersFallBackToLinear() {
        let easing = Easing.spring(
            mass: 0,
            stiffness: 100,
            damping: 10,
            initialVelocity: 0,
            duration: 1,
            overshootClamping: false
        )
        assertClose(easing.calculate(0.3), 0.3)
    }

    func testInterpolatableCGFloat() {
        let start: CGFloat = 0
        let end: CGFloat = 10
        let result = start.interpolate(to: end, progress: 0.25, easing: .linear)
        XCTAssertEqual(result, 2.5, accuracy: 1e-12)
    }

    func testInterpolatableCGPoint() {
        let start = CGPoint(x: 0, y: 0)
        let end = CGPoint(x: 10, y: 20)
        let result = start.interpolate(to: end, progress: 0.5, easing: .linear)
        XCTAssertEqual(result.x, 5, accuracy: 1e-12)
        XCTAssertEqual(result.y, 10, accuracy: 1e-12)
    }

    func testInterpolatableCGSize() {
        let start = CGSize(width: 10, height: 20)
        let end = CGSize(width: 30, height: 40)
        let result = start.interpolate(to: end, progress: 0.5, easing: .linear)
        XCTAssertEqual(result.width, 20, accuracy: 1e-12)
        XCTAssertEqual(result.height, 30, accuracy: 1e-12)
    }

    func testInterpolatableCGRect() {
        let start = CGRect(x: 0, y: 0, width: 10, height: 20)
        let end = CGRect(x: 10, y: 20, width: 30, height: 40)
        let result = start.interpolate(to: end, progress: 0.5, easing: .linear)
        XCTAssertEqual(result.origin.x, 5, accuracy: 1e-12)
        XCTAssertEqual(result.origin.y, 10, accuracy: 1e-12)
        XCTAssertEqual(result.size.width, 20, accuracy: 1e-12)
        XCTAssertEqual(result.size.height, 30, accuracy: 1e-12)
    }

    func testInterpolatableCGAffineTransformTranslation() {
        let start = CGAffineTransform.identity
        let end = CGAffineTransform(translationX: 10, y: 20)
        let result = start.interpolate(to: end, progress: 0.5, easing: .linear)
        XCTAssertEqual(result.tx, 5, accuracy: 1e-12)
        XCTAssertEqual(result.ty, 10, accuracy: 1e-12)
        XCTAssertEqual(result.a, 1, accuracy: 1e-12)
        XCTAssertEqual(result.d, 1, accuracy: 1e-12)
    }

    #if canImport(UIKit)
    func testInterpolatableUIColorRGB() {
        let start = UIColor.red
        let end = UIColor.blue
        let result = start.interpolate(to: end, progress: 0.5, easing: .linear)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        XCTAssertTrue(result.getRed(&r, green: &g, blue: &b, alpha: &a))
        XCTAssertEqual(r, 0.5, accuracy: 1e-3)
        XCTAssertEqual(g, 0, accuracy: 1e-3)
        XCTAssertEqual(b, 0.5, accuracy: 1e-3)
        XCTAssertEqual(a, 1, accuracy: 1e-3)
    }

    func testInterpolatableUIColorHSB() {
        let start = UIColor.red
        let end = UIColor.green
        let result = start.interpolateHSB(to: end, progress: 0.5, easing: .linear)
        var h: CGFloat = 0
        var s: CGFloat = 0
        var v: CGFloat = 0
        var a: CGFloat = 0
        XCTAssertTrue(result.getHue(&h, saturation: &s, brightness: &v, alpha: &a))
        XCTAssertEqual(a, 1, accuracy: 1e-3)
    }

    func testInterpolatableUIColorHSBFallbackUsesGray() throws {
        let colorSpace = CGColorSpaceCreateDeviceGray()
        guard
            let cg1 = CGColor(colorSpace: colorSpace, components: [0.2, 1]),
            let cg2 = CGColor(colorSpace: colorSpace, components: [0.8, 1])
        else {
            XCTFail("Failed to create grayscale colors")
            return
        }

        let start = UIColor(cgColor: cg1)
        let end = UIColor(cgColor: cg2)

        var h: CGFloat = 0
        var s: CGFloat = 0
        var v: CGFloat = 0
        var a: CGFloat = 0
        if start.getHue(&h, saturation: &s, brightness: &v, alpha: &a) {
            throw XCTSkip("getHue succeeded; fallback not exercised on this platform")
        }

        let result = start.interpolateHSB(to: end, progress: 0.5, easing: .linear)
        var w: CGFloat = 0
        var alpha: CGFloat = 0
        XCTAssertTrue(result.getWhite(&w, alpha: &alpha))
        XCTAssertEqual(w, 0.5, accuracy: 1e-3)
        XCTAssertEqual(alpha, 1, accuracy: 1e-3)
    }

    func testInterpolatableUIBezierPathLine() {
        let p1 = UIBezierPath()
        p1.move(to: .zero)
        p1.addLine(to: CGPoint(x: 10, y: 0))
        p1.lineWidth = 2

        let p2 = UIBezierPath()
        p2.move(to: .zero)
        p2.addLine(to: CGPoint(x: 20, y: 0))
        p2.lineWidth = 4

        let result = p1.interpolate(to: p2, progress: 0.5, easing: .linear)
        XCTAssertEqual(result.lineWidth, 3, accuracy: 1e-12)

        let elements = result.cgPath.elements()
        XCTAssertEqual(elements.count, 2)
        switch elements[0] {
        case let .move(point):
            XCTAssertEqual(point.x, 0, accuracy: 1e-12)
            XCTAssertEqual(point.y, 0, accuracy: 1e-12)
        default:
            XCTFail("Expected move element")
        }
        switch elements[1] {
        case let .line(point):
            XCTAssertEqual(point.x, 15, accuracy: 1e-12)
            XCTAssertEqual(point.y, 0, accuracy: 1e-12)
        default:
            XCTFail("Expected line element")
        }
    }
    #endif
}

#if canImport(UIKit)
private enum PathElementType: Equatable {
    case move(CGPoint)
    case line(CGPoint)
    case quad(CGPoint, CGPoint)
    case curve(CGPoint, CGPoint, CGPoint)
    case close
}

private extension CGPath {
    func elements() -> [PathElementType] {
        var result: [PathElementType] = []
        applyWithBlock { elementPointer in
            let element = elementPointer.pointee
            switch element.type {
            case .moveToPoint:
                let points = Array(UnsafeBufferPointer(start: element.points, count: 1))
                result.append(.move(points[0]))
            case .addLineToPoint:
                let points = Array(UnsafeBufferPointer(start: element.points, count: 1))
                result.append(.line(points[0]))
            case .addQuadCurveToPoint:
                let points = Array(UnsafeBufferPointer(start: element.points, count: 2))
                result.append(.quad(points[0], points[1]))
            case .addCurveToPoint:
                let points = Array(UnsafeBufferPointer(start: element.points, count: 3))
                result.append(.curve(points[0], points[1], points[2]))
            case .closeSubpath:
                result.append(.close)
            @unknown default:
                break
            }
        }
        return result
    }
}
#endif
