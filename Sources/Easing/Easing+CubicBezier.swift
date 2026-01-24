//
//  Copyright © 2016-present, Pavel Sharanda. All rights reserved.
//

import Foundation

public extension Easing {
    /// Creates an easing from cubic bezier control points.
    /// - Parameters:
    ///   - x1: X of control point 1.
    ///   - y1: Y of control point 1.
    ///   - x2: X of control point 2.
    ///   - y2: Y of control point 2.
    static func cubicBezier(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) -> Easing {
        let calculator = CubicBezierCalculator(x1: x1, y1: y1, x2: x2, y2: y2)
        return Easing { p in
            calculator.calculate(p)
        }
    }
}

//  Based on nsSMILKeySpline from Mozilla https://github.com/mozilla-services/services-central-legacy/blob/master/content/smil/nsSMILKeySpline.cpp
private struct CubicBezierCalculator {
    let x1: Double
    let y1: Double
    let x2: Double
    let y2: Double

    private let sampleValues: [Double]

    init(x1: Double, y1: Double, x2: Double, y2: Double, samplesCount: Int = 10) {
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2

        if x1 == y1, x2 == y2 {
            sampleValues = []
        } else {
            sampleValues = CubicBezierCalculator.calculateSampleValues(x1, x2, samplesCount)
        }
    }

    func calculate(_ x: Double) -> Double {
        if x1 == y1 && x2 == y2 {
            return x
        }
        return CubicBezierCalculator.calculateBezier(calculateT(x), y1, y2)
    }

    private func calculateT(_ x: Double) -> Double {
        let stepSize = 1.0 / Double(sampleValues.count - 1)

        // Find interval where t lies
        var intervalStart = 0.0

        var currentSample = 0

        for (idx, value) in sampleValues.enumerated() {
            if idx == sampleValues.count - 1 {
                break
            }

            if value >= x {
                break
            }

            currentSample = idx
            if idx > 0 {
                intervalStart += stepSize
            }
        }

        // Interpolate to provide an initial guess for t
        let startGuess = sampleValues[currentSample]
        let endGuess = sampleValues[currentSample + 1]
        let dist = (x - startGuess) / (endGuess - startGuess)

        let guessForT = intervalStart + dist * stepSize

        // Check the slope to see what strategy to use. If the slope is too small
        // Newton-Raphson iteration won't converge on a root so we use bisection
        // instead.

        let initialSlope = CubicBezierCalculator.getSlope(guessForT, x1, x2)
        if initialSlope >= 0.02 {
            return CubicBezierCalculator.newtonRaphsonIterate(x, guessForT, x1, x2)
        } else if initialSlope == 0 {
            return guessForT
        } else {
            return CubicBezierCalculator.binarySubdivide(
                x, intervalStart, intervalStart + stepSize, x1, x2
            )
        }
    }

    private static func calculateSampleValues(_ x1: Double, _ x2: Double, _ samplesCount: Int)
        -> [Double]
    {
        let stepSize = 1.0 / Double(samplesCount)

        var sampleValues: [Double] = []
        for i in 0 ... samplesCount {
            sampleValues.append(calculateBezier(Double(i) * stepSize, x1, x2))
        }

        return sampleValues
    }

    private static func calculateBezier(_ t: Double, _ a1: Double, _ a2: Double) -> Double {
        // use Horner's scheme to evaluate the Bezier polynomial
        return ((calculateA(a1, a2) * t + calculateB(a1, a2)) * t + calculateC(a1)) * t
    }

    private static func calculateA(_ a1: Double, _ a2: Double) -> Double {
        return 1.0 - 3.0 * a2 + 3.0 * a1
    }

    private static func calculateB(_ a1: Double, _ a2: Double) -> Double {
        return 3.0 * a2 - 6.0 * a1
    }

    private static func calculateC(_ a1: Double) -> Double {
        return 3.0 * a1
    }

    private static func getSlope(_ aT: Double, _ a1: Double, _ a2: Double) -> Double {
        return 3.0 * calculateA(a1, a2) * aT * aT + 2.0 * calculateB(a1, a2) * aT + calculateC(a1)
    }

    private static func newtonRaphsonIterate(
        _ x: Double, _ guessT: Double, _ x1: Double, _ x2: Double
    ) -> Double {
        var guessT = guessT
        // Refine guess with Newton-Raphson iteration
        for _ in 0 ..< 4 {
            // We're trying to find where f(t) = x,
            // so we're actually looking for a root for: CalcBezier(t) - x
            let currentX = calculateBezier(guessT, x1, x2) - x
            let currentSlope = getSlope(guessT, x1, x2)
            if currentSlope == 0.0 {
                return guessT
            }
            guessT -= currentX / currentSlope
        }
        return guessT
    }

    private static func binarySubdivide(
        _ x: Double, _ a: Double, _ b: Double, _ x1: Double, _ x2: Double
    ) -> Double {
        var a = a
        var b = b
        var currentX: Double = 0
        var currentT: Double = 0
        var i = 0
        repeat {
            currentT = a + (b - a) / 2.0
            currentX = calculateBezier(currentT, x1, x2) - x
            if currentX > 0.0 {
                b = currentT
            } else {
                a = currentT
            }
            i += 1
        } while (fabs(currentX) > 0.0000001)
            && (i < 11)

        return currentT
    }
}
