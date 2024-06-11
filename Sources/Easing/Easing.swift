//
//  Copyright © 2016-present, Pavel Sharanda. All rights reserved.
//

import Foundation

public enum Easing {
    case linear

    case smoothStep
    case smootherStep

    case quadraticEaseIn
    case quadraticEaseOut
    case quadraticEaseInOut

    case cubicEaseIn
    case cubicEaseOut
    case cubicEaseInOut

    case quarticEaseIn
    case quarticEaseOut
    case quarticEaseInOut

    case quinticEaseIn
    case quinticEaseOut
    case quinticEaseInOut

    case sineEaseIn
    case sineEaseOut
    case sineEaseInOut

    case circularEaseIn
    case circularEaseOut
    case circularEaseInOut

    case exponentialEaseIn
    case exponentialEaseOut
    case exponentialEaseInOut

    case elasticEaseIn
    case elasticEaseOut
    case elasticEaseInOut

    case backEaseIn
    case backEaseOut
    case backEaseInOut

    case bounceEaseIn
    case bounceEaseOut
    case bounceEaseInOut

    case cubicBezier(Double, Double, Double, Double)

    case custom((Double) -> Double)

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

        if clamp {
            g = max(min(g1, g2), g)
            g = min(max(g1, g2), g)
        }

        let t = (g - g1) / (g2 - g1)
        let resT = easingFunction(t)
        return d1 + resT * (d2 - d1)
    }

    private var easingFunction: (Double) -> Double {
        switch self {
        case .linear:
            return Easing._linear
        case .smoothStep:
            return Easing._smoothStep
        case .smootherStep:
            return Easing._smootherStep
        case .quadraticEaseIn:
            return Easing._quarticEaseIn
        case .quadraticEaseOut:
            return Easing._quadraticEaseOut
        case .quadraticEaseInOut:
            return Easing._quadraticEaseInOut
        case .cubicEaseIn:
            return Easing._cubicEaseIn
        case .cubicEaseOut:
            return Easing._cubicEaseOut
        case .cubicEaseInOut:
            return Easing._cubicEaseInOut
        case .quarticEaseIn:
            return Easing._quarticEaseIn
        case .quarticEaseOut:
            return Easing._quarticEaseOut
        case .quarticEaseInOut:
            return Easing._quarticEaseInOut
        case .quinticEaseIn:
            return Easing._quinticEaseIn
        case .quinticEaseOut:
            return Easing._quinticEaseOut
        case .quinticEaseInOut:
            return Easing._quinticEaseInOut
        case .sineEaseIn:
            return Easing._sineEaseIn
        case .sineEaseOut:
            return Easing._sineEaseOut
        case .sineEaseInOut:
            return Easing._sineEaseInOut
        case .circularEaseIn:
            return Easing._circularEaseIn
        case .circularEaseOut:
            return Easing._circularEaseOut
        case .circularEaseInOut:
            return Easing._circularEaseInOut
        case .exponentialEaseIn:
            return Easing._exponentialEaseIn
        case .exponentialEaseOut:
            return Easing._exponentialEaseOut
        case .exponentialEaseInOut:
            return Easing._exponentialEaseInOut
        case .elasticEaseIn:
            return Easing._elasticEaseIn
        case .elasticEaseOut:
            return Easing._elasticEaseOut
        case .elasticEaseInOut:
            return Easing._elasticEaseInOut
        case .backEaseIn:
            return Easing._backEaseIn
        case .backEaseOut:
            return Easing._backEaseOut
        case .backEaseInOut:
            return Easing._backEaseInOut
        case .bounceEaseIn:
            return Easing._bounceEaseIn
        case .bounceEaseOut:
            return Easing._bounceEaseOut
        case .bounceEaseInOut:
            return Easing._bounceEaseInOut
        case let .cubicBezier(x1, y1, x2, y2):
            return { (p: Double) -> Double in
                Easing._cubicBezier(p, x1: x1, y1: y1, x2: x2, y2: y2)
            }
        case let .custom(f):
            return f
        }
    }

    //  Based on https://github.com/warrenm/AHEasing and https://github.com/ai/easings.net

    // Modeled after the line y = x
    private static func _linear(_ p: Double) -> Double {
        return p
    }

    // fast but ugly easeInOut
    private static func _smoothStep(_ p: Double) -> Double {
        return p * p * (3 - 2 * p)
    }

    // fast but ugly easeInOut
    private static func _smootherStep(_ p: Double) -> Double {
        return p * p * p * (p * (p * 6 - 15) + 10)
    }

    // Modeled after the parabola y = x^2
    private static func _quadraticEaseIn(_ p: Double) -> Double {
        return p * p
    }

    // Modeled after the parabola y = -x^2 + 2x
    private static func _quadraticEaseOut(_ p: Double) -> Double {
        return -(p * (p - 2))
    }

    // Modeled after the piecewise quadratic
    // y = (1/2)((2x)^2)             ; [0, 0.5)
    // y = -(1/2)((2x-1)*(2x-3) - 1) ; [0.5, 1]
    private static func _quadraticEaseInOut(_ p: Double) -> Double {
        if p < 0.5 {
            return 2 * p * p
        } else {
            return (-2 * p * p) + (4 * p) - 1
        }
    }

    // Modeled after the cubic y = x^3
    private static func _cubicEaseIn(_ p: Double) -> Double {
        return p * p * p
    }

    // Modeled after the cubic y = (x - 1)^3 + 1
    private static func _cubicEaseOut(_ p: Double) -> Double {
        let f = (p - 1)
        return f * f * f + 1
    }

    // Modeled after the piecewise cubic
    // y = (1/2)((2x)^3)       ; [0, 0.5)
    // y = (1/2)((2x-2)^3 + 2) ; [0.5, 1]
    private static func _cubicEaseInOut(_ p: Double) -> Double {
        if p < 0.5 {
            return 4 * p * p * p
        } else {
            let f = ((2 * p) - 2)
            return 0.5 * f * f * f + 1
        }
    }

    // Modeled after the quartic x^4
    private static func _quarticEaseIn(_ p: Double) -> Double {
        return p * p * p * p
    }

    // Modeled after the quartic y = 1 - (x - 1)^4
    private static func _quarticEaseOut(_ p: Double) -> Double {
        let f = (p - 1)
        return f * f * f * (1 - p) + 1
    }

    // Modeled after the piecewise quartic
    // y = (1/2)((2x)^4)        ; [0, 0.5)
    // y = -(1/2)((2x-2)^4 - 2) ; [0.5, 1]
    private static func _quarticEaseInOut(_ p: Double) -> Double {
        if p < 0.5 {
            return 8 * p * p * p * p
        } else {
            let f = (p - 1)
            return -8 * f * f * f * f + 1
        }
    }

    // Modeled after the quintic y = x^5
    private static func _quinticEaseIn(_ p: Double) -> Double {
        return p * p * p * p * p
    }

    // Modeled after the quintic y = (x - 1)^5 + 1
    private static func _quinticEaseOut(_ p: Double) -> Double {
        let f = (p - 1)
        return f * f * f * f * f + 1
    }

    // Modeled after the piecewise quintic
    // y = (1/2)((2x)^5)       ; [0, 0.5)
    // y = (1/2)((2x-2)^5 + 2) ; [0.5, 1]
    private static func _quinticEaseInOut(_ p: Double) -> Double {
        if p < 0.5 {
            return 16 * p * p * p * p * p
        } else {
            let f = ((2 * p) - 2)
            return 0.5 * f * f * f * f * f + 1
        }
    }

    // Modeled after quarter-cycle of sine wave
    private static func _sineEaseIn(_ p: Double) -> Double {
        return sin((p - 1) * .pi / 2) + 1
    }

    // Modeled after quarter-cycle of sine wave (different phase)
    private static func _sineEaseOut(_ p: Double) -> Double {
        return sin(p * .pi / 2)
    }

    // Modeled after half sine wave
    private static func _sineEaseInOut(_ p: Double) -> Double {
        return 0.5 * (1 - cos(p * .pi))
    }

    // Modeled after shifted quadrant IV of unit circle
    private static func _circularEaseIn(_ p: Double) -> Double {
        return 1 - sqrt(1 - (p * p))
    }

    // Modeled after shifted quadrant II of unit circle
    private static func _circularEaseOut(_ p: Double) -> Double {
        return sqrt((2 - p) * p)
    }

    // Modeled after the piecewise circular function
    // y = (1/2)(1 - sqrt(1 - 4x^2))           ; [0, 0.5)
    // y = (1/2)(sqrt(-(2x - 3)*(2x - 1)) + 1) ; [0.5, 1]
    private static func _circularEaseInOut(_ p: Double) -> Double {
        if p < 0.5 {
            return 0.5 * (1 - sqrt(1 - 4 * (p * p)))
        } else {
            return 0.5 * (sqrt(-((2 * p) - 3) * ((2 * p) - 1)) + 1)
        }
    }

    // Modeled after the exponential function y = 2^(10(x - 1))
    private static func _exponentialEaseIn(_ p: Double) -> Double {
        return (p == 0.0) ? p : pow(2, 10 * (p - 1))
    }

    // Modeled after the exponential function y = -2^(-10x) + 1
    private static func _exponentialEaseOut(_ p: Double) -> Double {
        return (p == 1.0) ? p : 1 - pow(2, -10 * p)
    }

    // Modeled after the piecewise exponential
    // y = (1/2)2^(10(2x - 1))         ; [0,0.5)
    // y = -(1/2)*2^(-10(2x - 1))) + 1 ; [0.5,1]
    private static func _exponentialEaseInOut(_ p: Double) -> Double {
        if p == 0.0 || p == 1.0 {
            return p
        }

        if p < 0.5 {
            return 0.5 * pow(2, (20 * p) - 10)
        } else {
            return -0.5 * pow(2, (-20 * p) + 10) + 1
        }
    }

    // Modeled after the damped sine wave y = sin(13pi/2*x)*pow(2, 10 * (x - 1))
    private static func _elasticEaseIn(_ p: Double) -> Double {
        return sin(13 * .pi / 2 * p) * pow(2, 10 * (p - 1))
    }

    // Modeled after the damped sine wave y = sin(-13pi/2*(x + 1))*pow(2, -10x) + 1
    private static func _elasticEaseOut(_ p: Double) -> Double {
        return sin(-13 * .pi / 2 * (p + 1)) * pow(2, -10 * p) + 1
    }

    // Modeled after the piecewise exponentially-damped sine wave:
    // y = (1/2)*sin(13pi/2*(2*x))*pow(2, 10 * ((2*x) - 1))      ; [0,0.5)
    // y = (1/2)*(sin(-13pi/2*((2x-1)+1))*pow(2,-10(2*x-1)) + 2) ; [0.5, 1]
    private static func _elasticEaseInOut(_ p: Double) -> Double {
        if p < 0.5 {
            return 0.5 * sin(13 * .pi / 2 * (2 * p)) * pow(2, 10 * ((2 * p) - 1))
        } else {
            return 0.5 * (sin(-13 * .pi / 2 * ((2 * p - 1) + 1)) * pow(2, -10 * (2 * p - 1)) + 2)
        }
    }

    // Modeled after the overshooting cubic y = x^3-x*sin(x*pi)
    private static func _backEaseIn(_ p: Double) -> Double {
        return p * p * p - p * sin(p * .pi)
    }

    // Modeled after overshooting cubic y = 1-((1-x)^3-(1-x)*sin((1-x)*pi))
    private static func _backEaseOut(_ p: Double) -> Double {
        let f = (1 - p)
        return 1 - (f * f * f - f * sin(f * .pi))
    }

    // Modeled after the piecewise overshooting cubic function:
    // y = (1/2)*((2x)^3-(2x)*sin(2*x*pi))           ; [0, 0.5)
    // y = (1/2)*(1-((1-x)^3-(1-x)*sin((1-x)*pi))+1) ; [0.5, 1]
    private static func _backEaseInOut(_ p: Double) -> Double {
        if p < 0.5 {
            let f = 2 * p
            let x = (f * f * f - f * sin(f * .pi))
            return 0.5 * x
        } else {
            let f = (1 - (2 * p - 1))
            let x = (f * f * f - f * sin(f * .pi))
            return 0.5 * (1 - x) + 0.5
        }
    }

    private static func _bounceEaseIn(_ p: Double) -> Double {
        return 1 - _bounceEaseOut(1 - p)
    }

    private static func _bounceEaseOut(_ p: Double) -> Double {
        if p < 4 / 11.0 {
            return (121 * p * p) / 16.0
        } else if p < 8 / 11.0 {
            return (363 / 40.0 * p * p) - (99 / 10.0 * p) + 17 / 5.0
        } else if p < 9 / 10.0 {
            return (4356 / 361.0 * p * p) - (35442 / 1805.0 * p) + 16061 / 1805.0
        } else {
            return (54 / 5.0 * p * p) - (513 / 25.0 * p) + 268 / 25.0
        }
    }

    private static func _bounceEaseInOut(_ p: Double) -> Double {
        if p < 0.5 {
            return 0.5 * _bounceEaseIn(p * 2)
        } else {
            return 0.5 * _bounceEaseOut(p * 2 - 1) + 0.5
        }
    }

    private static func _cubicBezier(_ p: Double, x1: Double, y1: Double, x2: Double, y2: Double)
        -> Double
    {
        return CubicBezierCalculator(x1: x1, y1: y1, x2: x2, y2: y2).calculate(p)
    }
}
