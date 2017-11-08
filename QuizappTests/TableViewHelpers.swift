import Foundation
import UIKit

extension UITableView {
  
  func cell(at index: Int) -> UITableViewCell? {
    return dataSource?.tableView(self, cellForRowAt: IndexPath(row: index, section: 0))
  }
  
  func title(at row: Int) -> String? {
    return cell(at: row)?.textLabel?.text
  }
  
  func selectRowAt(index: Int) {
    selectRow(at: IndexPath(row: index, section: 0),
              animated: false,
              scrollPosition: .bottom)
    delegate?.tableView?(self, didSelectRowAt: IndexPath(row: index, section: 0))
  }
  
  func deselectRowAt(index: Int) {
    deselectRow(at: IndexPath(row: index, section: 0),
                animated: false)
    delegate?.tableView?(self, didDeselectRowAt: IndexPath(row: index, section: 0))
  }
}
