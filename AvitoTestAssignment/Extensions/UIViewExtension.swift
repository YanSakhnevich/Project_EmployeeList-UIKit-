//
//  UIViewExtension.swift
//  AvitoTestAssignment
//
//  Created by Yan Sakhnevich on 28.10.2022.
//

import UIKit

// MARK: - UIView Extension
extension UIView {
    func toAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach{ addSubview($0) }
    }
}

// MARK: - StackView Extension
extension UIStackView {
    func addSubviewsToStack(_ views: [UIView]) {
        views.forEach{ addArrangedSubview($0) }
    }
}
