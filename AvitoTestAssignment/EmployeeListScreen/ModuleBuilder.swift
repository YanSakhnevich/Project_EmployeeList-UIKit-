//
//  EmployeeListBuilder.swift
//  AvitoTestAssignment
//
//  Created by Yan Sakhnevich on 28.10.2022.
//

import UIKit

protocol ModuleBuilderProtocol {
    func createMainModule(withRouter router: MainRouterProtocol) -> UIViewController
}

struct ModuleBuilder: ModuleBuilderProtocol {
    
    public func createMainModule(withRouter router: MainRouterProtocol) -> UIViewController {
        let networkService = NetworkService()
        let viewController = EmployeesListViewController()
        let presenter = EmployeeListPresenter(view: viewController,
                                              networkService: networkService)
        viewController.presenter = presenter
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.backgroundColor = .systemBackground
        
        return navigationController
    }
    
}
