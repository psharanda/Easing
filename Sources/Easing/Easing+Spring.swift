//
//  Copyright © 2016-present, Pavel Sharanda. All rights reserved.
//

import Foundation

public extension Easing {
    enum SpringPreset {
        case swiftUISpring
        case swiftUIInteractiveSpring
    }

    static func spring(
        _ preset: SpringPreset,
        initialVelocity: Double,
        overshootClamping: Bool = false
    ) -> Easing {
        switch preset {
        case .swiftUISpring:
            return spring(
                response: 0.5,
                dampingFraction: 0.825,
                initialVelocity: initialVelocity,
                overshootClamping: overshootClamping
            )
        case .swiftUIInteractiveSpring:
            return spring(
                response: 0.15,
                dampingFraction: 0.86,
                initialVelocity: initialVelocity,
                overshootClamping: overshootClamping
            )
        }
    }

    static func spring(
        dampingRatio: Double,
        response: Double,
        initialVelocity: Double,
        overshootClamping: Bool = false
    ) -> Easing {
        return spring(
            response: response,
            dampingFraction: dampingRatio,
            initialVelocity: initialVelocity,
            overshootClamping: overshootClamping
        )
    }

    static func spring(
        response: Double,
        dampingFraction: Double,
        initialVelocity: Double,
        overshootClamping: Bool = false
    ) -> Easing {
        let mass = 1.0
        let angularFrequency = 2 * Double.pi / response
        let stiffness = angularFrequency * angularFrequency * mass
        let damping = 2 * dampingFraction * angularFrequency * mass
        return spring(
            mass: mass,
            stiffness: stiffness,
            damping: damping,
            initialVelocity: initialVelocity,
            duration: response,
            overshootClamping: overshootClamping
        )
    }

    static func spring(
        mass: Double,
        stiffness: Double,
        damping: Double,
        initialVelocity: Double,
        duration: Double,
        overshootClamping: Bool = false
    ) -> Easing {
        return Easing { p in
            SpringSolver.normalizedValue(
                progress: p,
                mass: mass,
                stiffness: stiffness,
                damping: damping,
                initialVelocity: initialVelocity,
                duration: duration,
                overshootClamping: overshootClamping
            )
        }
    }
}

private enum SpringSolver {
    static func normalizedValue(
        progress: Double,
        mass: Double,
        stiffness: Double,
        damping: Double,
        initialVelocity: Double,
        duration: Double,
        overshootClamping: Bool
    ) -> Double {
        if duration <= 0 || mass <= 0 || stiffness <= 0 {
            return progress
        }

        let t = progress * duration
        let value = SpringSolver.value(
            t,
            mass: mass,
            stiffness: stiffness,
            damping: damping,
            initialVelocity: initialVelocity
        )
        let endValue = SpringSolver.value(
            duration,
            mass: mass,
            stiffness: stiffness,
            damping: damping,
            initialVelocity: initialVelocity
        )

        var normalized = endValue == 0 ? value : (value / endValue)
        if overshootClamping {
            normalized = min(1, max(0, normalized))
        }
        return normalized
    }

    static func value(
        _ t: Double,
        mass: Double,
        stiffness: Double,
        damping: Double,
        initialVelocity: Double
    ) -> Double {
        let angularFrequency = sqrt(stiffness / mass)
        let dampingRatio = damping / (2 * sqrt(stiffness * mass))
        let epsilon = 1e-6

        if dampingRatio < 1 - epsilon {
            let dampingFrequency = angularFrequency * sqrt(1 - dampingRatio * dampingRatio)
            let expTerm = exp(-dampingRatio * angularFrequency * t)
            let b = (initialVelocity - dampingRatio * angularFrequency) / dampingFrequency
            let x = expTerm * (-cos(dampingFrequency * t) + b * sin(dampingFrequency * t))
            return 1 + x
        } else if abs(dampingRatio - 1) <= epsilon {
            let expTerm = exp(-angularFrequency * t)
            let b = initialVelocity - angularFrequency
            let x = (-1 + b * t) * expTerm
            return 1 + x
        } else {
            let z = sqrt(dampingRatio * dampingRatio - 1)
            let r1 = -angularFrequency * (dampingRatio - z)
            let r2 = -angularFrequency * (dampingRatio + z)
            let c1 = (initialVelocity + r2) / (r1 - r2)
            let c2 = -1 - c1
            let x = c1 * exp(r1 * t) + c2 * exp(r2 * t)
            return 1 + x
        }
    }
}
