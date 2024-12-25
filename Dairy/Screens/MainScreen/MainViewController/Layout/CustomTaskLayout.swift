import Foundation
import UIKit

class CustomTaskLayout: UICollectionViewLayout {
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    
    private let hourHeight: CGFloat = 100
    private let columnWidth: CGFloat = 250
    private let columnSpacing: CGFloat = 8
    
    var tasks: [TaskModel] = []
    var selectedDay: Date?
    
    override func prepare() {
        super.prepare()
        layoutAttributes.removeAll()
        contentHeight = 0
        
        var columns: [[TaskModel]] = []

        guard let selectedDay = selectedDay else { return }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDay)
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: selectedDay)!
        // MARK: - Method for colums
        for task in tasks {
            var placed = false
            
            var taskStartDate = task.startDate ?? Date()
            var taskFinishDate = task.finishDate ?? Date()
            if taskStartDate < startOfDay {
                taskStartDate = startOfDay
            }
        
            if taskFinishDate > endOfDay {
                taskFinishDate = endOfDay
            }

            guard taskStartDate <= taskFinishDate else {
                continue
            }

            for column in columns.indices {
                if columns[column].allSatisfy({ !$0.overlaps(with: task) }) {
                    columns[column].append(task)
                    placed = true
                    break
                }
            }
            
            if !placed {
                columns.append([task])
            }
        }
        // MARK: - Distribution tasks
        for (columnIndex, column) in columns.enumerated() {
            for task in column {
                let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: layoutAttributes.count, section: 0))
                var taskStartDate = task.startDate ?? Date()
                var taskFinishDate = task.finishDate ?? Date()
                
                if taskStartDate < startOfDay {
                    taskStartDate = startOfDay
                }
                
                if taskFinishDate > endOfDay {
                    taskFinishDate = endOfDay
                }
                
                let startHour = Calendar.current.component(.hour, from: taskStartDate)
                let startMinute = Calendar.current.component(.minute, from: taskStartDate)
                let endHour = Calendar.current.component(.hour, from: taskFinishDate)
                let endMinute = Calendar.current.component(.minute, from: taskFinishDate)
                
                let yPosition = CGFloat(startHour) * hourHeight + CGFloat(startMinute) / 60.0 * hourHeight
                let taskHeight = (CGFloat(endHour - startHour) * hourHeight) +
                                 (CGFloat(endMinute - startMinute) / 60.0 * hourHeight)

                let xPosition = CGFloat(columnIndex) * (columnWidth + columnSpacing)
                
                attributes.frame = CGRect(x: xPosition, y: yPosition, width: columnWidth, height: taskHeight)
                
                layoutAttributes.append(attributes)
                contentHeight = max(contentHeight, attributes.frame.maxY)
            }
        }

    }
    override var collectionViewContentSize: CGSize {
        let totalWidth = CGFloat(layoutAttributes.count) * (columnWidth + columnSpacing)
        return CGSize(width: totalWidth, height: CGFloat(2400))
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.item]
    }
}


extension CustomTaskLayout {
    func updateTasks(_ tasks: [TaskModel], _ selectedDay: Date) {
        self.tasks = tasks
        self.selectedDay = selectedDay
//        invalidateLayout()
//        prepare()
    }
}

