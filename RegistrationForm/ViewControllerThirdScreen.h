//
//  ViewControllerThirdScreen.h
//  RegistrationForm
//
//  Created by Clyde Barrow on 13.08.17.
//  Copyright © 2017 Pavel Podgornov. All rights reserved.
//

#import "ViewController.h"

@interface ViewControllerThirdScreen : ViewController

//лейблы вывода информации об участнике и забеге
@property (weak, nonatomic) IBOutlet UILabel *labelFirstName;
@property (weak, nonatomic) IBOutlet UILabel *labelSecondName;
@property (weak, nonatomic) IBOutlet UILabel *labelCity;

@property (weak, nonatomic) IBOutlet UILabel *labelBirthDate;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNumberRelation;
@property (weak, nonatomic) IBOutlet UILabel *labelEMail;

@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;

//кнопка перехода на четвертый экран
@property (weak, nonatomic) IBOutlet UIButton *buttonRegistrationOutlet;

//лейблы постоянного текста
@property (weak, nonatomic) IBOutlet UILabel *labelText1;
@property (weak, nonatomic) IBOutlet UILabel *labelText2;

@end
