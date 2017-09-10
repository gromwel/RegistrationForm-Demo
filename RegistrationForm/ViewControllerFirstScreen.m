//
//  ViewControllerFirstScreen.m
//  RegistrationForm
//
//  Created by Clyde Barrow on 10.07.17.
//  Copyright © 2017 Pavel Podgornov. All rights reserved.
//

#import "ViewControllerFirstScreen.h"
#import "TFValidation.h"
#import "RFAnimation.h"
#import "RFHelpFunction.h"
#import "MarathonInfo.h"


@interface ViewControllerFirstScreen ()

//индикаторы заполнения полей
@property (nonatomic, assign) BOOL isFirstNameOK;
@property (nonatomic, assign) BOOL isSecondNameOK;
@property (nonatomic, assign) BOOL isPhoneNumberOK;
@property (nonatomic, assign) BOOL isEmailOK;

//актуальное текстовое поле
@property (nonatomic, strong) UITextField * actualField;


@end


@implementation ViewControllerFirstScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //деактивируем кнопку далее
    [RFAnimation buttonDeactivated:self.buttonSecondViewShow];
}


//перед загрузкой вью
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //инициализируем текстфиелд
    self.actualField = [[UITextField alloc] init];
    
    //устанавливаем индикаторы заполнения полей в положение NO
    self.isFirstNameOK = NO;
    self.isSecondNameOK = NO;
    self.isPhoneNumberOK = NO;
    self.isEmailOK = NO;
    
    //градиент фона
    [RFHelpFunction setBackgroundGradient:self.view colorFirst:[RFHelpFunction colorWithR:0 G:35 B:38]
                              colorSecond:[RFHelpFunction colorWithR:2 G:113 B:113]];
    
    //округляем кнопку
    self.buttonSecondViewShow.layer.cornerRadius = CGRectGetHeight(self.buttonSecondViewShow.frame)/2;
    
    //создаем жест тап
    UITapGestureRecognizer * handleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEndEditing)];
    [self.view addGestureRecognizer:handleTap];
    
    
    //заполнение данными полей при открытии вью
    //скрываем текст
    [RFAnimation animationTextArray:self.labelCollection Alpha:0.f Duration:0.f];
    [RFAnimation animationTextArray:self.textFieldCollection Alpha:0.f Duration:0.f];
    [RFAnimation animationTextArray:self.placeHolderTopCollection Alpha:0.f Duration:0.f];

    //записываем информацию
    [self writeMarathoneInfo];
}


//после загрузки вью
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //показываем текст
    [RFAnimation animationTextArray:self.labelCollection Alpha:1.f Duration:0.3f];
    [RFAnimation animationTextArray:self.textFieldCollection Alpha:1.f Duration:0.3f];
    [RFAnimation animationTextArray:self.placeHolderTopCollection Alpha:0.5f Duration:0.3f];
    
    //поднимаем плейсхолдер для не пустых полей
    for (UITextField * field in self.textFieldCollection) {
        if (![field.text isEqual:@""]) {
            [RFAnimation placeHolderUpLabel:[self.placeHolderTopCollection objectAtIndex:field.tag]
                                BottomLabel:[self.placeHolderBottomCollection objectAtIndex:field.tag]];
        }
    }
    
    //если все значения заполнены то активируем кнопку
    [self checkAllTextFieldForFilling];
}


//перед скрытием вью
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //скрываем все текст филды, лейблы, плейс холдеры
    [RFAnimation animationTextArray:self.textFieldCollection Alpha:0.f Duration:0.3f];
    [RFAnimation animationTextArray:self.labelCollection Alpha:0.f Duration:0.3f];
    [RFAnimation animationTextArray:self.placeHolderTopCollection Alpha:0.f Duration:0.3f];
    
    //опускаем плейсхолдеры
    for (int i = 0; i < self.placeHolderTopCollection.count; i++) {
        
        //только те плейсхолдеры что подняты
        [RFAnimation placeHolderDownLabel:[self.placeHolderTopCollection objectAtIndex:i]
                              BottomLabel:[self.placeHolderBottomCollection objectAtIndex:i]];
    }
}


#pragma mark - UITextFieldDelegate

//начало редактирования текста
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    //исправляем isOk
    [self writeIsOk:textField.tag isOk:NO];
    
    //запоминаем текстовое поле
    self.actualField = textField;
    
    //поднимаем плейсхолдер
    if (textField.text.length == 0) {
    
    [RFAnimation placeHolderUpLabel:[self.placeHolderTopCollection objectAtIndex:textField.tag]
                        BottomLabel:[self.placeHolderBottomCollection objectAtIndex:textField.tag]];
    }
    
    
    //проверяем на заполнение остальных полей
    //меняем кнопку продолжения
    if (![self nextTextField:textField]) {
        textField.returnKeyType = UIReturnKeyDone;
    } else {
        textField.returnKeyType = UIReturnKeyNext;
    }
}



