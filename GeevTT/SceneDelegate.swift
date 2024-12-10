//
//  SceneDelegate.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 10/12/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    let appCoordinator = SwiftUICoordinator()
    //let appCoordinator = UIKitCoordinator()
        
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
                        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = appCoordinator.start()
        window?.makeKeyAndVisible()
    }
}
