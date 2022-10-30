//
//  ErrorTypes.swift
//  AvitoTestAssignment
//
//  Created by Yan Sakhnevich on 28.10.2022.
//

import Foundation

enum ErrorTypes: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidEmployeeData
    case noInternetConnection
    case timeout
    case networkError
}