//ввод символов
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //убираем сообщение ошибки
    [RFAnimation animationErrorTextHide:[self.textFieldErrorCollection objectAtIndex:textField.tag]];
    
    BOOL answer = YES;
    
    //если имя или фамилия то проверяем по их правилам
    if (textField.tag < TFPhoneNumber) {
        answer = [TFValidation checkName:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    //если телефон то проверяем по его правилу
    else if (textField.tag == TFPhoneNumber) {
        answer = [TFValidation checkMobileNumber:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    //если имейл то проверяем по его правилу
    else if (textField.tag == TFEmail) {
        answer = [TFValidation checkEMail:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    //символ вводится если вернется YES
    return answer;
}


//ретерн
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //проверяем введенныеданные с выводом сообщения
    BOOL answer = [self validationTF:textField ShowMessage:YES];
    
    //завершаем редактирование если соответствует правилу
    if (answer) {
        
        //запрашиваем следующий пустой текстфилд
        [self jumpNextField:textField];
        
    }
    
    //ретерн сработает если вернется YES
    return answer;
}



//завершение редактирования текста
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    //если поле пустое возвращаем плейсхолдер на место
    if (textField.text.length == 0) {
        [RFAnimation  placeHolderDownLabel:[self.placeHolderTopCollection objectAtIndex:textField.tag]
                               BottomLabel:[self.placeHolderBottomCollection objectAtIndex:textField.tag]];
        
        //убираем предупреждение если оно есть
        UILabel * labelError = [self.textFieldErrorCollection objectAtIndex:textField.tag];
        if (labelError.alpha == 1.f) {
            [RFAnimation animationErrorTextHide:labelError];
        }
    }
    
    
    
    //если поле не пустое, проверяем на заполнение по правилам
    else {
        [self onlyValidationTF:textField];
    }
    
    //если все поля заполнены по правилам
    [self checkAllTextFieldForFilling];
}


//очистка поля по крестику
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    //опускаем плейсхолдер что бы он поднялся
    [RFAnimation placeHolderDownLabel:[self.placeHolderTopCollection objectAtIndex:textField.tag]
                          BottomLabel:[self.placeHolderBottomCollection objectAtIndex:textField.tag]];
    
    //убираем предупреждение если оно есть
    UILabel * labelError = [self.textFieldErrorCollection objectAtIndex:textField.tag];
    if (labelError.alpha == 1.f) {
        [RFAnimation animationErrorTextHide:labelError];
    }
    
    return YES;
}



#pragma mark - Action Function
//кнопка далее
- (IBAction)buttonNextAction:(id)sender {
    
    //записываем те данные текст филдов что есть в наш синглтон
    for (UITextField * field in self.textFieldCollection) {
        
        //если данные есть
        if (field.text.length > 0) {
            //этот текст филд надо перезаписать
            [self saveMarathoneInfo:field.tag];
        }
    }
}


#pragma mark - Writing/Saving Marathone Info

//заполняем строки
- (void) writeMarathoneInfo {
    //запишем данные из инфы
    //для этого сравниваем информацию и поле
    [self isEqualTextField:self.textFieldFirstName Property:[MarathonInfo sharedGlobalVariable].firstName];
    [self isEqualTextField:self.textFieldSecondName Property:[MarathonInfo sharedGlobalVariable].secondName];
    [self isEqualTextField:self.textFieldPhoneNumber Property:[MarathonInfo sharedGlobalVariable].phoneNumber];
    [self isEqualTextField:self.textFieldEMail Property:[MarathonInfo sharedGlobalVariable].eMail];
    //сравниваем информацию и лейбл
    [self isEqualLabel:self.labelCityMarathone Property:[MarathonInfo sharedGlobalVariable].city];
    [self isEqualLabel:self.labelDateMarathone Property:[MarathonInfo sharedGlobalVariable].date];
}


//проверяем лейбл на необходимость заполнения
//сравниваем лейблы
- (void) isEqualLabel:(UILabel*)label Property:(id)property {
    
    //если проперти не пустой то запишем его
    if (property) {
        label.text = property;
    }
    
}

//сравниваем поля
- (void) isEqualTextField:(UITextField*)textField Property:(NSString*)property {
    
    //если проперти не пустой то запишем его
    if (property) {
        textField.text = property;
        [self writeIsOk:textField.tag isOk:YES];
    }
}


//перезаписываем проперти для определенного филда (тэг)
- (void) saveMarathoneInfo:(NSInteger)tag {
    if (tag == TFFirstName) {
        [MarathonInfo sharedGlobalVariable].firstName = self.textFieldFirstName.text;
        
    } else if (tag == TFSecondName) {
        [MarathonInfo sharedGlobalVariable].secondName = self.textFieldSecondName.text;
        
    } else if (tag == TFPhoneNumber) {
        [MarathonInfo sharedGlobalVariable].phoneNumber = self.textFieldPhoneNumber.text;
        
    } else if (tag == TFEmail) {
        [MarathonInfo sharedGlobalVariable].eMail = self.textFieldEMail.text;
    }
}


#pragma mark - Other Function
//определяем следующее не заполненное текстовое поле
- (UITextField *) nextTextField:(UITextField *)field {
    UITextField * nextField = nil;
    
    //берем следующий по порядку филд
    for (int i = (int)field.tag + 1; i < self.textFieldCollection.count; i++) {
        
        //проверяем у этого филда заполнение, если он пустой, определяем его
        if (![self checkIsOk:i] & !nextField) {
            nextField = [self.textFieldCollection objectAtIndex:i];
        }
    }
    
    //если следующих пустых полей не оказалось, проверяем предыдущие по порядку
    for (int i = 0; i < field.tag; i++) {
        
        //проверяем у этого филда заполнение, если он пустой, определяем его
        if (![self checkIsOk:i] & !nextField) {
            nextField = [self.textFieldCollection objectAtIndex:i];
        }
    }
    
    //возвращаем или определенный филд или нил
    return nextField;
}

//прыгаем в следующее не заполненное поле или убираем клавиатуру
- (void) jumpNextField:(UITextField *)field {
    
    //определяем следующее пустое поле
    UITextField * nextField = [self nextTextField:field];
    
    //если такое есть то переходим редактировать его
    if (nextField) {
        [nextField becomeFirstResponder];
        
        //если нет то закрываем редактирование
    } else {
        [self.view endEditing:YES];
    }
}


//если все поля заполнены по правилам то активируем кнопку, если нет, деактивируем
- (void) checkAllTextFieldForFilling {
    
    if (self.isFirstNameOK & self.isSecondNameOK & self.isPhoneNumberOK & self.isEmailOK) {
        [RFAnimation buttonActivated:self.buttonSecondViewShow];
    } else {
        [RFAnimation buttonDeactivated:self.buttonSecondViewShow];
    }
}


//задаем что происходит по тапу
- (void) tapEndEditing {
    
    //закрываем редактирование
    [self.view endEditing:YES];
    
    //проверяем по правилу на заполнение
    BOOL answer = [self validationTF:self.actualField ShowMessage:NO];
    
    //если правилу не соответствует но хоть что то введено то показываем предупреждение
    if (answer | (self.actualField.text.length == 0)) {
    } else {
        [RFAnimation animationWarningTextShow:[self.textFieldErrorCollection objectAtIndex:self.actualField.tag]];
    }
}



//проводит анализз стекстового поля
- (BOOL) validationTF:(UITextField *)textField ShowMessage:(BOOL)show {
    UILabel * label = nil;
    
    //если сообщение показываем то определим лейбл для этого сообщения
    if (show) {
        label = [self.textFieldErrorCollection objectAtIndex:textField.tag];
    }
    
    BOOL answer;
    
    //проверяем заполнение по правилу и переопределяем индикатор заполнения этого поля
    if (textField.tag < TFPhoneNumber) {
    [self writeIsOk:textField.tag isOk:[TFValidation isReturnName:textField ErrorLabel:label]];
     
    } else if (textField.tag == TFPhoneNumber) {
    [self writeIsOk:textField.tag isOk:[TFValidation isReturnPhoneNumber:textField ErrorLabel:label]];
     
    } else if (textField.tag == TFEmail) {
    [self writeIsOk:textField.tag isOk:[TFValidation isReturnEMail:textField ErrorLabel:label]];
    }
    
    //переопределяем ответ по индикатору заполнения конкретного поля
    answer = [self checkIsOk:textField.tag];
    
    //возвращем YES/NO
    return answer;
}


//проводит анализ стекстового поля без возвращения результата
- (void) onlyValidationTF:(UITextField *)textField {
    
    UILabel * label = [self.textFieldErrorCollection objectAtIndex:textField.tag];
    
    //проверяем заполнение по правилу и переопределяем индикатор заполнения этого поля
    if (textField.tag < TFPhoneNumber) {
        [self writeIsOk:textField.tag isOk:[TFValidation isReturnName:textField ErrorLabel:label]];

    } else if (textField.tag == TFPhoneNumber) {
        [self writeIsOk:textField.tag isOk:[TFValidation isReturnPhoneNumber:textField ErrorLabel:label]];

    } else if (textField.tag == TFEmail) {
        [self writeIsOk:textField.tag isOk:[TFValidation isReturnEMail:textField ErrorLabel:label]];
    }
}



//определяем индикатор заполения для определенного текстфилда (тэг)
- (void) writeIsOk:(NSInteger)tag isOk:(BOOL)isOk {
    
    if (tag == TFFirstName) {
        self.isFirstNameOK = isOk;
    } else if (tag == TFSecondName) {
        self.isSecondNameOK = isOk;
    } else if (tag == TFPhoneNumber) {
        self.isPhoneNumberOK = isOk;
    } else if (tag == TFEmail) {
        self.isEmailOK = isOk;
    }
}


//проверяем значение индикатора заполения для определенного филда (тэг)
- (BOOL) checkIsOk:(NSInteger)tag {
    
    BOOL answer = NO;
    if ((tag == TFFirstName) & self.isFirstNameOK) {
        answer = YES;
    } else if ((tag == TFSecondName) & self.isSecondNameOK) {
        answer = YES;
    } else if ((tag == TFPhoneNumber) & self.isPhoneNumberOK) {
        answer = YES;
    } else if ((tag == TFEmail) & self.isEmailOK) {
        answer = YES;
    }
    
    return answer;
}

@end
