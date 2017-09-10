//
//  TFAnimation.m
//  RegistrationForm
//
//  Created by Clyde Barrow on 22.07.17.
//  Copyright © 2017 Pavel Podgornov. All rights reserved.
//

#define     MY_TIME_INTERVAL    0.3f


#import "RFAnimation.h"



@interface RFAnimation ()
@end

@implementation RFAnimation

//анимация поднятия плейсхолдера
+ (void) placeHolderUpLabel: (UILabel *) labelTop BottomLabel: (UILabel *) labelBottom {
    
    [UIView animateWithDuration:MY_TIME_INTERVAL
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         //берем ширину плейсхолдера
                         CGFloat width = CGRectGetWidth(labelTop.frame);
                         
                         //масштабируем оба плейсхолдера с размера 17 на размер 13
                         labelTop.transform = CGAffineTransformMakeScale(13.f/17.f, 13.f/17.f);
                         labelBottom.transform = CGAffineTransformMakeScale(13.f/17.f, 13.f/17.f);
                         
                         //посчитаем центр перемещаемых плейсхолдеров
                         CGFloat centerX = CGRectGetMidX(labelTop.frame) - ((width / 2) - CGRectGetWidth(labelTop.frame) / 2);
                         
                         //задаем координаты перемещания плейсхолдеров
                         labelTop.center = CGPointMake(centerX,
                                                       CGRectGetMidY(labelTop.frame) - 20);
                         labelBottom.center = CGPointMake(centerX,
                                                          CGRectGetMidY(labelBottom.frame) - 20);
                         
                         //верхний слой скрываем, нижний проявляем (меняем цвет плавно)
                         labelTop.alpha = 0.f;
                         labelBottom.alpha = 1.f;
                     }
     
                     completion:^(BOOL finished) {
                     }];
}


//анимация опускания плейсхолдера
+ (void) placeHolderDownLabel: (UILabel *) labelTop BottomLabel: (UILabel *) labelBottom {
    
    [UIView animateWithDuration:MY_TIME_INTERVAL
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         CGFloat width = CGRectGetWidth(labelTop.frame);
                         
                         labelTop.transform = CGAffineTransformIdentity;
                         labelBottom.transform = CGAffineTransformIdentity;
                         
                         CGFloat centerX = CGRectGetMidX(labelTop.frame) + ((CGRectGetWidth(labelTop.frame) - width) / 2);
                         
                         labelTop.center = CGPointMake(centerX,
                                                       CGRectGetMidY(labelTop.frame) + 20);
                         labelBottom.center = CGPointMake(centerX,
                                                          CGRectGetMidY(labelBottom.frame) + 20);
                         
                         labelTop.alpha = 0.5f;
                         labelBottom.alpha = 0.f;
                     }
     
                     completion:^(BOOL finished) {
                     }];
}


//показываем ошибку
+ (void) animationErrorTextShow:(UILabel *)label Message:(NSString *)string {
    
    label.text = string;
    label.textColor = [UIColor redColor];
    
    [UIView animateWithDuration:MY_TIME_INTERVAL
                     animations:^{
                         label.alpha = 1.0;
                     }];
    
}

//скрываем ошибку
+ (void) animationErrorTextHide:(UILabel *)label {
    
    [UIView animateWithDuration:MY_TIME_INTERVAL
                     animations:^{
                         label.alpha = 0.f;
                     }];
    
}

//показываем предупреждение
+ (void) animationWarningTextShow:(UILabel *)label {
    
    label.text = @"Вы не заполнили эту строку";
    label.textColor = [UIColor yellowColor];
    
    [UIView animateWithDuration:1.f
                     animations:^{
                         label.alpha = 1.0;
                     }];
}


//анимация изменения цвета текста
+ (void) animatedChangeColorText:(UILabel *) labelTop BottomLabel: (UILabel *) labelBottom {
    
    labelBottom.tintColor = [UIColor orangeColor];
    
    [UIView animateWithDuration:MY_TIME_INTERVAL
                     animations:^{
                         
                         labelTop.alpha = 0.f;
                         labelBottom.alpha = 1.f;
                     }];
}


//изменение цвета плейсхолдера сегмент контрола
+ (void) animationPlaceholderSegmentedControl:(UILabel *)labelTop BottomLabel:(UILabel *)labelBottom SegmentedControl:(UISegmentedControl*)segmentedControl {
    
    [UIView animateWithDuration:MY_TIME_INTERVAL
                     animations:^{
                         segmentedControl.alpha = 1.f;
                     }];
    
    [self animatedChangeColorText:labelTop
                      BottomLabel:labelBottom];
}


//активация кнопки
+ (void) buttonActivated:(UIButton *)button {
    
    button.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         button.backgroundColor = [UIColor orangeColor];
                         button.alpha = 1.f;
                     }];
}

//деактивация кнопки
+ (void) buttonDeactivated:(UIButton *)button {
    
    button.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         button.backgroundColor = [UIColor lightGrayColor];
                         button.alpha = 0.8f;
                     }];
}

//анимация текста показать/скрыть
+ (void) animationTextArray:(NSArray *)array Alpha:(CGFloat)alpha  Duration:(CGFloat)duration {
    
    for (UIView * view in array) {
        [UIView animateWithDuration:duration
                         animations:^{
                             view.alpha = alpha;
                         }];
    }
    
}

@end
