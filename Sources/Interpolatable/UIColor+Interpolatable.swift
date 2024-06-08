//
//  Copyright © 2016-present, Pavel Sharanda. All rights reserved.
//

#if !os(macOS)

    import Foundation
    import UIKit

    extension UIColor: Interpolatable {
        // TODO: check alternative interpolations https://raphlinus.github.io/color/2021/01/18/oklab-critique.html

        public func interpolateHSB(to: UIColor, progress: Double, easing: Easing) -> Self {
            var h1: CGFloat = 0
            var s1: CGFloat = 0
            var b1: CGFloat = 0
            var a1: CGFloat = 0
            getHue(&h1, saturation: &s1, brightness: &b1, alpha: &a1)
            var h2: CGFloat = 0
            var s2: CGFloat = 0
            var b2: CGFloat = 0
            var a2: CGFloat = 0
            to.getHue(&h2, saturation: &s2, brightness: &b2, alpha: &a2)

            return Self(
                hue: h1.interpolate(to: h2, progress: progress, easing: easing),
                saturation: s1.interpolate(to: s2, progress: progress, easing: easing),
                brightness: b1.interpolate(to: b2, progress: progress, easing: easing),
                alpha: a1.interpolate(to: a2, progress: progress, easing: easing)
            )
        }

        public func interpolate(to: UIColor, progress: Double, easing: Easing) -> Self {
            var r1: CGFloat = 0
            var g1: CGFloat = 0
            var b1: CGFloat = 0
            var a1: CGFloat = 0
            getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
            var r2: CGFloat = 0
            var g2: CGFloat = 0
            var b2: CGFloat = 0
            var a2: CGFloat = 0
            to.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

            return Self(
                red: r1.interpolate(to: r2, progress: progress, easing: easing),
                green: g1.interpolate(to: g2, progress: progress, easing: easing),
                blue: b1.interpolate(to: b2, progress: progress, easing: easing),
                alpha: a1.interpolate(to: a2, progress: progress, easing: easing)
            )
        }
    }

#endif
