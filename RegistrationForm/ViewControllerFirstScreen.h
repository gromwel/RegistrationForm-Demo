//
//  ViewControllerFirstScreen.h
//  RegistrationForm
//
//  Created by Clyde Barrow on 10.07.17.
//  Copyright © 2017 Pavel Podgornov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFPlaceHolder.h"

typedef enum {
    
    TFFirstName,        //= 0
    TFSecondName,       //= 1
    TFPhoneNumber,      //= 2
    TFEmail             //= 3
    
} TFType;



@interface ViewControllerFirstScreen : UIViewController

//оутлет коллекции
//коллекция текст филдов
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;

//коллекция линий
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *textLineCollection;

//коллекция плейсхолдеров
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *placeHolderTopCollection;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *placeHolderBottomCollection;

//коллекция лейблов ошибки/предупреждения
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *textFieldErrorCollection;

//коллекция лейблов текста
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;



//оутлеты
//оутлеты активных элементов
@property (weak, nonatomic) IBOutlet UIButton *buttonSecondViewShow;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFirstName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSecondName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEMail;

//оутлеты лейблов
@property (weak, nonatomic) IBOutlet UILabel *labelDateMarathone;
@property (weak, nonatomic) IBOutlet UILabel *labelCityMarathone;
@property (weak, nonatomic) IBOutlet UILabel *labelEvent;


//экшены
//метод кнопки по нажатию
- (IBAction)buttonNextAction:(id)sender;




@end
