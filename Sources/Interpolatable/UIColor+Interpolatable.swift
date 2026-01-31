//
//  Copyright © 2016-present, Pavel Sharanda. All rights reserved.
//

#if canImport(UIKit)

import Foundation
import UIKit

extension UIColor: Interpolatable {
    // TODO: check alternative interpolations https://raphlinus.github.io/color/2021/01/18/oklab-critique.html
    private static func clamp01(_ value: CGFloat) -> CGFloat {
        return min(1, max(0, value))
    }

    private func rgbaComponents() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r, g, b, a)
        }

        var w: CGFloat = 0
        if getWhite(&w, alpha: &a) {
            return (w, w, w, a)
        }

        let cg = cgColor
        if let comps = cg.components {
            if comps.count == 2 {
                return (comps[0], comps[0], comps[0], comps[1])
            }
            if comps.count >= 3 {
                return (comps[0], comps[1], comps[2], cg.alpha)
            }
        }

        return (0, 0, 0, cg.alpha)
    }

    private static func rgbToHsb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> (CGFloat, CGFloat, CGFloat) {
        let maxValue = max(r, max(g, b))
        let minValue = min(r, min(g, b))
        let delta = maxValue - minValue

        var h: CGFloat = 0
        if delta != 0 {
            if maxValue == r {
                h = (g - b) / delta
            } else if maxValue == g {
                h = ((b - r) / delta) + 2
            } else {
                h = ((r - g) / delta) + 4
            }
            h /= 6
            if h < 0 {
                h += 1
            }
        }

        let s = maxValue == 0 ? 0 : (delta / maxValue)
        let v = maxValue
        return (h, s, v)
    }

    private func hsbComponents() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        if getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            return (h, s, b, a)
        }

        let (r, g, blue, alpha) = rgbaComponents()
        let (h2, s2, b2) = Self.rgbToHsb(r, g, blue)
        return (h2, s2, b2, alpha)
    }

    /// Interpolates between colors in HSB space.
    public func interpolateHSB(to: UIColor, progress: Double, easing: Easing) -> Self {
        let (h1, s1, b1, a1) = hsbComponents()
        let (h2, s2, b2, a2) = to.hsbComponents()

        return Self(
            hue: Self.clamp01(h1.interpolate(to: h2, progress: progress, easing: easing)),
            saturation: Self.clamp01(s1.interpolate(to: s2, progress: progress, easing: easing)),
            brightness: Self.clamp01(b1.interpolate(to: b2, progress: progress, easing: easing)),
            alpha: Self.clamp01(a1.interpolate(to: a2, progress: progress, easing: easing))
        )
    }

    /// Interpolates between colors in RGB space.
    public func interpolate(to: UIColor, progress: Double, easing: Easing) -> Self {
        let (r1, g1, b1, a1) = rgbaComponents()
        let (r2, g2, b2, a2) = to.rgbaComponents()

        return Self(
            red: Self.clamp01(r1.interpolate(to: r2, progress: progress, easing: easing)),
            green: Self.clamp01(g1.interpolate(to: g2, progress: progress, easing: easing)),
            blue: Self.clamp01(b1.interpolate(to: b2, progress: progress, easing: easing)),
            alpha: Self.clamp01(a1.interpolate(to: a2, progress: progress, easing: easing))
        )
    }
}

#endif
