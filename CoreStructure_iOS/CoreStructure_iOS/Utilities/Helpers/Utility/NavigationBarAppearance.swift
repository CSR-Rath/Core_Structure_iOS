//
//  NavigationBarAppearance.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 9/4/25.
//

import Foundation
import UIKit

class NavigationBarAppearance{
    
    static let shared = NavigationBarAppearance()
    
    func navigationBarAppearance(titleColor: UIColor, barAppearanceColor: UIColor, shadowColor: UIColor){
        
        let font: UIFont = UIFont.systemFont(ofSize: 16,weight: .bold)
        let largeFont: UIFont = UIFont.systemFont(ofSize: 34,weight: .bold)
        
        let appearance = UINavigationBarAppearance()
        
        appearance.titleTextAttributes = [
            .foregroundColor: titleColor,
            .font: font
        ]
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor: titleColor,
            .font: largeFont
        ]
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = barAppearanceColor
        
        appearance.shadowColor = shadowColor // line navigation bar color

        UINavigationBar.appearance().standardAppearance = appearance // when isn't scroll
        UINavigationBar.appearance().scrollEdgeAppearance = appearance // when scroll color
        
    }
    
}
