import UIKit

// MARK: - TimeLabelType Enum

enum TimeLabelType {
    case dateStart
    case dateEnd
    
    func returnText() -> String {
        switch self {
        case .dateStart:
            return "Start Date"
        case .dateEnd:
            return "End Date"
        }
    }
}
