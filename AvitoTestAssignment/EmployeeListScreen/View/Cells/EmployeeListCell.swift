//
//  EmployeeListCell.swift
//  AvitoTestAssignment
//
//  Created by Yan Sakhnevich on 28.10.2022.
//

import UIKit

final class EmployeeTableViewCell: UICollectionViewCell {
    
    static var cellIdentifier: String {
        return String(describing: EmployeeTableViewCell.self)
    }

    // MARK: - EmployeeTableViewCell variables and constants
    
    private lazy var employeeAvatarImageView: UIImageView = {
        let avatar = UIImageView()
        avatar.toAutoLayout()
        avatar.image = UIImage.ImageSet.avatar
        return avatar
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont.CustomFonts.large
        return label
    }()
    
    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont.CustomFonts.small
        return label
    }()
    
    private lazy var skillsLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.setContentHuggingPriority(.defaultLow - 1, for: .vertical)
        label.font = UIFont.CustomFonts.small
        return label
    }()
    
    private lazy var wrapperView: UIView = {
        let view = UIView()
        view.toAutoLayout()
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = Constants.borderWidth
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    private lazy var employeeInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.toAutoLayout()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        stackView.distribution = .fillProportionally
 
        return stackView
    }()
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Cell configuration
    
    func configureCellWith(name: String, phoneNumber: String, skills: String) {
        self.nameLabel.text = "Name: \(name)"
        self.phoneNumberLabel.text = "Phone number: \(phoneNumber)"
        self.skillsLabel.text = "Skills: \(skills)"
    }
    
    // MARK: - Setup and configure views
    
    private func setupViews() {
        contentView.backgroundColor = .systemBackground
        setupSubViews()
    }
    
    private func setupSubViews() {
        contentView.addSubview(wrapperView)
        
        let subviewsForStack = [nameLabel,
                                phoneNumberLabel,
                                skillsLabel]
        let subviewsForWrapper = [employeeAvatarImageView,
                                  employeeInfoStackView]
        
        wrapperView.addSubviews(subviewsForWrapper)
        employeeInfoStackView.addSubviewsToStack(subviewsForStack)
        
        NSLayoutConstraint.activate([
            wrapperView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.leftInset),
            wrapperView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topInset),
            wrapperView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: Constants.rightInset),
            wrapperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.bottomInset),
            
            employeeAvatarImageView.leftAnchor.constraint(equalTo: wrapperView.leftAnchor, constant: Constants.leftInset),
            employeeAvatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            employeeAvatarImageView.widthAnchor.constraint(equalToConstant: Constants.avatarImagesize),
            employeeAvatarImageView.heightAnchor.constraint(equalToConstant: Constants.avatarImagesize),
            
            employeeInfoStackView.leftAnchor.constraint(equalTo: employeeAvatarImageView.rightAnchor, constant: Constants.leftInset),
            employeeInfoStackView.rightAnchor.constraint(equalTo: wrapperView.rightAnchor, constant: Constants.rightInset),
            employeeInfoStackView.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            employeeInfoStackView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor)
        ])
    }
    
    // MARK: - Constants for constraints and views

    private enum Constants {
        static let leftInset: CGFloat = 10.0
        static let topInset: CGFloat = 5.0
        static let rightInset: CGFloat = -10.0
        static let bottomInset: CGFloat = -5.0
        static let borderWidth: CGFloat = 0.5
        static let cornerRadius: CGFloat = 10.0
        static let avatarImagesize: CGFloat = 64.0
        static let stackViewSpacing: CGFloat = 3.0
    }
}
