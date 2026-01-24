//
//  Copyright © 2016-present, Pavel Sharanda. All rights reserved.
//

import Foundation

public struct PiecewiseLinearStop {
    public var x: Double?
    public var y: Double

    public init(_ y: Double, at x: Double? = nil) {
        self.y = y
        self.x = x
    }
}

public extension Easing {
    static func piecewiseLinear(_ stops: [PiecewiseLinearStop]) -> Easing {
        let resolvedStops = PiecewiseLinearSolver.resolveStops(stops)
        return Easing { p in
            PiecewiseLinearSolver.evaluate(p, stops: resolvedStops)
        }
    }
}

private enum PiecewiseLinearSolver {
    static func resolveStops(_ stops: [PiecewiseLinearStop]) -> [(x: Double, y: Double)] {
        guard !stops.isEmpty else {
            return []
        }

        struct Point {
            var input: Double?
            var output: Double
        }

        var points: [Point] = []
        var largestInput = -Double.infinity

        for (idx, stop) in stops.enumerated() {
            var point = Point(input: nil, output: stop.y)
            if let x = stop.x {
                let clamped = max(x, largestInput)
                point.input = clamped
                largestInput = clamped
            } else if idx == 0 {
                point.input = 0
                largestInput = 0
            } else if idx == stops.count - 1 {
                let clamped = max(1, largestInput)
                point.input = clamped
                largestInput = clamped
            }
            points.append(point)
        }

        var i = 0
        while i < points.count {
            if points[i].input != nil {
                i += 1
                continue
            }
            let start = i
            var end = i
            while end < points.count, points[end].input == nil {
                end += 1
            }
            let prevIndex = start - 1
            let nextIndex = end
            let prevInput = points[prevIndex].input ?? 0
            let nextInput = points[nextIndex].input ?? prevInput
            let runCount = nextIndex - prevIndex
            let step = (nextInput - prevInput) / Double(runCount)
            for offset in 1 ..< runCount {
                points[prevIndex + offset].input = prevInput + step * Double(offset)
            }
            i = end
        }

        return points.map { (x: $0.input ?? 0, y: $0.output) }
    }

    static func evaluate(_ p: Double, stops: [(x: Double, y: Double)]) -> Double {
        guard !stops.isEmpty else {
            return p
        }

        if stops.count == 1 {
            return stops[0].y
        }

        var pointAIndex = 0
        for i in 0 ..< stops.count {
            if stops[i].x <= p {
                pointAIndex = i
            } else {
                break
            }
        }

        if pointAIndex == stops.count - 1 {
            pointAIndex -= 1
        }

        let pointA = stops[pointAIndex]
        let pointB = stops[pointAIndex + 1]

        if pointA.x == pointB.x {
            return pointB.y
        }

        let progressFromPointA = p - pointA.x
        let pointInputRange = pointB.x - pointA.x
        let progressBetweenPoints = progressFromPointA / pointInputRange
        let pointOutputRange = pointB.y - pointA.y
        let outputFromLastPoint = progressBetweenPoints * pointOutputRange
        return pointA.y + outputFromLastPoint
    }
}
