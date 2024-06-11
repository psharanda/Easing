<p align="center">
<img src="Readme/logo.png" width="50%" alt="Easing Logo" />
</p>
Easing library is a comprehensive set of easing functions, useful for interactive animations and other time-based calculations where smooth transitions are necessary.

## Features

- Unified set of easing functions
- Easy-to-use 'swifty' API to invoke calculations
- Interpolation shorthands for the most popular primitive types like CGPoint, CGSize, CGTransform, UIColor and UIBezierPath
- Bridge to CAMediaTimingFunction
- Arbitrary cubic bezier based easings
- Interactive demo app
- Supports iOS 12.0+ / Mac OS X 10.13+ / tvOS 12.0+ / watchOS 4.0+ / visionOS 1.0+

## Usage

### Real world example

Imagine an interaction with a `UIScrollView` where its header is fully visible when the content offset is zero and fades out completely as the content offset exceeds 100 points. You can express this behavior with the following code in your `scrollViewDidScroll` method:

````swift
let minOffset = 0.0
let alphaForMinOffset = 0.0
let maxOffset = 100.0
let alphaForMaxOffset = 1.0
let offset = scrollView.contentOffset.y

headerView.alpha = Easing.quadraticEaseInOut.calculate(
    g1: minOffset,
    d1: alphaForMinOffset,
    g2: maxOffset,
    d2: alphaForMaxOffset,
    g: offset
)
````

### Interpolatable

````swift
let startTransform = CGAffineTransform.identity
let endTransform = CGAffineTransform(scaleX: 2, y: 2)

transformDemoView.transform = startTransform.interpolate(to: endTransform, progress: progress, easing: .linear)

````

## Reference

|  Easing   |  Curve   |
| :---: | :---: |
|`.linear`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_linear@3x.png" width="100"/>|
|`.smoothStep`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_smoothStep@3x.png" width="100"/>|
|`.smootherStep`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_smootherStep@3x.png" width="100"/>|
|`.quadraticEaseIn`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_quadraticEaseIn@3x.png" width="100"/>|
|`.quadraticEaseOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_quadraticEaseOut@3x.png" width="100"/>|
|`.quadraticEaseInOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_quadraticEaseInOut@3x.png" width="100"/>|
|`.cubicEaseIn`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_cubicEaseIn@3x.png" width="100"/>|
|`.cubicEaseOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_cubicEaseOut@3x.png" width="100"/>|
|`.cubicEaseInOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_cubicEaseInOut@3x.png" width="100"/>|
|`.quarticEaseIn`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_quarticEaseIn@3x.png" width="100"/>|
|`.quarticEaseOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_quarticEaseOut@3x.png" width="100"/>|
|`.quarticEaseInOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_quarticEaseInOut@3x.png" width="100"/>|
|`.quinticEaseIn`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_quinticEaseIn@3x.png" width="100"/>|
|`.quinticEaseOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_quinticEaseOut@3x.png" width="100"/>|
|`.quinticEaseInOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_quinticEaseInOut@3x.png" width="100"/>|
|`.sineEaseIn`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_sineEaseIn@3x.png" width="100"/>|
|`.sineEaseOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_sineEaseOut@3x.png" width="100"/>|
|`.sineEaseInOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_sineEaseInOut@3x.png" width="100"/>|
|`.circularEaseIn`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_circularEaseIn@3x.png" width="100"/>|
|`.circularEaseOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_circularEaseOut@3x.png" width="100"/>|
|`.circularEaseInOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_circularEaseInOut@3x.png" width="100"/>|
|`.exponentialEaseIn`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_exponentialEaseIn@3x.png" width="100"/>|
|`.exponentialEaseOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_exponentialEaseOut@3x.png" width="100"/>|
|`.exponentialEaseInOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_exponentialEaseInOut@3x.png" width="100"/>|
|`.elasticEaseIn`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_elasticEaseIn@3x.png" width="100"/>|
|`.elasticEaseOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_elasticEaseOut@3x.png" width="100"/>|
|`.elasticEaseInOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_elasticEaseInOut@3x.png" width="100"/>|
|`.backEaseIn`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_backEaseIn@3x.png" width="100"/>|
|`.backEaseOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_backEaseOut@3x.png" width="100"/>|
|`.backEaseInOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_backEaseInOut@3x.png" width="100"/>|
|`.bounceEaseIn`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_bounceEaseIn@3x.png" width="100"/>|
|`.bounceEaseOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_bounceEaseOut@3x.png" width="100"/>|
|`.bounceEaseInOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_bounceEaseInOut@3x.png" width="100"/>|
|`.caEaseIn`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_caEaseIn@3x.png" width="100"/>|
|`.caEaseOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_caEaseOut@3x.png" width="100"/>|
|`.caEaseInEaseOut`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_caEaseInEaseOut@3x.png" width="100"/>|
|`.cubicBezier(0.11, 0.87, 0.21, -0.88)`|<img src="Demo/Ref/ReferenceImages_64/DemoTests.EasingDemoTests/test_cubicBezier_0_11__0_87__0_21__0_88_@3x.png" width="100"/>|

## Demo app
In the repo, you will find an interactive demo iOS app to experiment with different easings and discover the most suitable one for your needs.

<img src="Readme/demo.png" width="25%" align=left/><img src="Readme/demo.gif" width="25%" />


## Integration

Use Swift Package Manager and add dependency to `Package.swift` file.

```swift
  dependencies: [
    .package(url: "https://github.com/psharanda/Easing.git", .upToNextMajor(from: "3.0.0"))
  ]
```

Alternatively, in Xcode select `File > Add Package Dependencies…` and add Easing repository URL:

```
https://github.com/psharanda/Easing.git
```

## References

The main set of easing functions is a Swift port of https://github.com/warrenm/AHEasing which is a port of https://github.com/ai/easings.net (https://easings.net)

`CubicBezierInterpolator` is a Swift port of `nsSMILKeySpline` code from Mozilla https://github.com/mozilla-services/services-central-legacy/blob/master/content/smil/nsSMILKeySpline.cpp

## Contributing

We welcome contributions! If you find a bug, have a feature request, or want to contribute code, please open an issue or submit a pull request.

## License

Easing is available under the MIT license. See the LICENSE file for more info.
