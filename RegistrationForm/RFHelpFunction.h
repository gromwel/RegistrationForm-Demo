//
//  RFHelpFunction.h
//  RegistrationForm
//
//  Created by Clyde Barrow on 22.07.17.
//  Copyright © 2017 Pavel Podgornov. All rights reserved.
//

#import "ViewController.h"

@interface RFHelpFunction : ViewController

//установка градиента бэкграунда
+ (void) setBackgroundGradient : (UIView *) mainView colorFirst : (UIColor *) color1 colorSecond : (UIColor *) color2;

//получения цвета по целым значениям RGB
+ (UIColor *) colorWithR: (CGFloat) red G: (CGFloat) green B: (CGFloat) blue;


@end
