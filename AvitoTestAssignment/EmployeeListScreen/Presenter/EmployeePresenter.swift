//
//  EmployeePresenter.swift
//  AvitoTestAssignment
//
//  Created by Yan Sakhnevich on 28.10.2022.
//

import Foundation

// MARK: - Protocol for EmployeeListViewController

protocol EmployeeListProtocol: AnyObject {
    func succes()
    func failure(error: ErrorTypes)
}

// MARK: - Protocol for EmployeeListPresenter

protocol EmployeeListPresenterProtocol {
    init(view: EmployeeListProtocol, networkService: NetworkServiceProtocol)
    func getEmployees()
    var employees: [Employee]? { get set }
}

final class EmployeeListPresenter: EmployeeListPresenterProtocol {
    
    // MARK: - EmployeeListPresenter variables and constants
    
    weak var view: EmployeeListProtocol?
    let networkService: NetworkServiceProtocol?
    var employees: [Employee]?
    
    // MARK: - Life cycle
    
    required init(view: EmployeeListProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }

    // MARK: - Fetching employees list
    
    func getEmployees()  {
        Task(priority: .userInitiated) { [weak self] in
            do {
                self?.employees = try await networkService?.fetchEmployeeList()?.sorted { $0.name ?? "" < $1.name ?? "" } ?? []
                self?.view?.succes()
            }
            catch {
                self?.view?.failure(error: .invalidEmployeeData)
            }
        }
    }
}
