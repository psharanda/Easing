//
//  Copyright © 2016-present, Pavel Sharanda. All rights reserved.
//

import CoreGraphics
import Foundation

enum PathElement {
    case moveToPoint(CGPoint)
    case addLineToPoint(CGPoint)
    case addQuadCurveToPoint(controlPoint: CGPoint, endPoint: CGPoint)
    case addCurveToPoint(controlPoint1: CGPoint, controlPoint2: CGPoint, endPoint: CGPoint)
    case closeSubpath
}

extension CGPath {
    static func pathFromPathElements(_ pathElements: [PathElement]) -> CGPath {
        let path = CGMutablePath()

        for pathElement in pathElements {
            switch pathElement {
            case let .moveToPoint(point):
                path.move(to: point)
            case let .addLineToPoint(point):
                path.addLine(to: point)
            case let .addQuadCurveToPoint(controlPoint, endPoint):
                path.addQuadCurve(to: endPoint, control: controlPoint)
            case let .addCurveToPoint(controlPoint1, controlPoint2, endPoint):
                path.addCurve(to: endPoint, control1: controlPoint1, control2: controlPoint2)
            case .closeSubpath:
                path.closeSubpath()
            }
        }
        return path
    }

    func pathElements() -> [PathElement] {
        var result = [PathElement]()

        applyWithBlock { elementPointer in
            let element = elementPointer.pointee
            switch element.type {
            case .moveToPoint:
                let points = Array(UnsafeBufferPointer(start: element.points, count: 1))
                let el = PathElement.moveToPoint(points[0])
                result.append(el)
            case .addLineToPoint:
                let points = Array(UnsafeBufferPointer(start: element.points, count: 1))
                let el = PathElement.addLineToPoint(points[0])
                result.append(el)
            case .addQuadCurveToPoint:
                let points = Array(UnsafeBufferPointer(start: element.points, count: 2))
                let el = PathElement.addQuadCurveToPoint(
                    controlPoint: points[0], endPoint: points[1]
                )
                result.append(el)
            case .addCurveToPoint:
                let points = Array(UnsafeBufferPointer(start: element.points, count: 3))
                let el = PathElement.addCurveToPoint(
                    controlPoint1: points[0], controlPoint2: points[1], endPoint: points[2]
                )
                result.append(el)
            case .closeSubpath:
                result.append(.closeSubpath)
            @unknown default:
                fatalError()
            }
        }

        return result
    }
}
