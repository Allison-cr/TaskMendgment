//
//  TaskModel.swift
//  Dairy
//
//  Created by Alexander Suprun on 13.12.2024.
//
import RealmSwift

// MARK: - TaskModel

class TaskModel: Object, Decodable {
    // MARK: - Properties

    /// ID task object
    @Persisted(primaryKey: true) var id: Int
    
    /// Date start task object
    @Persisted var dateStart: String
    
    /// Date end task object
    @Persisted var dateFinish: String
    
    /// Name task object
    @Persisted var name: String
    
    /// Desctiption start task object
    @Persisted var descriptionText: String

    private enum CodingKeys: String, CodingKey {
        case id
        case dateStart = "date_start"
        case dateFinish = "date_finish"
        case name
        case descriptionText = "description"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.dateStart = try container.decode(String.self, forKey: .dateStart)
        self.dateFinish = try container.decode(String.self, forKey: .dateFinish)
        self.name = try container.decode(String.self, forKey: .name)
        self.descriptionText = try container.decode(String.self, forKey: .descriptionText)
    }
}


extension TaskModel {
    func overlaps(with other: TaskModel) -> Bool {
        return (dateStart < other.dateFinish) && (dateFinish > other.dateStart)
    }
    
    var startDate: Date? {
        guard let timestamp = Double(dateStart) else { return nil }
        return Date(timeIntervalSince1970: timestamp)
    }
    
    var finishDate: Date? {
        guard let timestamp = Double(dateFinish) else { return nil }
        return Date(timeIntervalSince1970: timestamp)
    }
    
    func formattedDate(from timestamp: String, format: String = "HH:mm") -> String? {
           guard let timeInterval = Double(timestamp) else { return nil }
           let date = Date(timeIntervalSince1970: timeInterval)
           
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = format
           return dateFormatter.string(from: date)
       }
       
       /// Formatted string from date
       var formattedStartDate: String? {
           return formattedDate(from: dateStart)
       }
       
        /// Formatted string from date
       var formattedFinishDate: String? {
           return formattedDate(from: dateFinish)
       }
}
