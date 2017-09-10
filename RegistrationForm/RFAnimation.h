//
//  TFAnimation.h
//  RegistrationForm
//
//  Created by Clyde Barrow on 22.07.17.
//  Copyright © 2017 Pavel Podgornov. All rights reserved.
//

#import "ViewController.h"
#import "RFPlaceHolder.h"

@interface RFAnimation : ViewController

//анимация плейсхолдера
+ (void) placeHolderUpLabel: (UILabel *) labelTop BottomLabel: (UILabel *) labelBottom;
+ (void) placeHolderDownLabel: (UILabel *) labelTop BottomLabel: (UILabel *) labelBottom;

//анимация текста ошибки и предупреждения
+ (void) animationErrorTextShow:(UILabel *)label Message:(NSString *)string;
+ (void) animationErrorTextHide:(UILabel *)label;
+ (void) animationWarningTextShow:(UILabel *)label;

//анимация плейсхолдера сегмент контрола
+ (void) animatedChangeColorText:(UILabel *) labelTop BottomLabel: (UILabel *) labelBottom;
+ (void) animationPlaceholderSegmentedControl:(UILabel *)labelTop BottomLabel:(UILabel *)labelBottom SegmentedControl:(UISegmentedControl*)segmentedControl;

//активация/деактивация кнопки
+ (void) buttonActivated:(UIButton *)button;
+ (void) buttonDeactivated:(UIButton *)button;

//анимация текста показать/скрыть
+ (void) animationTextArray:(NSArray *)array Alpha:(CGFloat)alpha  Duration:(CGFloat)duration;

@end
