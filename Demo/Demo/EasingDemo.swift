//
//  Copyright © 2024-present, Pavel Sharanda. All rights reserved.
//

import Foundation

struct EasingDemoItem {
    let name: String
    let easing: Easing
    
    static let allItems = [
        EasingDemoItem(name: "linear", easing: .linear),

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


