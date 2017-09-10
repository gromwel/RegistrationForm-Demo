//
//  ViewControllerFourthScreen.h
//  RegistrationForm
//
//  Created by Clyde Barrow on 26.08.17.
//  Copyright © 2017 Pavel Podgornov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerFourthScreen : UIViewController

//изменяемые лейблы (текст)
@property (weak, nonatomic) IBOutlet UILabel *labelNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelAddres;
@property (weak, nonatomic) IBOutlet UILabel *labelCity;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelPickUp;

//не изменяемые лейблы (прозрачность)
@property (weak, nonatomic) IBOutlet UILabel *labelText1;
@property (weak, nonatomic) IBOutlet UILabel *labelText2;
@property (weak, nonatomic) IBOutlet UILabel *labelText3;

//кнопка перехода к началу
- (IBAction)buttonOK:(id)sender;

@end
