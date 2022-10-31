//
//  CacheResponseFromURL.swift
//  AvitoTestAssignment
//
//  Created by Yan Sakhnevich on 30.10.2022.
//


import Foundation

protocol CacheResponseProtocol {
    func insert(_ data: Data, forRequest request: URLRequest, withResponse response: URLResponse, lifetime: TimeInterval?)
    func removeData(forRequest request: URLRequest)
    func data(forRequest request: URLRequest) -> Data?
}


final class CacheResponse: CacheResponseProtocol {
    
    // MARK: - CacheResponse variables and constants

    private let cache: URLCache
    
    // MARK: - Life cycle

    init(memoryCapacity: Int, diskCapacity: Int, diskPath: String) {
        cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: diskPath)
    }
    
    // MARK: - CacheResponseProtocol methods
    
    func insert(_ data: Data, forRequest request: URLRequest, withResponse response: URLResponse, lifetime: TimeInterval?) {
        let cachedData = CachedURLResponse(response: response, data: data)
        cache.storeCachedResponse(cachedData, for: request)
        if let lifetime {
            saveExpiryDate(Date().addingTimeInterval(lifetime), forRequest: request)
        } else {
            saveExpiryDate(nil, forRequest: request)
        }
    }
    
    func removeData(forRequest request: URLRequest) {
        cache.removeCachedResponse(for: request)
        saveExpiryDate(nil, forRequest: request)
    }
    
    func data(forRequest request: URLRequest) -> Data? {
        if isDataExpired(forRequest: request) {
            return nil
        }
        return cacheData(forRequest: request)
    }
    
    private func cacheData(forRequest request: URLRequest) -> Data? {
        cache.cachedResponse(for: request)?.data
    }
    
    // MARK: - Constants
    
    private enum Constants {
        static let keyPostfix = "urlCacheExpiry"
    }
    
}

// MARK: - Cache values expiry handling

private extension CacheResponse {
    func isDataExpired(forRequest request: URLRequest) -> Bool {
        if let expiryDate = expiryDate(forRequest: request) {
            if Date() < expiryDate {
                return false
            }
            removeData(forRequest: request)
            return true
        }
        return false
    }
    
    func expiryDateDefaultsKey(forRequest request: URLRequest) -> String {
        "\(request.hashValue)\(Constants.keyPostfix)"
    }
    
    func expiryDate(forRequest request: URLRequest) -> Date? {
        UserDefaults.standard.value(forKey: expiryDateDefaultsKey(forRequest: request)) as? Date
    }
    
    func saveExpiryDate(_ expiryDate: Date?, forRequest request: URLRequest) {
        UserDefaults.standard.set(expiryDate, forKey: expiryDateDefaultsKey(forRequest: request))
    }
}
