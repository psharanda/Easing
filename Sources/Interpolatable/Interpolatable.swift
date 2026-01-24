//
//  Copyright © 2016-present, Pavel Sharanda. All rights reserved.
//

import Foundation

/// A type that can interpolate between two values using an easing curve.
public protocol Interpolatable {
    /// Returns an interpolated value between `self` and `to`.
    /// - Parameters:
    ///   - to: Target value.
    ///   - progress: Interpolation progress in 0...1.
    ///   - easing: Easing curve applied to the progress.
    func interpolate(to: Self, progress: Double, easing: Easing) -> Self
}

public extension Interpolatable {
    /// Returns an interpolated value using linear easing.
    /// - Parameters:
    ///   - to: Target value.
    ///   - progress: Interpolation progress in 0...1.
    func interpolate(to: Self, progress: Double) -> Self {
        return interpolate(to: to, progress: progress, easing: .linear)
    }
}
