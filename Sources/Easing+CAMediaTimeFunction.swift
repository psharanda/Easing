//
//  Created by Pavel Sharanda on 09.10.16.
//  Copyright © 2016 SnipSnap. All rights reserved.
//

#if os(macOS) || os (iOS) || os(tvOS)
    
import QuartzCore

extension Easing {
    
    public static let caEaseIn: Easing = {
        return Easing.cubicBezierEasingForMediaFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn))
    }()
    
    public static let caEaseOut: Easing = {
        return Easing.cubicBezierEasingForMediaFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
    }()
    
    public static let caEaseInEaseOut: Easing = {
        return Easing.cubicBezierEasingForMediaFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }()
    
    private static func cubicBezierEasingForMediaFunction(_ m: CAMediaTimingFunction) -> Easing {
        var controlPoint1: [Float] = [0,0]
        var controlPoint2: [Float] = [0,0]
        
        m.getControlPoint(at: 1, values: &controlPoint1)
        m.getControlPoint(at: 2, values: &controlPoint2)
        
        return Easing.cubicBezier(Double(controlPoint1[0]), Double(controlPoint1[1]), Double(controlPoint2[0]), Double(controlPoint2[1]))
    }
}
    
#endif


