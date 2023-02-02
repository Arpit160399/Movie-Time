//
//  SceneDelegate.swift
//  Movie Time
//
//  Created by Arpit Singh on 27/01/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var contianer = MainAppDependencyContainer()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
   
        if let value = ProcessInfo.processInfo.environment["-UITest"],
           let screen = UITesting(rawValue: value) {
            window?.rootViewController = screen.controller
        } else {
            window?.rootViewController = contianer.makeMainViewController()
        }
        window?.makeKeyAndVisible()
    }

}

