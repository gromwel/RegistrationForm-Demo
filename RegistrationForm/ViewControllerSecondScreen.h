//
//  ViewControllerSecondScreen.h
//  RegistrationForm
//
//  Created by Clyde Barrow on 10.07.17.
//  Copyright © 2017 Pavel Podgornov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFPlaceHolder.h"

typedef enum {
    
    TFCity,             //= 0
    TFDate,             //= 1
    TFTime,             //= 2
    TFPhoneNumber,      //= 3
    TFSex               //= 4
    
} TFType;


@interface ViewControllerSecondScreen : UIViewController

//оутлет коллекции
//коллекция текст филдов
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;

//коллекция линий
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *textLineCollection;

//коллекция плейсхолдеров
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *placeHolderTopCollection;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *placeHolderBottomCollection;

//коллекция лайблов ошибки/предупреждения
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *textFieldErrorCollection;

//коллекция лэйблов текста
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;



//оутлеты
//оутлеты активных элементов
@property (weak, nonatomic) IBOutlet UITextField *textFieldBirthDate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCity;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhoneNumberRelation;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEstimatedTime;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControlSexOutlet;
@property (weak, nonatomic) IBOutlet UIButton *buttonThirdViewShow;

//оутлеты лейблов
@property (weak, nonatomic) IBOutlet UILabel *labelDateMarathone;
@property (weak, nonatomic) IBOutlet UILabel *labelCityMarathone;
@property (weak, nonatomic) IBOutlet UILabel *labelEvent;


//экшены
//методы кнопок по нажатию
- (IBAction)buttonNextAction:(id)sender;
- (IBAction)buttonBackAction:(id)sender;

//метод сегмент контрола по нажатию
- (IBAction)segmentControlSexAction:(id)sender;


@end
