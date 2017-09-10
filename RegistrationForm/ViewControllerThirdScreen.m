//
//  ViewControllerThirdScreen.m
//  RegistrationForm
//
//  Created by Clyde Barrow on 13.08.17.
//  Copyright © 2017 Pavel Podgornov. All rights reserved.
//

#import "ViewControllerThirdScreen.h"
#import "RFHelpFunction.h"
#import "MarathonInfo.h"
#import "RFAnimation.h"

@interface ViewControllerThirdScreen ()

@end

@implementation ViewControllerThirdScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //градиент фона
    [RFHelpFunction setBackgroundGradient:self.view colorFirst:[RFHelpFunction colorWithR:0 G:35 B:38]
                              colorSecond:[RFHelpFunction colorWithR:2 G:113 B:113]];
    
    //округляем кнопку
    self.buttonRegistrationOutlet.layer.cornerRadius = CGRectGetHeight(self.buttonRegistrationOutlet.frame)/2;
    
    
    //скрываем текст
    [self animationTextShow:NO Duration:0.f];
    
    //зполняем лейблы
    [self writeMarathoneInfo];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //показываем текст
    [self animationTextShow:YES Duration:0.3f];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //скрываем текст
    [self animationTextShow:NO Duration:0.3f];
}

#pragma mark - Animation Text

//анимация текста показать/скрыть
- (void) animationTextShow:(BOOL)show Duration:(CGFloat)duration {
    
    [UIView animateWithDuration:duration
                     animations:^{
                         
                         self.labelFirstName.alpha = show;
                         self.labelSecondName.alpha = show;
                         self.labelPhoneNumber.alpha = show;
                         
                         self.labelCity.alpha = show;
                         self.labelDate.alpha = show;
                         self.labelBirthDate.alpha = show;
                         self.labelPhoneNumberRelation.alpha = show;
                         self.labelEMail.alpha = show;
                         self.labelTime.alpha = show;
                         
                         self.labelText1.alpha = show;
                         self.labelText2.alpha = show;
                         
                         self.buttonRegistrationOutlet.alpha = show;
                         
                     }];
}


//запись данных в лейблы
- (void) writeMarathoneInfo {
    
    self.labelFirstName.text = [MarathonInfo sharedGlobalVariable].firstName;
    self.labelSecondName.text = [MarathonInfo sharedGlobalVariable].secondName;
    self.labelPhoneNumber.text = [MarathonInfo sharedGlobalVariable].phoneNumber;
    
    self.labelCity.text = [MarathonInfo sharedGlobalVariable].city;
    self.labelDate.text = [MarathonInfo sharedGlobalVariable].date;
    self.labelBirthDate.text = [MarathonInfo sharedGlobalVariable].birthDate;
    self.labelPhoneNumberRelation.text = [NSString stringWithFormat:@"*%@",[MarathonInfo sharedGlobalVariable].phoneNumberRelation];
    self.labelEMail.text = [MarathonInfo sharedGlobalVariable].eMail;
    
    self.labelTime.text = [self timeTextParsing];
}


#pragma mark - Parsing Text

//парсинг текста предполагаемого времени
- (NSString *) timeTextParsing {
    
    //выделяем из строки минуты и часы
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@" :"];
    NSArray * array = [[MarathonInfo sharedGlobalVariable].estimatedTime componentsSeparatedByCharactersInSet:set];
    
    //создаем новую строку
    NSString * string = [NSString stringWithFormat:@"за %@ час %@ мин", [array objectAtIndex:1], [array objectAtIndex:2]];
    
    return string;
}

@end
