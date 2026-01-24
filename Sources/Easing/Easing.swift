//
//  Copyright © 2016-present, Pavel Sharanda. All rights reserved.
//

import Foundation

/// Represents a normalized easing function that maps progress (0...1) to output (0...1).
public struct Easing {
    private let easingFunction: (Double) -> Double

    /// Creates a custom easing from a normalized progress function.
    /// - Parameter easingFunction: Function that maps progress in 0...1 to an output value.
    public init(_ easingFunction: @escaping (Double) -> Double) {
        self.easingFunction = easingFunction
    }

    /// Calculates the eased value for `g` in the 0...1 range.
    /// - Parameters:
    ///   - g: Input progress.
    ///   - clamp: When true, clamps `g` into 0...1 before applying the easing.
    public func calculate(_ g: Double, clamp: Bool = true) -> Double {
        return calculate(g1: 0, d1: 0, g2: 1, d2: 1, g: g, clamp: clamp)
    }

    /// Calculates the eased value between two output values for `g` in the 0...1 range.
    /// - Parameters:
    ///   - d1: Output value when `g` is 0.
    ///   - d2: Output value when `g` is 1.
    ///   - g: Input progress.
    ///   - clamp: When true, clamps `g` into 0...1 before applying the easing.
    public func calculate(d1: Double, d2: Double, g: Double, clamp: Bool = true) -> Double {
        return calculate(g1: 0, d1: d1, g2: 1, d2: d2, g: g, clamp: clamp)
    }

    /// Calculates the eased value for an arbitrary input/output range.
    /// - Parameters:
    ///   - g1: Input range start.
    ///   - d1: Output value at `g1`.
    ///   - g2: Input range end.
    ///   - d2: Output value at `g2`.
    ///   - g: Input value.
    ///   - clamp: When true, clamps `g` into `[g1, g2]` before applying the easing.
    public func calculate(g1: Double, d1: Double, g2: Double, d2: Double, g: Double, clamp: Bool = true) -> Double {
        var g = g

        if g1 == g2 {
            return d1
        }

        if clamp {
            g = max(min(g1, g2), g)
            g = min(max(g1, g2), g)
        }

        let t = (g - g1) / (g2 - g1)
        let resT = easingFunction(t)
        return d1 + resT * (d2 - d1)
    }
}
