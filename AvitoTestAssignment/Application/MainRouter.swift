//
//  MainRouter.swift
//  AvitoTestAssignment
//
//  Created by Yan Sakhnevich on 31.10.2022.
//

import UIKit

protocol MainRouterProtocol {
    var navigationController: UINavigationController! { get }
    var builder: ModuleBuilderProtocol! { get }
    
    init(withBuilder builder: ModuleBuilderProtocol)
}

final class MainRouter: MainRouterProtocol {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController!
    var builder: ModuleBuilderProtocol!
    
    // MARK: - Initial methods
    
    required init(withBuilder builder: ModuleBuilderProtocol) {
        navigationController = builder.createMainModule(withRouter: self) as? UINavigationController
        self.builder = builder
    }
    
}

