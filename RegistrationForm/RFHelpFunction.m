//
//  RFHelpFunction.m
//  RegistrationForm
//
//  Created by Clyde Barrow on 22.07.17.
//  Copyright © 2017 Pavel Podgornov. All rights reserved.
//

#import "RFHelpFunction.h"

@interface RFHelpFunction ()

@end

@implementation RFHelpFunction

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Help Function

//установка градиента фона
+ (void) setBackgroundGradient:(UIView *)mainView colorFirst:(UIColor *)color1 colorSecond:(UIColor *)color2 {

    mainView.backgroundColor = [UIColor clearColor];
    
    CAGradientLayer * gradient = [CAGradientLayer layer];
    
    gradient.frame = mainView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id) color1.CGColor, (id) color2.CGColor, nil];
    
    [mainView.layer insertSublayer:gradient atIndex:0];
}


//возврат цвета по составляющим
+ (UIColor *) colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue {
    
    CGFloat r = red / 255.0;
    CGFloat g = green / 255.0;
    CGFloat b = blue / 255.0;
    
    return [UIColor colorWithRed:r
                           green:g
                            blue:b
                           alpha:1.0];
}


@end
