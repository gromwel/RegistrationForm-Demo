//
//  TFValidation.m
//  RegistrationForm
//
//  Created by Clyde Barrow on 10.07.17.
//  Copyright © 2017 Pavel Podgornov. All rights reserved.
//

#import "TFValidation.h"
#import "RFAnimation.h"


@implementation TFValidation

#pragma mark - Validation Input Function

//метод проверки ввода телефона
+ (BOOL) checkMobileNumber : (UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //проверка на символы ввода
    NSCharacterSet * validationSet = [[NSCharacterSet characterSetWithCharactersInString:@"+1234567890"] invertedSet];
    NSArray * validationArray = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if (validationArray.count > 1) {
        return NO;
    }
    
    //проверка на ввод плюса только в самом начале
    if ([string isEqualToString:@"+"] & (range.location != 0)) {
        return NO;
    }
    
    NSCharacterSet * clearSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray * clearArray = [textField.text componentsSeparatedByCharactersInSet:clearSet];
    NSString * clearString = [clearArray componentsJoinedByString:@""];
    
    NSInteger locationShift = textField.text.length - clearString.length;
    NSRange clearRange = NSMakeRange(range.location - locationShift, range.length);
    
    //делаем то что делает этот метод, но до того как он это сделает, добавляем/удаляем символы
    NSString * resultString = [clearString stringByReplacingCharactersInRange:clearRange withString:string];
    
    //если длинна строки больше положеной
    if (resultString.length > 11) {
        return NO;
    }
    
    
    //форматирование строки
    
    static const int codeOperatorMaxLength = 3;
    static const int codeCountryLength = 1;
    static const int numberFirstPartMaxLength = 3;
    static const int numberSecondPartMaxLength = 2;
    static const int numberThirdPartMaxLength = 2;
    
    NSMutableString * finalString = [NSMutableString string];
    
    //код страны
    //если есть хотя бы одиин символ
    if (resultString.length > 0) {
        
        //берем первый символ
        NSRange range = NSMakeRange(0, 1);
        NSString * number = [resultString substringWithRange:range];
        
        //проверяем на код страны
        NSCharacterSet * countryCodeSet = [NSCharacterSet characterSetWithCharactersInString:@"+789"];
        NSArray * countryCodeArray = [number componentsSeparatedByCharactersInSet:countryCodeSet];
        
        //если это код страны
        if ((countryCodeArray.count > 1) & [number isEqualToString:@"9"]) {
            
            //добавляем вместо кода +7 9
            NSRange characterRange = NSMakeRange(0, 0);
            [finalString replaceCharactersInRange:characterRange withString:@"+7 (9)"];
            
        } else if (countryCodeArray.count > 1) {
            
            //добавляем +7
            NSRange characterRange = NSMakeRange(0, 0);
            [finalString replaceCharactersInRange:characterRange withString:@"+7"];
            
        } else {
            
            //иначе просто добавляем эту цифру
            NSRange characterRange = NSMakeRange(0, 0);
            [finalString replaceCharactersInRange:characterRange withString:number];
            
        }
    }
    
    
    //если больше одного символа
    if (resultString.length > codeCountryLength) {
        
        NSInteger codeOperatorLength = MIN(codeOperatorMaxLength, resultString.length - codeCountryLength);
        
        
        NSString * number = [resultString substringWithRange:NSMakeRange(codeCountryLength, codeOperatorLength)];
        
        //проверка на правильное написание кода страны и кода оператора
        NSString * nineValidation = [resultString substringWithRange:NSMakeRange(1, 1)];
        BOOL isNine = [nineValidation isEqualToString:@"9"];
        NSString * sevenValidation = [resultString substringWithRange:NSMakeRange(0, 1)];
        BOOL isSeven = [sevenValidation isEqualToString:@"7"];
        
        if (isNine & isSeven) {
            number = [NSString stringWithFormat:@" (%@)", number];
        }
        
        [finalString appendString:number];
    }
    
    
    //если символов больше 4 (код страны плюс код оператоора)
    if (resultString.length > codeCountryLength + codeOperatorMaxLength) {
        
        NSInteger numberFirstPartLength = MIN(numberFirstPartMaxLength, resultString.length - codeCountryLength - codeOperatorMaxLength);
        
        NSString * number = [resultString substringWithRange:NSMakeRange(codeCountryLength + codeOperatorMaxLength, numberFirstPartLength)];
        
        NSString * sevenValidation = [resultString substringWithRange:NSMakeRange(0, 1)];
        BOOL isSeven = [sevenValidation isEqualToString:@"7"];
        NSString * nineValidation = [resultString substringWithRange:NSMakeRange(1, 1)];
        BOOL isNine = [nineValidation isEqualToString:@"9"];
        
        if (isSeven & isNine) {
            number = [NSString stringWithFormat:@" %@", number];
        }
        
        [finalString appendString:number];
    }
    
    
    //если символов больше чем 7 (код страны плюс код оператора плюс первая часть номера)
    if (resultString.length > codeCountryLength + codeOperatorMaxLength + numberFirstPartMaxLength) {
        
        NSInteger numberSecondPartLength = MIN(numberSecondPartMaxLength,
                                               resultString.length - codeCountryLength - codeOperatorMaxLength - numberFirstPartMaxLength);
        
        NSString * number = [resultString substringWithRange:NSMakeRange(codeCountryLength + codeOperatorMaxLength + numberFirstPartMaxLength,
                                                                         numberSecondPartLength)];
        
        NSString * sevenValidation = [resultString substringWithRange:NSMakeRange(0, 1)];
        BOOL isSeven = [sevenValidation isEqualToString:@"7"];
        NSString * nineValidation = [resultString substringWithRange:NSMakeRange(1, 1)];
        BOOL isNine = [nineValidation isEqualToString:@"9"];
        
        if (isSeven & isNine) {
            number = [NSString stringWithFormat:@"-%@", number];
        }
        
        [finalString appendString:number];
    }
    
    
    //если символов больше чем 9 (код старны плюс код оператора плюс первая часть номера плюс вторая часть номера
    if (resultString.length > codeCountryLength + codeOperatorMaxLength + numberFirstPartMaxLength + numberSecondPartMaxLength) {
        
        NSInteger numberThirdPartLength = MIN(numberThirdPartMaxLength,
                                              resultString.length - codeCountryLength - codeOperatorMaxLength - numberFirstPartMaxLength - numberSecondPartMaxLength);
        
        NSString * number = [resultString substringWithRange:NSMakeRange(codeCountryLength + codeOperatorMaxLength + numberFirstPartMaxLength +numberSecondPartMaxLength,
                                                                         numberThirdPartLength)];
        
        NSString * sevenValidation = [resultString substringWithRange:NSMakeRange(0, 1)];
        BOOL isSeven = [sevenValidation isEqualToString:@"7"];
        NSString * nineValidation = [resultString substringWithRange:NSMakeRange(1, 1)];
        BOOL isNine = [nineValidation isEqualToString:@"9"];
        
        if (isSeven & isNine) {
            number = [NSString stringWithFormat:@"-%@", number];
        }
        
        [finalString appendString:number];
    }
    
    textField.text = finalString;
    
    return NO;
}


