//
//  AddTaskModalViewController.swift
//  Dairy
//
//  Created by Alexander Suprun on 13.12.2024.
//

import UIKit
import RealmSwift

final class AddTaskModalViewController: UIViewController {
    // MARK: - UI
    private lazy var nameTextField: UITextField = setupNameTextField()
    private lazy var descriptionTextField: UITextView = setupDescriptionTextView()
    private lazy var saveButton: UIButton = setupSaveButton()
    private lazy var cancelButton: UIButton = setupCancelButton()
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
    private lazy var container: UIView = setupContainer()
    private lazy var blurDescriptionView: UIView = setupBlurView()
    private lazy var blurNameView: UIView = setupBlurView()
    private lazy var startTimeView: CustomView = setupStartTimeView()
    private lazy var endTimeView: CustomView = setupEndTimeView()
    private lazy var nameLabel: UILabel = setupLabel()
    private lazy var descriptionLabel: UILabel = setupDescription()
    // MARK: - Properties
    var startDate = Date()
    var endDate = Date()

    // closure for update
    var onSave: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBlurEffect()
        setupLayout()
    }
    
    private func setupBlurEffect() {
          blurEffectView.frame = view.bounds
          blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
          view.addSubview(blurEffectView)
      }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            container.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),

            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            cancelButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 32),
            cancelButton.widthAnchor.constraint(equalToConstant: 32),
            
            blurNameView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 8),
            blurNameView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            blurNameView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
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
            blurDescriptionView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            blurDescriptionView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            blurDescriptionView.heightAnchor.constraint(equalToConstant: 240),
  
            descriptionLabel.topAnchor.constraint(equalTo: blurDescriptionView.topAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: blurDescriptionView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: blurDescriptionView.trailingAnchor, constant: -16),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 32),
      
            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            descriptionTextField.leadingAnchor.constraint(equalTo: blurDescriptionView.leadingAnchor, constant: 16),
            descriptionTextField.trailingAnchor.constraint(equalTo: blurDescriptionView.trailingAnchor, constant: -16),
            descriptionTextField.bottomAnchor.constraint(equalTo: blurDescriptionView.bottomAnchor, constant: -16 ),

            startTimeView.topAnchor.constraint(equalTo: blurDescriptionView.bottomAnchor, constant: 16),
            startTimeView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            startTimeView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            startTimeView.heightAnchor.constraint(equalToConstant: 80),
            
            endTimeView.topAnchor.constraint(equalTo: startTimeView.bottomAnchor, constant: 16),
            endTimeView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            endTimeView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            endTimeView.heightAnchor.constraint(equalToConstant: 80 ),

            saveButton.topAnchor.constraint(equalTo: endTimeView.bottomAnchor, constant: 32),
            saveButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

// MARK: - obj action
private extension AddTaskModalViewController {
    @objc func saveTask() {
        
        if startDate > endDate {
            showAlert(title: "Error", message: "Time start must be earlier than time finish.")
            return
        }
        
        let realm = try! Realm()
        let task = TaskModel()
        task.id = (realm.objects(TaskModel.self).max(ofProperty: "id") ?? 0) + 1
      

        task.dateStart = String(Int(startDate.timeIntervalSince1970))
        task.dateFinish = String(Int(endDate.timeIntervalSince1970))
        task.name = nameTextField.text ?? ""
        task.descriptionText = descriptionTextField.text ?? ""
        try! realm.write {
            realm.add(task)
        }
        onSave?()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Show alert error time
private extension AddTaskModalViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Setup UI
private extension AddTaskModalViewController {
    func setupContainer() -> UIView {
        let container = UIView()
        container.backgroundColor = .clear
        container.layer.cornerRadius = 16
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        return container
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
        blurEffectView.layer.cornerRadius = 8
        blurEffectView.clipsToBounds = true
        button.insertSubview(blurEffectView, at: 0)
        button.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(button)
        return button
    }
    
  func setupCancelButton() -> UIButton {
      let button = UIButton()
      button.setImage(UIImage(systemName: "xmark"), for: .normal)
      button.tintColor = .white
      button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
      button.translatesAutoresizingMaskIntoConstraints = false
      container.addSubview(button)
      return button
    }
    
    func setupNameTextField() -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .lightGray

        blurNameView.addSubview(textField)
        return textField
    }
    
    func setupDescriptionTextView() -> UITextView {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.backgroundColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = true
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        blurDescriptionView.addSubview(textView)
        return textView
    }

    func setupStartDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(datePicker)
        return datePicker
    }
    
    func setupFinishDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(datePicker)
        return datePicker
    }
    
    func setupLabel() -> UILabel {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = .black
        blurNameView.addSubview(label)
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
        container.addSubview(blurView)
        return blurView
    }
    func setupStartTimeView() -> CustomView {
        let view = CustomView(timeLabelType: .dateStart, date: startDate)
        view.onDateChange = { [weak self] newDate in
            self?.startDate = newDate
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    func setupEndTimeView() -> CustomView {
        let view = CustomView(timeLabelType: .dateEnd, date: endDate)
        view.onDateChange = { [weak self] newDate in
            self?.endDate = newDate
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
