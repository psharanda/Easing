//
//  Created by Pavel Sharanda on 09.10.16.
//  Copyright © 2016 SnipSnap. All rights reserved.
//

import CoreGraphics

public protocol DoubleConvertable {
    init(_ v: Double)
    func asDouble() -> Double;
}

extension Double: DoubleConvertable {
    public func asDouble() -> Double {
        return self
    }
}

extension Float: DoubleConvertable {
    public func asDouble() -> Double {
        return Double(self)
    }
}

extension CGFloat: DoubleConvertable {
    public func asDouble() -> Double {
        return Double(self)
    }
}
