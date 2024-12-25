//
//  CalendarDateCell.swift
//  Dairy
//
//  Created by Alexander Suprun on 11.12.2024.
//
import UIKit

class CalendarCell: UICollectionViewCell {
    static let reuseIdentifier = "CalendarCell"

    private lazy var dateLabel: UILabel = setupDateLabel()
    private lazy var dayLabel: UILabel = setupDayLabel()
    private lazy var separatorView: UIView = setupSeparatorView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(date: Date, isSelected: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        dateLabel.text = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "MMM"
        dayLabel.text = dateFormatter.string(from: date)
        
        setCellAppearance(isSelected: isSelected)
    }
    
    private func setCellAppearance(isSelected: Bool) {
        if isSelected {
            self.separatorView.backgroundColor = .orange
            self.dateLabel.textColor = .white
            self.dayLabel.textColor = .white
              } else {
                  self.separatorView.backgroundColor = .clear
                  self.dateLabel.textColor = .lightGray
                  self.dayLabel.textColor = .lightGray
              }
      }
}
// MARK: - Setup Layout
private extension CalendarCell {
    func setupLayout() {
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            dayLabel.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -8),
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 3),
        ])
       
    }
}


// MARK: - Setup UI
private extension CalendarCell {
    func setupDateLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }
    
    func setupDayLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }
    
    func setupSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
