//
//  Copyright © 2016-present, Pavel Sharanda. All rights reserved.
//

import Foundation

public extension Easing {
    /// Preset spring configurations that mirror SwiftUI defaults.
    enum SpringPreset {
        /// SwiftUI `.spring` preset (response: 0.5, dampingFraction: 0.825).
        case swiftUISpring
        /// SwiftUI `.interactiveSpring` preset (response: 0.15, dampingFraction: 0.86).
        case swiftUIInteractiveSpring
    }

    /// Creates a spring easing using a preset configuration.
    /// - Parameters:
    ///   - preset: Preset spring configuration.
    ///   - initialVelocity: Initial velocity in units per second.
    ///   - overshootClamping: When true, clamps the output to 0...1.
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

    /// Creates a spring easing from damping ratio and response.
    /// - Parameters:
    ///   - dampingRatio: Damping ratio (ζ).
    ///   - response: Approximate response duration in seconds.
    ///   - initialVelocity: Initial velocity in units per second.
    ///   - overshootClamping: When true, clamps the output to 0...1.
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

    /// Creates a spring easing from SwiftUI-style response and damping fraction.
    /// - Parameters:
    ///   - response: Approximate response duration in seconds.
    ///   - dampingFraction: Damping fraction (ζ).
    ///   - initialVelocity: Initial velocity in units per second.
    ///   - overshootClamping: When true, clamps the output to 0...1.
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

    /// Creates a spring easing from physics parameters.
    /// - Parameters:
    ///   - mass: Mass of the spring system.
    ///   - stiffness: Spring stiffness.
    ///   - damping: Damping coefficient.
    ///   - initialVelocity: Initial velocity in units per second.
    ///   - duration: Duration to normalize the curve over.
    ///   - overshootClamping: When true, clamps the output to 0...1.
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
