//
//  TaskCell.swift
//  Dairy
//
//  Created by Alexander Suprun on 13.12.2024.
//

import Foundation
import UIKit

class TaskCell: UICollectionViewCell {
    static let reuseIdentifier = "TaskCell"

    private lazy var taskLabel: UILabel = setupTaskLabel()
    private lazy var descriptionLabel: UILabel = setupDescriptionLabel()
    private lazy var dateLabel: UILabel = setupDateLabel()
    private lazy var buttonSetting: UIButton = setupButtonSetting()
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBlurEffect()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBlurEffect() {
        blurEffectView.frame = contentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(blurEffectView)
    }

    func configure(task: TaskModel) {
        print(task)
        taskLabel.text = task.name
        descriptionLabel.text = task.descriptionText
        dateLabel.text = "\(task.formattedStartDate ?? "") - \(task.formattedFinishDate ?? "")"
    }
}

private extension TaskCell {
    func setupLayout() {
        NSLayoutConstraint.activate([
            taskLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            taskLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            taskLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            buttonSetting.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            buttonSetting.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
       
            
            descriptionLabel.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }

    func setupTaskLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }
    
    func setupDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }

    func setupDateLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }
    
    func setupButtonSetting() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        return button
    }
}
