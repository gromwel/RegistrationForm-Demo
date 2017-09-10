//
//  TFValidation.h
//  RegistrationForm
//
//  Created by Clyde Barrow on 10.07.17.
//  Copyright © 2017 Pavel Podgornov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TFValidation : NSString

//методы проверки на правила составления строки во время ввода
+ (BOOL) checkName : (UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
+ (BOOL) checkMobileNumber : (UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
+ (BOOL) checkEMail : (UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

//методы проверки строки после заполнения
+ (BOOL) isReturnName : (UITextField *)textField;
+ (BOOL) isReturnPhoneNumber : (UITextField *) textField;
+ (BOOL) isReturnEMail : (UITextField *) textField;
+ (BOOL) isReturnNotEmpty:(UITextField *) textField;

//методы проверки строки после заполнения с выводом ошибки
+ (BOOL) isReturnName : (UITextField *)textField  ErrorLabel:(UILabel *) label;
+ (BOOL) isReturnPhoneNumber : (UITextField *) textField ErrorLabel:(UILabel *) label;
+ (BOOL) isReturnEMail : (UITextField *) textField ErrorLabel:(UILabel *) label;
+ (BOOL) isReturnNotEmpty:(UITextField *) textField ErrorLabel:(UILabel *) label;

@end
