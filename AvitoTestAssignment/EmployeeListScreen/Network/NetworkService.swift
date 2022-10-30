//
//  NetworkService.swift
//  AvitoTestAssignment
//
//  Created by Yan Sakhnevich on 28.10.2022.
//

import Foundation


// MARK: - EmployeeListAPIResponse
typealias EmployeeListAPIResponse = (Result<[Employee]?, ErrorTypes>) -> Void

// MARK: - NetworkServiceProtocol
protocol NetworkServiceProtocol {
    func fetchEmployeeList() async throws -> [Employee]?
    var employeeList: [Employee]? { get set }
}

final class NetworkService: NetworkServiceProtocol {
    
    // MARK: - NetworkService variables and constants
    var employeeList: [Employee]?
    private let urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = Constants.timeoutTimeInterval
        let session = URLSession(configuration: configuration)
        return session
    }()
    

    
    
    
    // MARK: - Fetching employees list
    func fetchEmployeeList() async throws -> [Employee]? {
        
        let urlString = Constants.withEmployeeListURL
        
        do {
            guard let url = URL(string: urlString)
            else {
                throw ErrorTypes.invalidURL
            }
            let (data, response) = try await urlSession.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse
            else {
                throw ErrorTypes.invalidResponse
            }
            guard (200...299).contains(httpResponse.statusCode)
            else {
                if httpResponse.statusCode == -1009 {
                    throw ErrorTypes.noInternetConnection
                }
                if httpResponse.statusCode == -1001 {
                    throw ErrorTypes.timeout
                }
                throw ErrorTypes.networkError
            }
            
            guard let decodedData = try? JSONDecoder().decode(EmployeeList.self, from: data)
            else {
                throw  ErrorTypes.invalidData
            }
            employeeList = decodedData.company?.employees
            return employeeList
        } catch {
            print(error.localizedDescription)
        }
        return employeeList
    }
}

// MARK: - URL for fetchEmployeeList method
fileprivate struct Constants {
    static let timeoutTimeInterval: TimeInterval = 7
    static let withEmployeeListURL = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
}
