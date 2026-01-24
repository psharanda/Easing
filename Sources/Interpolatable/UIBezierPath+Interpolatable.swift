//
//  Copyright © 2016-present, Pavel Sharanda. All rights reserved.
//

#if canImport(UIKit)

    import Foundation
    import UIKit

    extension UIBezierPath: Interpolatable {
        public func interpolate(to: UIBezierPath, progress: Double, easing: Easing) -> Self {
            let pathElements1 = cgPath.pathElements()
            let pathElements2 = to.cgPath.pathElements()

            assert(
                pathElements1.count == pathElements2.count,
                "UIBezierPath.interpolate: number of path elements should be the same"
            )

            var interpolatedPathElements: [PathElement] = []

            var foundMistmatch = false

            for (e1, e2) in zip(pathElements1, pathElements2) {
                switch e1 {
                case let .moveToPoint(p1):
                    switch e2 {
                    case let .moveToPoint(p2):
                        interpolatedPathElements.append(
                            .moveToPoint(p1.interpolate(to: p2, progress: progress, easing: easing)))
                    default:
                        foundMistmatch = true
                    }
                case let .addLineToPoint(p1):
                    switch e2 {
                    case let .addLineToPoint(p2):
                        interpolatedPathElements.append(
                            .addLineToPoint(p1.interpolate(to: p2, progress: progress, easing: easing)))
                    default:
                        foundMistmatch = true
                    }
                case let .addQuadCurveToPoint(c1, d1):
                    switch e2 {
                    case let .addQuadCurveToPoint(c2, d2):
                        interpolatedPathElements.append(
                            .addQuadCurveToPoint(
                                controlPoint: c1.interpolate(to: c2, progress: progress, easing: easing),
                                endPoint: d1.interpolate(to: d2, progress: progress, easing: easing)
                            ))
                    default:
                        foundMistmatch = true
                    }
                case let .addCurveToPoint(f1, s1, e1):
                    switch e2 {
                    case let .addCurveToPoint(l2, r2, e2):
                        interpolatedPathElements.append(
                            .addCurveToPoint(
                                controlPoint1: f1.interpolate(to: l2, progress: progress, easing: easing),
                                controlPoint2: s1.interpolate(to: r2, progress: progress, easing: easing),
                                endPoint: e1.interpolate(to: e2, progress: progress, easing: easing)
                            ))
                    default:
                        foundMistmatch = true
                    }
                case .closeSubpath:
                    switch e2 {
                    case .closeSubpath:
                        interpolatedPathElements.append(.closeSubpath)
                    default:
                        foundMistmatch = true
                    }
                }
            }

            assert(!foundMistmatch, "UIBezierPath.interpolate: path elements type should be the same")

            let interpolatedPath = Self(cgPath: CGPath.pathFromPathElements(interpolatedPathElements))
            interpolatedPath.lineWidth = lineWidth.interpolate(to: to.lineWidth, progress: progress, easing: easing)

            interpolatedPath.lineCapStyle = lineCapStyle
            assert(
                lineCapStyle == to.lineCapStyle,
                "UIBezierPath.interpolate: lineCapStyle should be the same"
            )

            interpolatedPath.lineJoinStyle = lineJoinStyle
            assert(
                lineJoinStyle == to.lineJoinStyle,
                "UIBezierPath.interpolate: lineJoinStyle should be the same"
            )

            interpolatedPath.miterLimit = miterLimit.interpolate(to: to.miterLimit, progress: progress, easing: easing)
            interpolatedPath.flatness = flatness.interpolate(to: to.flatness, progress: progress, easing: easing)

            // TODO: implement line dash pattern interpolation

            interpolatedPath.usesEvenOddFillRule = usesEvenOddFillRule
            assert(
                usesEvenOddFillRule == to.usesEvenOddFillRule,
                "UIBezierPath.interpolate: usesEvenOddFillRule should be the same"
            )

            return interpolatedPath
        }
    }

#endif
