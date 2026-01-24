//
//  Copyright © 2024-present, Pavel Sharanda. All rights reserved.
//

import Foundation

struct EasingDemoItem {
    let name: String
    let easing: Easing

    static let allItems = [
        EasingDemoItem(name: "linear", easing: .linear),
        EasingDemoItem(
            name: "piecewiseLinear(0, 1@0.6, 0)",
            easing: .piecewiseLinear([
                PiecewiseLinearStop(0, at: 0),
                PiecewiseLinearStop(1, at: 0.6),
                PiecewiseLinearStop(0, at: 1),
            ])
        ),
        EasingDemoItem(
            name: "piecewiseLinear(spring)",
            easing: .piecewiseLinear([
                PiecewiseLinearStop(0),
                PiecewiseLinearStop(0.00217, at: 0.005),
                PiecewiseLinearStop(0.00866, at: 0.0101),
                PiecewiseLinearStop(0.0194, at: 0.0153),
                PiecewiseLinearStop(0.0346, at: 0.0207),
                PiecewiseLinearStop(0.0782, at: 0.032),
                PiecewiseLinearStop(0.14066, at: 0.0443),
                PiecewiseLinearStop(0.28086, at: 0.06651),
                PiecewiseLinearStop(0.59369, at: 0.11011),
                PiecewiseLinearStop(0.72289, at: 0.12911),
                PiecewiseLinearStop(0.84164, at: 0.14861),
                PiecewiseLinearStop(0.93834, at: 0.16722),
                PiecewiseLinearStop(1.01676, at: 0.18572),
                PiecewiseLinearStop(1.04935),
                PiecewiseLinearStop(1.07743, at: 0.20432),
                PiecewiseLinearStop(1.10134, at: 0.21372),
                PiecewiseLinearStop(1.12131, at: 0.22332),
                PiecewiseLinearStop(1.1373, at: 0.23312),
                PiecewiseLinearStop(1.14934, at: 0.24312),
                PiecewiseLinearStop(1.15493, at: 0.24952),
                PiecewiseLinearStop(1.15904, at: 0.25603),
                PiecewiseLinearStop(1.16172, at: 0.26273),
                PiecewiseLinearStop(1.16294, at: 0.26953),
                PiecewiseLinearStop(1.16275, at: 0.27653),
                PiecewiseLinearStop(1.16113, at: 0.28383),
                PiecewiseLinearStop(1.15356, at: 0.29933),
                PiecewiseLinearStop(1.14335, at: 0.31273),
                PiecewiseLinearStop(1.12887, at: 0.32783),
                PiecewiseLinearStop(1.05059, at: 0.39614),
                PiecewiseLinearStop(1.03211, at: 0.41404),
                PiecewiseLinearStop(1.01677, at: 0.43094),
                PiecewiseLinearStop(1.00206),
                PiecewiseLinearStop(0.99057, at: 0.46975),
                PiecewiseLinearStop(0.98215, at: 0.48945),
                PiecewiseLinearStop(0.9766, at: 0.50995),
                PiecewiseLinearStop(0.9735, at: 0.53835),
                PiecewiseLinearStop(0.97488, at: 0.57056),
                PiecewiseLinearStop(0.97907, at: 0.60036),
                PiecewiseLinearStop(0.9966, at: 0.69827),
                PiecewiseLinearStop(1.00078, at: 0.73327),
                PiecewiseLinearStop(1.00329, at: 0.76878),
                PiecewiseLinearStop(1.00417, at: 0.83808),
                PiecewiseLinearStop(0.99996),
            ])
        ),
        EasingDemoItem(
            name: "spring(.swiftUISpring)",
            easing: .spring(.swiftUISpring, initialVelocity: 0)
        ),
        EasingDemoItem(
            name: "spring(.swiftUIInteractiveSpring)",
            easing: .spring(.swiftUIInteractiveSpring, initialVelocity: 0)
        ),
        EasingDemoItem(
            name: "spring(dampingRatio:0.7,response:0.4)",
            easing: .spring(dampingRatio: 0.7, response: 0.4, initialVelocity: 0)
        ),
        EasingDemoItem(
            name: "spring(response:0.5,dampingFraction:0.825)",
            easing: .spring(response: 0.5, dampingFraction: 0.825, initialVelocity: 0)
        ),
        EasingDemoItem(
            name: "spring(mass:1,stiffness:100,damping:10,duration:1)",
            easing: .spring(
                mass: 1,
                stiffness: 100,
                damping: 10,
                initialVelocity: 0,
                duration: 1
            )
        ),

        EasingDemoItem(name: "smoothStep", easing: .smoothStep),
        EasingDemoItem(name: "smootherStep", easing: .smootherStep),

        EasingDemoItem(name: "quadraticEaseIn", easing: .quadraticEaseIn),
        EasingDemoItem(name: "quadraticEaseOut", easing: .quadraticEaseOut),
        EasingDemoItem(name: "quadraticEaseInOut", easing: .quadraticEaseInOut),

        EasingDemoItem(name: "cubicEaseIn", easing: .cubicEaseIn),
        EasingDemoItem(name: "cubicEaseOut", easing: .cubicEaseOut),
        EasingDemoItem(name: "cubicEaseInOut", easing: .cubicEaseInOut),

        EasingDemoItem(name: "quarticEaseIn", easing: .quarticEaseIn),
        EasingDemoItem(name: "quarticEaseOut", easing: .quarticEaseOut),
        EasingDemoItem(name: "quarticEaseInOut", easing: .quarticEaseInOut),

        EasingDemoItem(name: "quinticEaseIn", easing: .quinticEaseIn),
        EasingDemoItem(name: "quinticEaseOut", easing: .quinticEaseOut),
        EasingDemoItem(name: "quinticEaseInOut", easing: .quinticEaseInOut),

        EasingDemoItem(name: "sineEaseIn", easing: .sineEaseIn),
        EasingDemoItem(name: "sineEaseOut", easing: .sineEaseOut),
        EasingDemoItem(name: "sineEaseInOut", easing: .sineEaseInOut),

        EasingDemoItem(name: "circularEaseIn", easing: .circularEaseIn),
        EasingDemoItem(name: "circularEaseOut", easing: .circularEaseOut),
        EasingDemoItem(name: "circularEaseInOut", easing: .circularEaseInOut),

        EasingDemoItem(name: "exponentialEaseIn", easing: .exponentialEaseIn),
        EasingDemoItem(name: "exponentialEaseOut", easing: .exponentialEaseOut),
        EasingDemoItem(name: "exponentialEaseInOut", easing: .exponentialEaseInOut),

        EasingDemoItem(name: "elasticEaseIn", easing: .elasticEaseIn),
        EasingDemoItem(name: "elasticEaseOut", easing: .elasticEaseOut),
        EasingDemoItem(name: "elasticEaseInOut", easing: .elasticEaseInOut),

        EasingDemoItem(name: "backEaseIn", easing: .backEaseIn),
        EasingDemoItem(name: "backEaseOut", easing: .backEaseOut),
        EasingDemoItem(name: "backEaseInOut", easing: .backEaseInOut),

        EasingDemoItem(name: "bounceEaseIn", easing: .bounceEaseIn),
        EasingDemoItem(name: "bounceEaseOut", easing: .bounceEaseOut),
        EasingDemoItem(name: "bounceEaseInOut", easing: .bounceEaseInOut),

        EasingDemoItem(name: "caEaseIn", easing: .caEaseIn),
        EasingDemoItem(name: "caEaseOut", easing: .caEaseOut),
        EasingDemoItem(name: "caEaseInEaseOut", easing: .caEaseInEaseOut),

        EasingDemoItem(name: "cubicBezier(0.11, 0.87, 0.21,-0.88)", easing: .cubicBezier(0.11, 0.87, 0.21, -0.88)),
    ]
}
