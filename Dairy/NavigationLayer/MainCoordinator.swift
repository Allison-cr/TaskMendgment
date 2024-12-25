//
//  MainCoordinator.swift
//  Dairy
//
//  Created by Alexander Suprun on 11.12.2024.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    func start()
}

class MainCoordinator: Coordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = MainViewModel()
        let viewContoller = MainViewController(viewModel: viewModel)
        viewContoller.coordinator = self
        navigationController.pushViewController(viewContoller, animated: true)
        navigationController.isNavigationBarHidden = true
    }
    
    func pushToAddTask() {
        let addTaskVC = AddTaskModalViewController()
        addTaskVC.modalPresentationStyle = .overFullScreen
        navigationController.topViewController?.present(addTaskVC, animated: true, completion: nil)
    }
    
    func showTaskDetails(task: TaskModel) {
        let taskDetailVC = TaskDetailViewController(task: task)
        taskDetailVC.coordinator = self
        navigationController.pushViewController(taskDetailVC, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }

}
