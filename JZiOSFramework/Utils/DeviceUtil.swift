//
//  DeviceUtil.swift
//  JZiOSFramework
//
//  Created by Jeff Zhang on 13/3/18.
//  Copyright © 2018 Jeff Zhang. All rights reserved.
//

import Foundation
import LocalAuthentication

//iPhone X Support
open class DeviceUtil {
    
    public static let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    public static let navigationBarHeight: CGFloat = UINavigationController().navigationBar.frame.height
    public static let naviAndStatusBarHeight: CGFloat = statusBarHeight + navigationBarHeight
    //Not include the iPhone X bottom gesture bar
    public static let tabBarHeight: CGFloat = UITabBarController().tabBar.frame.height
    
    //Will changed when device rotate or iPad Split View
    public static var currentScreenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public static var currentScreenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    //Fixed value
    public static var screenWidth: CGFloat = UIScreen.main.nativeBounds.width / UIScreen.main.nativeScale
    public static var screenHeight: CGFloat = UIScreen.main.nativeBounds.height / UIScreen.main.nativeScale
    
    public static let isIPhoneX: Bool = UIDevice.current.userInterfaceIdiom == .phone && screenHeight == 812
    public static let isIPhoneSEOrSmaller: Bool = screenWidth <= 320
    public static let isIPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    
    //Example: lblTitle.centerYAnchor.constraint(equalTo: naviView.centerYAnchor, constant: centerYOffset).isActive = true
    public static let centerYOffsetForContentInNaviBar: CGFloat = statusBarHeight/2 - 8
    
    
    //MARK: - Biometric Authentication
    public enum BiometryType: String {
        case none = "None"
        case touchID = "Touch ID"
        case faceID = "Face ID"
    }
    
    public static func getSupportBiometryType() -> BiometryType {
        
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Login"
        var authError: NSError?
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            if #available(iOS 11.0, *) {
                if localAuthenticationContext.biometryType == .touchID {
                    return .touchID
                } else if localAuthenticationContext.biometryType == .faceID {
                    return .faceID
                } else {
                    return .none
                }
            } else {
                return .touchID
            }
        } else {
            return .none
        }
    }
    
    public static func setupBiometricAuthentication(successAction: @escaping () -> Void, fallbackAction: @escaping () -> Void) {
        
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Password"
        var authError: NSError?
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Login") { success, error in
                if success {
                    DispatchQueue.main.async {
                        //Login Function
                        successAction()
                    }
                } else {
                    let laError = error as! LAError
                    
                    switch laError.code {
                    case .authenticationFailed:
                        break
                    case .userCancel:
                        break
                    //Fail two times, allow users to login with password
                    case .userFallback:
                        DispatchQueue.main.async {
                            //Another way to login
                            fallbackAction()
                        }
                        break
                    case .touchIDNotAvailable:
                        //Face Id Click not allow TODO: Jump to app setting
                        DispatchQueue.main.async {
                            AlertUtil.presentNoFunctionAlertController(message: "Enable Face ID to login")
                        }
                    default:
                        print(laError.code.rawValue)
                    }
                }
            }
        } else {
            //Device not capable scenario //Biometry locked out or not available
            AlertUtil.presentNoFunctionAlertController(message: authError!.localizedDescription)
        }
    }
    
}
