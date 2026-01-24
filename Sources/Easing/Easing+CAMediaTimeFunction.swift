//
//  Copyright © 2016-present, Pavel Sharanda. All rights reserved.
//

#if !os(watchOS)

    import QuartzCore

    public extension Easing {
        static let caEaseIn: Easing = {
            let f = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            return Easing.cubicBezierEasingForMediaFunction(f)
        }()

        static let caEaseOut: Easing = {
            let f = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            return Easing.cubicBezierEasingForMediaFunction(f)
        }()

        static let caEaseInEaseOut: Easing = {
            let f = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            return Easing.cubicBezierEasingForMediaFunction(f)
        }()

        private static func cubicBezierEasingForMediaFunction(_ m: CAMediaTimingFunction) -> Easing {
            var controlPoint1: [Float] = [0, 0]
            var controlPoint2: [Float] = [0, 0]

            m.getControlPoint(at: 1, values: &controlPoint1)
            m.getControlPoint(at: 2, values: &controlPoint2)

            return Easing.cubicBezier(
                Double(controlPoint1[0]),
                Double(controlPoint1[1]),
                Double(controlPoint2[0]),
                Double(controlPoint2[1])
            )
        }
    }

#endif
