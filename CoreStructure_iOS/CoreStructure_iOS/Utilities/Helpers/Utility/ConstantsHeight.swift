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
    
    static let screen = UIScreen.main.bounds.height
    static let navigationBarHeight: CGFloat = UINavigationController().navigationBar.frame.height
    static let statusBarHeight =  UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    static let availableHeight: CGFloat = UIScreen.main.bounds.height - navigationBarHeight - statusBarHeight
    
}
