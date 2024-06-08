//
//  Copyright © 2016-present, Pavel Sharanda. All rights reserved.
//

import CoreGraphics
import Foundation

extension CGFloat: Interpolatable {
    public func interpolate(to: CGFloat, progress: Double, easing: Easing) -> Self {
        return easing.calculate(d1: self, d2: to, g: progress)
    }
}

extension CGPoint: Interpolatable {
    public func interpolate(to: CGPoint, progress: Double, easing: Easing) -> Self {
        return CGPoint(
            x: x.interpolate(to: to.x, progress: progress, easing: easing),
            y: y.interpolate(to: to.y, progress: progress, easing: easing)
        )
    }
}

extension CGRect: Interpolatable {
    public func interpolate(to: CGRect, progress: Double, easing: Easing) -> Self {
        return CGRect(
            x: origin.x.interpolate(to: to.origin.x, progress: progress, easing: easing),
            y: origin.y.interpolate(to: to.origin.y, progress: progress, easing: easing),
            width: size.width.interpolate(to: to.size.width, progress: progress, easing: easing),
            height: size.height.interpolate(to: to.size.height, progress: progress, easing: easing)
        )
    }
}

extension CGSize: Interpolatable {
    public func interpolate(to: CGSize, progress: Double, easing: Easing) -> Self {
        return CGSize(
            width: width.interpolate(to: to.width, progress: progress, easing: easing),
            height: height.interpolate(to: to.height, progress: progress, easing: easing)
        )
    }
}

extension CGAffineTransform: Interpolatable {
    public func interpolate(to: CGAffineTransform, progress: Double, easing: Easing) -> Self {
        return CGAffineTransform(tx: tx.interpolate(to: to.tx, progress: progress, easing: easing),
                                 ty: ty.interpolate(to: to.ty, progress: progress, easing: easing),
                                 scaleX: scaleX.interpolate(to: to.scaleX, progress: progress, easing: easing),
                                 scaleY: scaleY.interpolate(to: to.scaleY, progress: progress, easing: easing),
                                 rotation: rotation.interpolate(to: to.rotation, progress: progress, easing: easing))
    }

    var scaleX: CGFloat { sqrt(a * a + c * c) }
    var scaleY: CGFloat { sqrt(b * b + d * d) }
    var rotation: CGFloat { atan2(b, a) }

    init(tx: CGFloat, ty: CGFloat, scaleX: CGFloat, scaleY: CGFloat, rotation: CGFloat) {
        let translationTransform = CGAffineTransform(translationX: tx, y: ty)
        let scaleTransform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        let rotationTransform = CGAffineTransform(rotationAngle: rotation)
        self = rotationTransform.concatenating(scaleTransform).concatenating(translationTransform)
    }
}
