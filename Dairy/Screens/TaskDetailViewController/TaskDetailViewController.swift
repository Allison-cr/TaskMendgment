//
//  TaskDetailViewController.swift
//  Dairy
//
//  Created by Alexander Suprun on 25.12.2024.
//

import Foundation
import UIKit
import RealmSwift

final class TaskDetailViewController: UIViewController {
    private var task: TaskModel
    
    // MARK: UI
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private lazy var backgoundImage: UIImageView = setupBackgoundImage()
    private lazy var backButton: UIButton = setupBackButton()
    private lazy var startTimeView: CustomView = setupStartTimeView()
    private lazy var endTimeView: CustomView = setupEndTimeView()
    private lazy var nameTextField: UITextField = setupNameTextField()
    private lazy var descriptionTextField: UITextView = setupDescriptionTextView()
    private lazy var nameLabel: UILabel = setupLabel()
    private lazy var descriptionLabel: UILabel = setupDescription()
    private lazy var deleteButton: UIButton = setupDeleteButton()
    private lazy var saveButton: UIButton = setupSaveButton()
    private lazy var blurDescriptionView: UIView = setupBlurView()
    private lazy var blurNameView: UIView = setupBlurView()
    
    // MARK: - Properties
    var startDate = Date()
    var endDate = Date()
    // MARK: Depency 
    weak var coordinator: MainCoordinator?
    // MARK: Init
    init(task: TaskModel) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
        startDate = task.startDate ?? Date()
        endDate = task.finishDate ?? Date()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    // Blur
    private func setupBlurEffect() {
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
}
// MARK: Setup UI
private extension TaskDetailViewController {
    func setupUI() {
        view.insertSubview(backgoundImage, at: 0)
        NSLayoutConstraint.activate([
            backgoundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgoundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgoundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgoundImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)
            ])
        setupBlurEffect()
        NSLayoutConstraint.activate([
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            startTimeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            startTimeView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            startTimeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            startTimeView.heightAnchor.constraint(equalToConstant: 80),

            endTimeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            endTimeView.topAnchor.constraint(equalTo: startTimeView.bottomAnchor, constant: 8),
            endTimeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            endTimeView.heightAnchor.constraint(equalToConstant: 80),

            blurNameView.topAnchor.constraint(equalTo: endTimeView.bottomAnchor, constant: 16),
            blurNameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            blurNameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            blurNameView.heightAnchor.constraint(equalToConstant: 110),
     
            nameLabel.topAnchor.constraint(equalTo: blurNameView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: blurNameView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: blurNameView.trailingAnchor, constant: -16),
            nameLabel.heightAnchor.constraint(equalToConstant: 32),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: blurNameView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: blurNameView.trailingAnchor, constant: -16),
            nameTextField.bottomAnchor.constraint(equalTo: blurNameView.bottomAnchor, constant: -16 ),

            blurDescriptionView.topAnchor.constraint(equalTo: blurNameView.bottomAnchor, constant: 16),
            blurDescriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            blurDescriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            blurDescriptionView.heightAnchor.constraint(equalToConstant: 240),
      
            descriptionLabel.topAnchor.constraint(equalTo: blurDescriptionView.topAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: blurDescriptionView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: blurDescriptionView.trailingAnchor, constant: -16),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 32),
      
            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            descriptionTextField.leadingAnchor.constraint(equalTo: blurDescriptionView.leadingAnchor, constant: 16),
            descriptionTextField.trailingAnchor.constraint(equalTo: blurDescriptionView.trailingAnchor, constant: -16),
            descriptionTextField.bottomAnchor.constraint(equalTo: blurDescriptionView.bottomAnchor, constant: -16 ),
            
            
            deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            deleteButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 2 - 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 48),
            
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 2  - 24),
            saveButton.heightAnchor.constraint(equalToConstant: 48),
          
         ])
    }

}

// MARK: Show alert error time
private extension TaskDetailViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - obj action
private extension TaskDetailViewController {
    @objc func backButtonTapped() {
        coordinator?.back()
    }
    @objc func saveTask() {
        
        if startDate > endDate {
            showAlert(title: "Error", message: "Time start must be earlier than time finish.")
            return
        }
        do {
            let realm = try Realm()
            try realm.write {
                task.name = nameTextField.text ?? ""
                task.descriptionText = descriptionTextField.text ?? ""
                task.dateStart = String(Int(startDate.timeIntervalSince1970))
                task.dateFinish = String(Int(endDate.timeIntervalSince1970))
            }
            coordinator?.back()
        } catch {
            print("Failed to save task: \(error.localizedDescription)")
        }
    }
    @objc func deleteTask() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(task)
            }
            coordinator?.back()
        } catch {
            print("Failed to delete task: \(error.localizedDescription)")
        }
    }
}

// MARK: Setup UI
private extension TaskDetailViewController {
    func setupBackgoundImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "back")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        return imageView
    }
    
    func setupBackButton() -> UIButton {
        let backButton = UIButton()
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.tintColor = .white
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        return backButton
    }
    
    func setupNameTextField() -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.text = task.name
        textField.backgroundColor = .lightGray
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        return textField
    }
    
    func setupDescriptionTextView() -> UITextView {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.text = task.descriptionText
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .lightGray
        textView.isScrollEnabled = true
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        blurDescriptionView.addSubview(textView)
        return textView
    }

    func setupLabel() -> UILabel {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = .black
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    func setupDescription() -> UILabel {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = .black
        blurDescriptionView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func setupSaveButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.black, for: .normal)
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = button.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = false
        button.insertSubview(blurEffectView, at: 0)
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return button
    }
    
    func setupDeleteButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.red, for: .normal)
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = button.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = false
        button.insertSubview(blurEffectView, at: 0)
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 1
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(deleteTask), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return button
    }
    
    func setupBlurView() -> UIView {
        let blurView = UIView()
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.insertSubview(blurEffectView, at: 0)
        blurView.layer.cornerRadius = 8
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)
        return blurView
    }
    
    func setupStartTimeView() -> CustomView {
    let customView = CustomView(timeLabelType: .dateStart, date: startDate)
       customView.onDateChange = { [weak self] newDate in
           self?.startDate = newDate
       }
       customView.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(customView)
       return customView
   }

    func setupEndTimeView() -> CustomView {
        let customView = CustomView(timeLabelType: .dateEnd, date: endDate)
        customView.onDateChange = { [weak self] newDate in
            self?.endDate = newDate
        }
        customView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customView)
        return customView
    }
}
