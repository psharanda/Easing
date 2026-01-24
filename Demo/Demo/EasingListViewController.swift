//
//  Copyright © 2024-present, Pavel Sharanda. All rights reserved.
//

import FixFlex
import UIKit

class EasingListViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Easing Demo"

        tableView.register(EasingDemoCell.self, forCellReuseIdentifier: "CellId")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 32
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as! EasingDemoCell
        cell.demoItem = EasingDemoItem.allItems[indexPath.row]
        return cell
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        EasingDemoItem.allItems.count
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EasingViewController(demoItem: EasingDemoItem.allItems[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}
