//
//  SceneDelegate.swift
//  GeevTT
//
//  Created by Pascal Costa-Cunha on 10/12/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene, willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let coordKey = "uikit_coordinator"
        let isUIKit = UserDefaults.standard.bool(forKey: coordKey)
        let appCoordinator =
            isUIKit
            ? UIKitCoordinator() as AppCoordinator
            : SwiftUICoordinator() as AppCoordinator
        print(appCoordinator)
        UserDefaults.standard.set(!isUIKit, forKey: coordKey)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = appCoordinator.start()
        window?.makeKeyAndVisible()
    }
}
