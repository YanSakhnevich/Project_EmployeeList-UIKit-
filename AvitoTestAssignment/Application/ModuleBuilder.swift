//
//  EmployeeListBuilder.swift
//  AvitoTestAssignment
//
//  Created by Yan Sakhnevich on 28.10.2022.
//

import UIKit

protocol Builder {
    static func createMainModule() -> UIViewController
}

final class ModuleBuilder: Builder {
    static func createMainModule() -> UIViewController {
        let networkService = NetworkService()
        let view = EmployeesListViewController()
        let presenter = EmployeeListPresenter(view: view, networkService: networkService)
        view.presenter = presenter
        return view
    }
}
