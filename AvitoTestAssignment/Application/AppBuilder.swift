//
//  AppBuilder.swift
//  AvitoTestAssignment
//
//  Created by Yan Sakhnevich on 31.10.2022.
//

import UIKit

protocol AppBuilderProtocol {
    static func createMainModule() -> UIViewController
}

struct AppBuilder: AppBuilderProtocol {
    
    public static func createMainModule() -> UIViewController {
        let builder = ModuleBuilder()
        let router = MainRouter(withBuilder: builder)
        
        return router.navigationController
    }
    
}
