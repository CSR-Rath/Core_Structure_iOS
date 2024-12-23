//
//  TransactionTypesEnum.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 19/12/24.
//

import Foundation

//MARK: - For noti fication
enum TransactionTypesEnum: String{
    case transfer   = "TRANSFER"
    case expired    = "EXPIRED"
    case receive    = "RECEIVE"
}

//MARK: - For screen success
enum SuccessTypeEnum{
    case isFromLogin
    case isFromPayment
    case isFromTransfer
}

//MARK: - For passcode screen
enum PassCodeTypeEnum{
    case isLoginScreen
    case isChangePasscodeScreen
    case isForgotPasscodeScreen
    case isConfirmPasscodeScreen
}
