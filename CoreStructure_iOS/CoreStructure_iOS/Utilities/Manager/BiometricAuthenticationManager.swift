//
//  BiometricAuthenticationManager.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import LocalAuthentication

import LocalAuthentication

enum DataFingerIDFaceIdResult {
    case success(status: Bool)
    case failure(String)
    case unavailable(Int)
}

class BiometricAuthenticationManager {
    static let shared = BiometricAuthenticationManager()
    private var context: LAContext?
    
    func fingerPrintFaceID(_ status: @escaping (DataFingerIDFaceIdResult) -> Void) {
        context = LAContext()
        context?.localizedFallbackTitle = "Please use your Passcode"
        
        var error: NSError?
        if context?.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) == true {
            context?.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Access requires authentication") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        status(.success(status: success))
                    } else {
                        if let error = authenticationError as NSError? {
                            status(.failure(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code)))
                        }
                    }
                }
            }
        } else {
            status(.unavailable(error?.code ?? -1))
        }
    }
    
    private func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        switch errorCode {
        case LAError.biometryNotAvailable.rawValue:
            return "Authentication could not start because the device does not support biometric authentication."
        case LAError.biometryLockout.rawValue:
            return "User is locked out of biometric authentication."
        case LAError.biometryNotEnrolled.rawValue:
            return "User has not enrolled in biometric authentication."
        default:
            return "Did not find error code on LAError object"
        }
    }
    
    private func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        switch errorCode {
        case LAError.authenticationFailed.rawValue:
            return "The user failed to provide valid credentials."
        case LAError.appCancel.rawValue:
            return "Authentication was cancelled by the application."
        case LAError.invalidContext.rawValue:
            return "The context is invalid."
        case LAError.notInteractive.rawValue:
            return "Not interactive."
        case LAError.passcodeNotSet.rawValue:
            return "Passcode is not set on the device."
        case LAError.systemCancel.rawValue:
            return "Authentication was cancelled by the system."
        case LAError.userCancel.rawValue:
            return "The user did cancel."
        case LAError.userFallback.rawValue:
            return "The user chose to use the fallback (Enter Password)."
        default:
            return evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
    }
}

// How to use it. Example:
func helper() {
    BiometricAuthenticationManager.shared.fingerPrintFaceID { result in
        switch result {
        case .success(let status):
            
            print("Authentication successful: \(status)")
        case .failure(let message):
            
            print("Authentication failed: \(message)")
        case .unavailable(let errorCode):
            
            print("Biometric authentication not available, error code: \(errorCode)")
        }
    }
}
