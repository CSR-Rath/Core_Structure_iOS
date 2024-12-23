//
//  ConstantsHeight.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/10/24.
//

import Foundation
import UIKit


struct ConstantsHeight{
    
//    SceneDelegate().window?.windowScene?.statusBarManager?.statusBarFrame.height
    private let window = SceneDelegate.shared.sceneDelegate?.window
    static let screen = UIScreen.main.bounds
    static let navigationBarHeight: CGFloat = UINavigationController().navigationBar.frame.height
    static let statusBarHeight =  UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    static let availableHeight: CGFloat = UIScreen.main.bounds.height - navigationBarHeight - statusBarHeight
    
    static let safeAreaTop =  UIViewController().view.safeAreaInsets.top
    static let safeAreaBottom =  UIViewController().view.safeAreaInsets.bottom
    
    
}
