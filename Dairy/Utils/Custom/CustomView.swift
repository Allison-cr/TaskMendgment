//
//  CustomButton.swift
//  Dairy
//
//  Created by Alexander Suprun on 24.12.2024.
//

import Foundation
import UIKit

final class CustomView: UIView {
    private let timeLabelType: TimeLabelType
    private let date: Date
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    var onDateChange: ((Date) -> Void)?
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    init(timeLabelType: TimeLabelType, date: Date) {
        self.timeLabelType = timeLabelType
        self.date = date
        super.init(frame: .zero)
        setupBlurEffect()
        setupLayout()
        setupDatePicker()
    }
    
    private func setupBlurEffect() {
          blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
          addSubview(blurEffectView)
      }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = timeLabelType.returnText()
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        datePicker.date = date
        addSubview(datePicker)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            datePicker.bottomAnchor.constraint(equalTo: bottomAnchor , constant: -8),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}

private extension CustomView {
    private func setupDatePicker() {
         datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
     }
     
     @objc private func dateChanged(_ sender: UIDatePicker) {
         onDateChange?(sender.date)
     }
}
