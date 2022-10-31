//
//  SceneDelegate.swift
//  AvitoTestAssignment
//
//  Created by Yan Sakhnevich on 28.10.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let mainViewController = AppBuilder.createMainModule()
        window.rootViewController = mainViewController
        self.window = window
        window.makeKeyAndVisible()

    }
}
