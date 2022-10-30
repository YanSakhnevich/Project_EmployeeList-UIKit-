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
    
    private let decoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    private let cache: CacheResponseProtocol?

    // MARK: - LifeCycle
    init(cache: CacheResponseProtocol?)
    {
        self.cache = cache
    }
    
    convenience init() {
        self.init(
            cache: CacheResponse(memoryCapacity: Constants.allowedMemorySize,
                                 diskCapacity: Constants.allowedDiskSize,
                                 diskPath: Constants.diskPath))
    }
    
    // MARK: - Creating URLSession
    private func createAndRetrieveURLSession() -> URLSession {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForResource = Constants.timeoutTimeInterval
        return URLSession(configuration: sessionConfiguration)
    }

    // MARK: - Fetching employees list
    func fetchEmployeeList() async throws -> [Employee]? {

        let urlString = Constants.withEmployeeListURL
        
        do {
            guard let url = URL(string: urlString)
            else {
                throw ErrorTypes.invalidURL
            }
            
            let urlRequest = URLRequest(url: url)
            
            if let cachedData = cache?.data(forRequest: urlRequest),
               let employeeListFromCache = try decode(data: cachedData) {
                employeeList = employeeListFromCache
                return employeeList
            }
            
            let (data, response) = try await createAndRetrieveURLSession().asyncData(from: urlRequest)
            
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
            
            self.cache?.insert(data,
                               forRequest: urlRequest,
                               withResponse: response,
                               lifetime: Constants.cacheStorageTimeInterval)
            
            guard let decodedData = try? self.decode(data: data)
            else {
                throw  ErrorTypes.invalidData
            }
            employeeList = decodedData
            
            return employeeList
            
        } catch {
            print(error.localizedDescription)
        }
        return employeeList
    }
    
    private func decode(data: Data) throws -> [Employee]? {
        do {
            let companyResult = try decoder.decode(EmployeeList.self, from: data)
            return companyResult.company?.employees
        } catch {
            return nil
        }
    }
}

// MARK: - URL for fetchEmployeeList method
fileprivate struct Constants {
    static let timeoutTimeInterval: TimeInterval = 7
    static let withEmployeeListURL = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
    static let diskPath = "companyFetcherCache"
    static let allowedMemorySize = 10 * 1024 * 1024 // 10 Mb
    static let allowedDiskSize = 10 * 1024 * 1024 // 10 Mb
    static let cacheStorageTimeInterval: Double = 60 * 60 // 1 hour
}
