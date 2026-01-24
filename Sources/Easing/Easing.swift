//
//  Copyright © 2016-present, Pavel Sharanda. All rights reserved.
//

import Foundation

public struct Easing {
    private let easingFunction: (Double) -> Double

    public init(_ easingFunction: @escaping (Double) -> Double) {
        self.easingFunction = easingFunction
    }

    /**
      Calculate d value for g, where g1 = 0, d1 = 0, g2 = 1, d2 = 1
     */
    public func calculate(_ g: Double, clamp: Bool = true) -> Double {
        return calculate(g1: 0, d1: 0, g2: 1, d2: 1, g: g, clamp: clamp)
    }

    /**
      Calculate d value for g, where g1 = 0, d1 = d1, g2 = 1, d2 = d2
     */
    public func calculate(d1: Double, d2: Double, g: Double, clamp: Bool = true) -> Double {
        return calculate(g1: 0, d1: d1, g2: 1, d2: d2, g: g, clamp: clamp)
    }

    /**
      Calculate d value for g, where g1 = g1, d1 = d1, g2 = g2, d2 = d2
     */
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
