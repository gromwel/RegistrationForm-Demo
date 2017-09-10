//
//  ViewControllerFourthScreen.m
//  RegistrationForm
//
//  Created by Clyde Barrow on 26.08.17.
//  Copyright © 2017 Pavel Podgornov. All rights reserved.
//

#import "ViewControllerFourthScreen.h"
#import "RFHelpFunction.h"
#import "MarathonInfo.h"
#import "RFAnimation.h"

@interface ViewControllerFourthScreen ()
@end

@implementation ViewControllerFourthScreen

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
    
    //скрывваем текст
    [self animationTextShow:NO Duration:0.f];
    
    //заполняем данные
    [self writeMarathoneInfo];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //показывваем текст
    [self animationTextShow:YES Duration:0.3f];
}


#pragma mark - Animation Text

//анимация текста показать/скрыть
- (void) animationTextShow:(BOOL)show Duration:(CGFloat)duration {
    
    [UIView animateWithDuration:duration
                     animations:^{
                         
                         self.labelText1.alpha = show;
                         self.labelCity.alpha = show;
                         self.labelDate.alpha = show;
                         
                         self.labelText2.alpha = show;
                         self.labelNumber.alpha = show;
                         
                         self.labelText3.alpha = show;
                         self.labelPickUp.alpha = show;
                         self.labelAddres.alpha = show;
                     }];
}


//запись данных в лейблы
- (void) writeMarathoneInfo {
    
    self.labelCity.text = [MarathonInfo sharedGlobalVariable].city;
    self.labelDate.text = [MarathonInfo sharedGlobalVariable].date;

    self.labelNumber.text = [self parsingNumber];
    
    self.labelPickUp.text = [self parsingPickUp];
    self.labelAddres.text = [self parsingAdres];
    

}

#pragma mark - Parsing Text

//рандомный номер
- (NSInteger) randomNumber {
    
    NSInteger number = arc4random()%9999;
    return number;
}


//парсинг текста информации о получении стартовых пакетов
- (NSString *) parsingPickUp {
    
    NSArray * array = [[MarathonInfo sharedGlobalVariable].date componentsSeparatedByString:@" "];
    NSInteger date = [[array objectAtIndex:0] integerValue];
    
    NSString * string = [NSString stringWithFormat:@"Забрать стартовый комплект можно\n %li или %li %@ с 9:00 до 18:00", date - 2, date - 1, [array objectAtIndex:1]];
    
    return string;
}


//парсинг номера
- (NSString *) parsingNumber {
    
    NSMutableString * number = [NSMutableString stringWithFormat:@"%li", [self randomNumber]];
    NSInteger round = 4 - number.length;
    
    for (int i = 0; i < round; i++) {
        number = [NSMutableString stringWithFormat:@"0%@", number];
    }
    
    return number;
}


//парсинг адреса получения стартовых пакетов
- (NSString *) parsingAdres {
    
    NSString * address = [NSString stringWithFormat:@"Где: г. %@\nпр. Ленина, дом 34, строение 2", [MarathonInfo sharedGlobalVariable].city];
    
    return address;
}


//переход к началу
- (IBAction)buttonOK:(id)sender {
    
    [[MarathonInfo alloc] initWithInfo];
    
}


@end