//метод проверки email
+ (BOOL) checkEMail : (UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //сет из английский стройных букв и цифр и символов
    NSMutableCharacterSet * validationSet = [NSMutableCharacterSet decimalDigitCharacterSet];
    //[validationSet formUnionWithCharacterSet:[NSCharacterSet letterCharacterSet]];
    [validationSet addCharactersInString:@"qwertyuiopasdfghjklzxcvbnm"];
    [validationSet addCharactersInString:@"!#$%&'*+-/=?^_{|}~`.@"];
    [validationSet invert];
    
    //проверка на эти символы, если не они, то нет
    NSArray * validationArray = [string componentsSeparatedByCharactersInSet:validationSet];
    if (validationArray.count > 1) {
        return NO;
    }
    
    //проверка на две точки подряд
    if ([string isEqualToString:@"."] & [textField.text hasSuffix:@"."]) {
        return NO;
    }

    
    
    NSInteger lenght = 30;
    
    //сама операция метода
    NSString * resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //проверка на вторую собаку
    NSArray * atArray = [resultString componentsSeparatedByString:@"@"];
    if (atArray.count > 2) {
        return NO;
    }
    
    //проверка на длинну имени
    if ((resultString.length > lenght) & (atArray.count == 1)) {
        return NO;
    }
    
    //проверка на длинну хоста
    if (atArray.count > 1) {
        NSString * hostString = (NSString *)[atArray objectAtIndex:1];
        NSArray * validationArray = [hostString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"!#$%&'*+/=?^_{|}~`@"]];
        
        if (validationArray.count > 1) {
            return NO;
        }
        
        
        NSArray * hostArray = [hostString componentsSeparatedByString:@"."];
        
        //длинна после собаки до точки
        if ((hostString.length > lenght) & (hostArray.count == 1)) {
            return NO;
        }
        
        NSRange dotRange = [hostString rangeOfString:@"." options: NSBackwardsSearch];
        //длинна после собаки и точки до конца
        if (dotRange.location == NSNotFound) {
            
        } else if ((hostString.length - dotRange.location - 1) > 6) {
            return NO;
            
        } else if ((hostArray.count > 2) & [string isEqualToString:@"."]) {
            return NO;
        }
    }
    
    
    //проверка на точку в имени хоста не раньше чем через две буквы
    if ((atArray.count > 1) & [string isEqualToString:@"."]) {
        
        NSString * hostString = (NSString *)[atArray objectAtIndex:1];
        NSRange dotRange = [hostString rangeOfString:@"."];
        if (dotRange.location < 2) {
            return NO;
        }
    }
    
    textField.text = resultString;
    
    return NO;
}


