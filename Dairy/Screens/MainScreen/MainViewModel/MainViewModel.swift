//
//  MainViewModel.swift
//  Dairy
//
//  Created by Alexander Suprun on 11.12.2024.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift


final class MainViewModel {
    // MARK: - Public Observables
    let taskArrayPerDay = BehaviorRelay<[TaskModel]>(value: [])
    let selectedDate =  BehaviorRelay<Date?>(value: nil)
    let month = BehaviorRelay<String?>(value: nil)
    let dates = BehaviorRelay<[Date]>(value: [])
    // MARK: -  Properties
    let calendar = Calendar.current
    let disposeBag = DisposeBag()
    
    private var notificationToken: NotificationToken?

    // MARK: - Initializer
    init() {
        setupDaysInMonth()
        loadTasksFromJSON()
        fetchTasksFromRealm()
        
        selectedDate
                  .compactMap { $0 }
                  .subscribe(onNext: { [weak self] date in
                      self?.getTasks(date)
                  })
                  .disposed(by: disposeBag)
    }
    // MARK: - Task Management
    func getTasks(_ date: Date) {
        let calendar = Calendar.current
        
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let startOfDayTimestamp = startOfDay.timeIntervalSince1970
        let endOfDayTimestamp = endOfDay.timeIntervalSince1970
        
        let startOfDayTimestampString = String(format: "%.0f", startOfDayTimestamp)
        let endOfDayTimestampString = String(format: "%.0f", endOfDayTimestamp)
        
        let realm = try! Realm()
        
        let tasksForDate = realm.objects(TaskModel.self)
            .filter { task in
                let isTaskInCurrentDay = (task.dateStart <= endOfDayTimestampString && task.dateFinish >= startOfDayTimestampString)
                return isTaskInCurrentDay
            }
        
        taskArrayPerDay.accept(Array(tasksForDate))
    }




    // MARK: - Setup Methods

    private func setupDaysInMonth() {
        let calendar = Calendar.current
        let today = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let monthString = dateFormatter.string(from: today)
        guard let monthRange = calendar.range(of: .day, in: .month, for: today),
              let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today)) else {
            return
        }
        let datesArray = monthRange.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
        dates.accept(datesArray)
        month.accept(monthString)
        selectedDate.accept(today)
    }
    
    // MARK: - Data Loading
    func loadTasksFromJSON() {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return }

        do {
            let tasks = try JSONDecoder().decode([TaskModel].self, from: data)
            let realm = try Realm()

            try realm.write {
                realm.add(tasks, update: .modified)
            }
        } catch {
            print("Ошибка при загрузке данных из JSON: \(error.localizedDescription)")
        }
    }
    
    func fetchTasksFromRealm() {
        let realm = try! Realm()
        
        let realmTasks = realm.objects(TaskModel.self)
        
        notificationToken = realmTasks.observe { [weak self] changes in
            switch changes {
            case .update(let results, _, _, _):
                guard let selectedDate = self?.selectedDate.value else { return }
                self?.getTasks(selectedDate)
            default:
                break
            }
        }
    }

    deinit {
        notificationToken?.invalidate()
    }
}
