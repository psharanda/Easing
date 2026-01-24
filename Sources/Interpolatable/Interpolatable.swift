//
//  Copyright © 2016-present, Pavel Sharanda. All rights reserved.
//

import Foundation

public protocol Interpolatable {
    func interpolate(to: Self, progress: Double, easing: Easing) -> Self
}

public extension Interpolatable {
    func interpolate(to: Self, progress: Double) -> Self {
        return interpolate(to: to, progress: progress, easing: .linear)
    }
}