//метод проверки ввода имени
+ (BOOL) checkName : (UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //допустимая длинна имени
    NSString * newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newString.length > 20) {
        return NO;
    }
    
    //сет допустимых символов
    NSMutableCharacterSet * validationName = [NSMutableCharacterSet letterCharacterSet];
    [validationName addCharactersInString:@"-"];
    [validationName invert];
    NSArray * arrayName = [string componentsSeparatedByCharactersInSet:validationName];
    NSArray * arrayDash = [textField.text componentsSeparatedByString:@"-"];
    
    //проверка на второое тире
    if ([string isEqualToString:@"-"] & (arrayDash.count > 1)) {
        return NO;
    }
    
    //проверка на сет
    if (arrayName.count > 1) {
        return NO;
    }
    
    return YES;
}



#pragma mark - Validation Return Function

//проверка имени
+ (BOOL) isReturnName : (UITextField *)textField {
    BOOL isName = YES;
    
    
    if (textField.text.length < 2) {
        isName = NO;
    }
    
    return isName;
}


//проверка номера телефона
+ (BOOL) isReturnPhoneNumber : (UITextField *) textField {
    BOOL isPhoneNumber = YES;
    
    if (textField.text.length != 18) {
        isPhoneNumber = NO;
    }
    
    return isPhoneNumber;
}


//проверка имейла
+ (BOOL) isReturnEMail : (UITextField *) textField {
    BOOL isEMail = YES;
    
    //проверка на пустую строку
    if (textField.text.length == 0) {
        isEMail = NO;
    }
    
    //проверка на собаку
    NSArray * atArray = [textField.text componentsSeparatedByString:@"@"];
    if (atArray.count <= 1) {
        isEMail = NO;

    }
    
    //проверка на точку после собаки хост нейм
    if (atArray.count > 1) {
        NSString * hostString = (NSString *)[atArray objectAtIndex:1];
        NSRange dotRange = [hostString rangeOfString:@"."];
        
        
        if (dotRange.location == NSNotFound) {
            isEMail = NO;

        } else if ((hostString.length - dotRange.location - 1) < 2) {
            isEMail = NO;

        } else if ((hostString.length - dotRange.location - 1) > 2) {
            NSArray * domainArray = [NSArray arrayWithObjects:@".aero", @".arpa", @".asia", @".biz", @".cat",
                                     @".com", @".coop", @".edu", @".gov", @".info",
                                     @".int", @".jobs", @".mil", @".mobi", @".museum",
                                     @".name", @".net", @".org", @".post", @".pro",
                                     @".tel", @".travel", @".xxx", nil];
            
            NSString * domainString = [hostString substringFromIndex:dotRange.location];
            if (![domainArray containsObject:domainString]) {
                isEMail = NO;

            }
        }
    }
    
    return isEMail;
}

