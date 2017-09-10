//
//  ViewController.m
//  RegistrationForm
//
//  Created by Clyde Barrow on 25.06.17.
//  Copyright © 2017 Pavel Podgornov. All rights reserved.
//

#import "ViewController.h"
#import "TFValidation.h"

@interface ViewController () <UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate

////ввод символов
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    BOOL answer = YES;
//    
//    if (textField.tag < 2) {
//        answer = [PPValidation checkName:textField shouldChangeCharactersInRange:range replacementString:string];
//    } else if (textField.tag == 2) {
//        answer = [PPValidation checkMobileNumber:textField shouldChangeCharactersInRange:range replacementString:string];
//    } else if (textField.tag == 3) {
//        answer = [PPValidation checkEMail:textField shouldChangeCharactersInRange:range replacementString:string];
//    }
//    
//    return answer;
//}
//
////ретерн
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    BOOL answer = YES;
//    
//    //имя
//    if (textField.tag < 2) {
//        answer = [PPValidation isReturnName:textField];
//        
//        //номер телефона
//    } else if (textField.tag == 2) {
//        answer = [PPValidation isReturnPhoneNumber:textField];
//        
//        //имейл
//    } else if (textField.tag == 3) {
//        answer = [PPValidation isReturnEMail:textField];
//    }
//    
//    if (answer) {
//        if (textField.tag < self.textFieldCollection.count - 1) {
//            UITextField * field = [self.textFieldCollection objectAtIndex:textField.tag + 1];
//            [field becomeFirstResponder];
//        } else {
//            [textField resignFirstResponder];
//        }
//    }
//    
//    return answer;
//} // возвращаем ДА что бы ретерн сработал, НЕТ что бы не сработал

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //NSLog(@"начинаем редактировать? %d", textField.tag);
    return YES;
} //возвращаем ДА что бы начать редактировать , нет что бы не начинать

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //NSLog(@"начали редактировать %d", textField.tag);
} //если вернули ДА в предыдущем методе

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    //NSLog(@"закончили редактировать? %d", textField.tag);
    return YES;
}// возвращаем ДА что бы закончить редактировать, НЕТ что бы не заканчивать

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //NSLog(@"закончили редактировать %d", textField.tag);
}// если вернули ДА в предыдущем методе

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0) {
    //NSLog(@"закончили редактировать reason %d %d", reason, textField.tag);
}// если вернули ДА в предыдущем методе с плюшками

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    //NSLog(@"очистим поле? %d", textField.tag);
    return YES;
}// возвращаем ДА что бы очистка поля сработала, НЕТ что бы не сработала

@end
