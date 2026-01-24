//
//  Created by Pavel Sharanda on 02/12/2023.
//

@testable import Demo
import iOSSnapshotTestCase
import XCTest

final class EasingDemoTests: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        usesDrawViewHierarchyInRect = true
    }
    
    func test() {
        // recordMode = true
        
        for item in EasingDemoItem.allItems {
            let view = EasingChartView()
            view.easing = item.easing
            let size = view.sizeThatFits(CGSize(width: 100, height: CGFloat.greatestFiniteMagnitude))
            view.frame = CGRect(origin: .zero, size: size)
            FBSnapshotVerifyView(view, identifier: item.name)
        }
    }
}
