//
//  EmployeeListModel.swift
//  AvitoTestAssignment
//
//  Created by Yan Sakhnevich on 28.10.2022.
//

import Foundation


public final class EmployeeListFromCache {
    let modelObj: EmployeeList
    let expirationDate: Date
    
    init(Model: EmployeeList, expirationDate: Date) {
        self.modelObj = Model
        self.expirationDate = expirationDate
    }
}

// MARK: - EmployeeList
struct EmployeeList: Decodable{
    let company: Company?
}

// MARK: - Company
struct Company: Decodable {
    let name: String?
    let employees: [Employee]?
}

// MARK: - Employee
struct Employee: Decodable, Hashable {
    let name, phoneNumber: String?
    let skills: [String]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case phoneNumber = "phone_number"
        case skills
    }
}