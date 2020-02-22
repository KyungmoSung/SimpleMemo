//
//  AppDelegate.swift
//  SimpleMemo
//
//  Created by Kyungmo on 2020/02/15.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // 네비게이션 뒤로가기 버튼 커스텀
    if let navigationController = UIApplication.shared.windows.first!.rootViewController as? UINavigationController {
      let backButtonImage = UIImage(named: "icBack")
      navigationController.navigationBar.backIndicatorImage = backButtonImage
      navigationController.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
      navigationController.navigationBar.tintColor = .smBarButtonItemTint
      UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
    }

    return true
  }
}
