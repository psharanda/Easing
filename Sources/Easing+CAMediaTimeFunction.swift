//
//  Created by Pavel Sharanda on 09.10.16.
//  Copyright © 2016 SnipSnap. All rights reserved.
//

#if os(macOS) || os (iOS) || os(tvOS)
    
import QuartzCore

extension Easing {
    
    public static let caEaseIn: Easing = {
        #if swift(>=4.2)
        let f = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        #else
        let f = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        #endif        
        return Easing.cubicBezierEasingForMediaFunction(f)
    }()
    
    public static let caEaseOut: Easing = {
        #if swift(>=4.2)
        let f = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        #else
        let f = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        #endif
        return Easing.cubicBezierEasingForMediaFunction(f)
    }()
    
    public static let caEaseInEaseOut: Easing = {
        #if swift(>=4.2)
        let f = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        #else
        let f = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        #endif
        return Easing.cubicBezierEasingForMediaFunction(f)
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