//проверка поля на пустоту
+ (BOOL) isReturnNotEmpty:(UITextField *) textField {
    
    /*
    BOOL isNotEmpty = NO;
    
    if (textField.text.length > 0) {
        isNotEmpty = YES;
    }
    
    return isNotEmpty;
    */
    
    
    BOOL isNotEmpty = (textField.text.length > 0);
    
    return isNotEmpty;
     
}



#pragma mark - Validation Return Function Show Error

//проверка имени
+ (BOOL) isReturnName : (UITextField *)textField  ErrorLabel:(UILabel *) label {
    BOOL isName = YES;
    
    
    
    if (textField.text.length < 2) {
        isName = NO;
        [RFAnimation animationErrorTextShow:label Message:@"Нет таких коротких имен"];
    }
    
    
    return isName;
}


//проверка номера телефона
+ (BOOL) isReturnPhoneNumber : (UITextField *) textField ErrorLabel:(UILabel *) label{
    BOOL isPhoneNumber = YES;
    
    if (textField.text.length != 18) {
        isPhoneNumber = NO;
        [RFAnimation animationErrorTextShow:label Message:@"Похоже это не мобильный номер"];
    }
    
    return isPhoneNumber;
}


//проверка имейла
+ (BOOL) isReturnEMail : (UITextField *) textField ErrorLabel:(UILabel *) label{
    BOOL isEMail = YES;
    
    //проверка на пустую строку
    if (textField.text.length == 0) {
        isEMail = NO;
        [RFAnimation animationErrorTextShow:label Message:@"Укажите почту"];
    }
    
    //проверка на собаку
    NSArray * atArray = [textField.text componentsSeparatedByString:@"@"];
    if (atArray.count <= 1) {
        isEMail = NO;
        [RFAnimation animationErrorTextShow:label Message:@"Похоже, вы забыли собаку"];
        
    }
    
    //проверка на точку после собаки хост нейм
    if (atArray.count > 1) {
        NSString * hostString = (NSString *)[atArray objectAtIndex:1];
        NSRange dotRange = [hostString rangeOfString:@"."];
        
        
        if (dotRange.location == NSNotFound) {
            isEMail = NO;
            [RFAnimation animationErrorTextShow:label Message:@"Похоже, вы забыли про домен"];
            
        } else if ((hostString.length - dotRange.location - 1) < 2) {
            isEMail = NO;
            [RFAnimation animationErrorTextShow:label Message:@"Слишком короткий домен"];
            
        } else if ((hostString.length - dotRange.location - 1) > 2) {
            NSArray * domainArray = [NSArray arrayWithObjects:@".aero", @".arpa", @".asia", @".biz", @".cat",
                                     @".com", @".coop", @".edu", @".gov", @".info",
                                     @".int", @".jobs", @".mil", @".mobi", @".museum",
                                     @".name", @".net", @".org", @".post", @".pro",
                                     @".tel", @".travel", @".xxx", nil];
            
            NSString * domainString = [hostString substringFromIndex:dotRange.location];
            if (![domainArray containsObject:domainString]) {
                isEMail = NO;
                [RFAnimation animationErrorTextShow:label Message:@"Извините, нет такого домена"];
                
            }
        }
    }
    
    return isEMail;
}


//проверка на заполнение
+ (BOOL) isReturnNotEmpty:(UITextField *) textField ErrorLabel:(UILabel *) label {
    /*
    BOOL isNotEmpty = NO;
    
    if (textField.text.length > 0) {
        isNotEmpty = YES;
    }

    return isNotEmpty;
    */
    
    
    BOOL isNotEmpty = (textField.text.length > 0);
    
    return isNotEmpty;
}


@end
