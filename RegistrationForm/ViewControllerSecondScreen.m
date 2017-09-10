//
//  ViewControllerSecondScreen.m
//  RegistrationForm
//
//  Created by Clyde Barrow on 10.07.17.
//  Copyright © 2017 Pavel Podgornov. All rights reserved.
//

#import "ViewControllerSecondScreen.h"
#import "TFValidation.h"
#import "RFAnimation.h"
#import "RFHelpFunction.h"
#import "MarathonInfo.h"
#import "RFPlaceHolder.h"


@interface ViewControllerSecondScreen () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

//пикеры создаваемые кодом
@property (nonatomic, strong) UIDatePicker * datePicker;
@property (nonatomic, strong) UIPickerView * timePicker;
@property (nonatomic, strong) UIPickerView * cityPicker;

//массивы для создания пикеров
@property (nonatomic, strong) NSArray * arrayTime;
@property (nonatomic, strong) NSArray * arrayCity;

//индикаторы заполения полей
@property (nonatomic, assign) BOOL isCityOK;
@property (nonatomic, assign) BOOL isBirthDateOK;
@property (nonatomic, assign) BOOL isEstimatedTimeOK;
@property (nonatomic, assign) BOOL isPhoneNumberOK;
@property (nonatomic, assign) BOOL isSexOk;

//актуальное текстовое поле
@property (nonatomic, strong) UITextField * actualField;

@end


@implementation ViewControllerSecondScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //деактивируем кнопку далее
    [RFAnimation buttonDeactivated:self.buttonThirdViewShow];
}


//перед загрузкой вью
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //инициализация текстфилд
    self.actualField = [[UITextField alloc] init];
    
    //изначально индикаторы заполнения полей в положение NO
    self.isCityOK = NO;
    self.isBirthDateOK = NO;
    self.isEstimatedTimeOK = NO;
    self.isPhoneNumberOK = NO;
    
    //создание дата пикера
    self.datePicker = [[UIDatePicker alloc] init];
    [self createDatePicker];
    
    //создание пикера времени
    self.timePicker = [[UIPickerView alloc] init];
    [self createTimePicker];
    
    //создание пикера города
    self.cityPicker = [[UIPickerView alloc] init];
    [self createCityPicker];
    
    //градиент фона
    [RFHelpFunction setBackgroundGradient:self.view
                               colorFirst:[RFHelpFunction colorWithR:0 G:35 B:38]
                              colorSecond:[RFHelpFunction colorWithR:2 G:113 B:113]];
    
    //округляем кнопку
    self.buttonThirdViewShow.layer.cornerRadius = CGRectGetHeight(self.buttonThirdViewShow.frame)/2;
    
    //создаем жест тап
    UITapGestureRecognizer * handleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEndEditing)];
    [self.view addGestureRecognizer:handleTap];
    
    
    //заполнение данными полей при открытии вью
    //скрываем текст
    [RFAnimation animationTextArray:self.labelCollection Alpha:0.f Duration:0.f];
    [RFAnimation animationTextArray:self.textFieldCollection Alpha:0.f Duration:0.f];
    [RFAnimation animationTextArray:self.placeHolderTopCollection Alpha:0.f Duration:0.f];
    
    //записываем информацию
    [self writeMarathoneInfo];
}


//после загрузки вью
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //показываем текст
    [RFAnimation animationTextArray:self.labelCollection Alpha:1.f Duration:0.3f];
    [RFAnimation animationTextArray:self.textFieldCollection Alpha:1.f Duration:0.3f];
    [RFAnimation animationTextArray:self.placeHolderTopCollection Alpha:0.5f Duration:0.3f];
    
    //поднимаем плейсхолдер для не пустых полей
    for (UITextField * field in self.textFieldCollection) {
        if (![field.text isEqual:@""]) {
            [RFAnimation placeHolderUpLabel:[self.placeHolderTopCollection objectAtIndex:field.tag]
                                BottomLabel:[self.placeHolderBottomCollection objectAtIndex:field.tag]];
        }
    }
    
    //активация плейсхолдера сегмент контрола емли он был активирован
    if (self.segmentControlSexOutlet.selectedSegmentIndex >= 0) {
        [RFAnimation animationPlaceholderSegmentedControl:[self.placeHolderTopCollection objectAtIndex:4]
                                              BottomLabel:[self.placeHolderBottomCollection objectAtIndex:4]
                                         SegmentedControl:self.segmentControlSexOutlet];
    }
    
    //если все значения заполнены то активируем кнопку
    [self checkAllTextFieldForFilling];
}


//перед скрытием вью
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //скрываем все текст филды, лейблы, плейс холдеры
    [RFAnimation animationTextArray:self.textFieldCollection Alpha:0.f Duration:0.3f];
    [RFAnimation animationTextArray:self.labelCollection Alpha:0.f Duration:0.3f];
    [RFAnimation animationTextArray:self.placeHolderTopCollection Alpha:0.f Duration:0.3f];
    
    //опускаем плейсхолдеры
    for (int i = 0; i < self.placeHolderTopCollection.count; i++) {
        
        //только те плейсхолдеры что подняты
            [RFAnimation placeHolderDownLabel:[self.placeHolderTopCollection objectAtIndex:i]
                                  BottomLabel:[self.placeHolderBottomCollection objectAtIndex:i]];
    }
}


#pragma mark - UITextFieldDelegate

//начало редактирования текста
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    //исправляем isOk
    [self writeIsOk:textField.tag isOk:NO];
    
    //запоминаем текстовое поле
    self.actualField = textField;
    
    //поднимаем плейсхолдер
    if (textField.text.length == 0) {
        
        [RFAnimation placeHolderUpLabel:[self.placeHolderTopCollection objectAtIndex:textField.tag]
                            BottomLabel:[self.placeHolderBottomCollection objectAtIndex:textField.tag]];
    }
    
    
    //проверяем на заполнение остальных полей
    //меняем кнопку продолжения
    if (![self nextTextField:textField]) {
        textField.returnKeyType = UIReturnKeyDone;
    } else {
        textField.returnKeyType = UIReturnKeyNext;
    }
}


//ввод символов
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //убираем сообщение ошибки
    [RFAnimation animationErrorTextHide:[self.textFieldErrorCollection objectAtIndex:textField.tag]];
    
    BOOL answer = YES;
    
    //проверяем ввод номера
    if (textField.tag == TFPhoneNumber) {
        answer = [TFValidation checkMobileNumber:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    //символ вводится если вернется YES
    return answer;
}



//ретерн
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //проверяем введенные данные с выводом сообщения
    BOOL answer = [self validationTF:textField ShowMessage:YES];
    
    //завершаем редактирование если соответствыет правилу
    if (answer) {
        
        //запрашиваем следующий пустой текстфилд
        [self jumpNextField:textField];
        
    }
    
    //ретерн сработает если вернется YES
    return answer;
}



//завершение редактирования текста
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    //если поле пустое возвращаем плейсхолдер на место
    if (textField.text.length == 0) {
        [RFAnimation placeHolderDownLabel:[self.placeHolderTopCollection objectAtIndex:textField.tag]
                              BottomLabel:[self.placeHolderBottomCollection objectAtIndex:textField.tag]];
        
        //убираем предупреждение если оно есть
        UILabel * labelError = [self.textFieldErrorCollection objectAtIndex:textField.tag];
        if (labelError.alpha == 1.f) {
            [RFAnimation animationErrorTextHide:labelError];
        }
    }
    
    //если текстовое поле не пустое, проверяем на заполнение по правилам
    else {
        [self onlyValidationTF:textField];
    }
    
    //если все поля по правилам
    [self checkAllTextFieldForFilling];
}


//очистка поля по крестику
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    //отпускаем плейсхолдер что бы он поднялся
    [RFAnimation placeHolderDownLabel:[self.placeHolderTopCollection objectAtIndex:textField.tag]
                          BottomLabel:[self.placeHolderBottomCollection objectAtIndex:textField.tag]];
    
    //убираем предупреждение если оно есть
    UILabel * labelError = [self.textFieldErrorCollection objectAtIndex:textField.tag];
    if (labelError.alpha == 1.f) {
        [RFAnimation animationErrorTextHide:labelError];
    }
    
    //меняем плавно город и дату
    if (textField.tag == 0) {
        [UIView animateWithDuration:0.4f
                         animations:^{
                             self.labelCityMarathone.alpha = 0.f;
                             self.labelDateMarathone.alpha = 0.f;
                         }
                         completion:^(BOOL finished) {
                             self.labelCityMarathone.text = @"ТВОЕГО ГОРОДА";
                             self.labelDateMarathone.text = @"Осень 2017";
                             
                             [UIView animateWithDuration:0.4f
                                              animations:^{
                                                  self.labelCityMarathone.alpha = 1.f;
                                                  self.labelDateMarathone.alpha = 1.f;
                                              }];
                         }];
    }
    
    
    
    return YES;
}


#pragma mark - UIPickerViewDataSource

//сколько столбцов в пикере города и предполагаемого времени
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


//сколько строк в пикере города и предполагаемого времени
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger rows = 0;
    
    if ([pickerView isEqual:self.cityPicker]) {
        rows = self.arrayCity.count;
    } else if ([pickerView isEqual:self.timePicker]) {
        rows = self.arrayTime.count;
    }
    return rows;
}


//заполнение строк пикера
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if ([pickerView isEqual:self.cityPicker]) {
        return [self.arrayCity objectAtIndex:row];
    } else if ([pickerView isEqual:self.timePicker]) {
        return [self.arrayTime objectAtIndex:row];
    }
    
    //если что то не считается вернуться точки
    return @"...";
}


//при выборе ячейки заполняем текст филд
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //если город
    if ([pickerView isEqual:self.cityPicker]) {
        [self cityPickerValueChanged:row];
        
        //если время бега просто заполняем текст филд
    } else if ([pickerView isEqual:self.timePicker]) {
        self.textFieldEstimatedTime.text = [self.arrayTime objectAtIndex:row];
    }
}



#pragma mark - Action Function
//кнопка далее
- (IBAction)buttonNextAction:(id)sender {
    
    //записываем те данные текст филдов что есть в наш синглтон
    for (int i = 0; i < self.textFieldCollection.count; i++) {
        UITextField * field = [self.textFieldCollection objectAtIndex:i];
        
        //если данные есть
        if (field.text.length > 0) {
            //это проперти инфо надо перезаписать
            [self saveMarathoneInfo:field.tag isNil:NO];
        //если данных нет, то проверим что в записанных данных
        } else {
            //этот проперти инфо надо обнулить
            [self saveMarathoneInfo:field.tag isNil:YES];
        }
    }
    
    //записываем данные даты
    [MarathonInfo sharedGlobalVariable].date = self.labelDateMarathone.text;
    
    //если выбран пол то записываем данные сегмент контрола
    if (self.segmentControlSexOutlet.selectedSegmentIndex >= 0) {
        [self saveMarathoneInfo:TFSex isNil:NO];
    }
    
}


//сегмент контрол
- (IBAction)segmentControlSexAction:(id)sender {
    
    //закрываем клавиатуру
    [self.view endEditing:YES];
    
    //меняем цвет сегмент контрола
    self.segmentControlSexOutlet.alpha = 1.0;
    self.isSexOk = YES;
    
    //меняем плейсхолдер сегмен контрола
    [RFAnimation animatedChangeColorText:[self.placeHolderTopCollection objectAtIndex:4]
                             BottomLabel:[self.placeHolderBottomCollection objectAtIndex:4]];
    
    //проверяем на правильное заполнение всех данных
    [self checkAllTextFieldForFilling];
}


//кнопка назад
- (IBAction)buttonBackAction:(id)sender {
    [self buttonNextAction:sender];
}



#pragma mark - Create Picker
//создаем пикер городов
- (void) createCityPicker {
    
    //подпись на делегата и датасорс
    self.cityPicker.delegate = self;
    self.cityPicker.dataSource = self;
    
    //массив городов
    self.arrayCity = [NSArray arrayWithObjects:@"Москва 24/09/2017", @"Санкт-Петербург 24/09/2017", @"Новосибирск 17/09/2017",
                      @"Екатеринбург 17/09/2017", @"Нижний Новгород 17/09/2017", @"Казань 17/09/2017",
                      @"Челябинск 10/09/2017", @"Омск 10/09/2017", @"Самара 10/09/2017", nil];

    //добавляем кнопку на пикет
    [self addButtonDoneOnPicker:0];
    
    //присваиваем пикер текстовому полю
    self.textFieldCity.inputView = self.cityPicker;
}


//создаем пикер даты
- (void) createDatePicker {
    
    //выбираем режим пикера
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    //максимальная дата -18 лет с сегодняшней даты
    self.datePicker.maximumDate = [self maximumDate];
    //назначаем таргет на изменение значения пикера
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    
    
    //добавляем кнопку на пикер
    [self addButtonDoneOnPicker:1];
    
    //присваиваем пикер текстовому полю
    self.textFieldBirthDate.inputView = self.datePicker;
}


//создаем пикер времени
- (void) createTimePicker {
    
    //подпись на делега и датасорс
    self.timePicker.delegate = self;
    self.timePicker.dataSource = self;
    
    
    //массив временных диапазонов
    self.arrayTime = [NSArray arrayWithObjects:@"< 2:23 Ч", @"< 3:00 Ч", @"< 3:15 Ч",
                      @"< 3:30 Ч", @"< 3:45 Ч", @"< 4:00 Ч",
                      @"< 4:15 Ч", @"< 4:30 Ч", @"больше 4:30 Ч", nil];
    
    //добавляем кнопку на пикер
    [self addButtonDoneOnPicker:2];
    
    //присваиваем пикер текстовому полю
    self.textFieldEstimatedTime.inputView = self.timePicker;
}


//добавляем кнопку на любой пикер
- (void) addButtonDoneOnPicker : (NSInteger) tag {
    
    //создаем бар
    UIToolbar * toolBar = [[UIToolbar alloc] init];
    [toolBar sizeToFit];
    
    //создаем копку тип ее и метод что будет выполняться по нажатию
    UIBarButtonItem * buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                 target:nil
                                                                                 action:@selector(anyPickerDonePressed)];
    //добавляем кнопку на бар
    [toolBar setItems:@[buttonDone] animated:NO];
    
    //возвращаем текст филд с которым работаем
    UITextField * field = [self.textFieldCollection objectAtIndex:tag];
    
    //добавляем бар к полю
    field.inputAccessoryView = toolBar;
}


//изменениие филда даты по прокрутке пикера даты
- (void) datePickerValueChanged {
    self.textFieldBirthDate.text = [self dateFormatForString:self.datePicker.date];
}


//изменение сити пикера по прокрутке пикера города
- (void) cityPickerValueChanged:(NSInteger)row {
    
    //парсим город и дату
    NSArray * infoMarathone = [self parsingCityDateMarathon:[self.arrayCity objectAtIndex:row]];
    self.textFieldCity.text = [infoMarathone objectAtIndex:0];
    
    
    //меняем плавно город и дату
    [UIView animateWithDuration:0.4f
                     animations:^{
                         self.labelCityMarathone.alpha = 0.f;
                         self.labelDateMarathone.alpha = 0.f;
                     }
                     completion:^(BOOL finished) {
                         self.labelCityMarathone.text = [infoMarathone objectAtIndex:0];
                         self.labelDateMarathone.text = [infoMarathone objectAtIndex:1];
                         
                         [UIView animateWithDuration:0.4f
                                          animations:^{
                                              self.labelCityMarathone.alpha = 1.f;
                                              self.labelDateMarathone.alpha = 1.f;
                                          }];
                     }];
}


//нажатие доне в любом пикере
- (void) anyPickerDonePressed {
    
    //если строка не пустая то переходим в следующий пустой филд или закрываем пикер
    if (self.actualField.text.length != 0) {
        [self jumpNextField:self.actualField];
    }
}


#pragma mark - Writing/Saving Marathone Info

//заполняем строки
- (void) writeMarathoneInfo {
    //запишем данные из информации
    //для этого сравниваем информацию и поле
    [self isEqualTextField:self.textFieldCity Property:[MarathonInfo sharedGlobalVariable].city];
    [self isEqualTextField:self.textFieldBirthDate Property:[MarathonInfo sharedGlobalVariable].birthDate];
    [self isEqualTextField:self.textFieldEstimatedTime Property:[MarathonInfo sharedGlobalVariable].estimatedTime];
    [self isEqualTextField:self.textFieldPhoneNumberRelation Property:[MarathonInfo sharedGlobalVariable].phoneNumberRelation];
    //сраввниваем информацию и лейбл
    [self isEqualLabel:self.labelCityMarathone Property:[MarathonInfo sharedGlobalVariable].city];
    [self isEqualLabel:self.labelDateMarathone Property:[MarathonInfo sharedGlobalVariable].date];
    //сравниваем информацию и контрол
    [self isEqualSegmentedControl:self.segmentControlSexOutlet Property:[MarathonInfo sharedGlobalVariable].sex];
}


//проверяем лейбл на необходимость заполнения
//сравниваем лейблы
- (void) isEqualLabel:(UILabel*)label Property:(id)property {
    
    //если проперти не пустой то запишем его
    if (property) {
        label.text = property;
    }
}

//сравниваем поля
- (void) isEqualTextField:(UITextField*)textField Property:(NSString*)property {
    
    //если проперти не пустой то запишем его
    if (property) {
        textField.text = property;
        [self writeIsOk:textField.tag isOk:YES];
    }
}

//сравниваем сегмент
- (void) isEqualSegmentedControl:(UISegmentedControl*)segmentedControl Property:(NSString*)property {
    
    //если проперти не пустой то запишем его
    if (property) {
        self.segmentControlSexOutlet.selectedSegmentIndex = property.intValue;
        [self writeIsOk:TFSex isOk:YES];
    }
}

//перезаписываем проперти для оределенного филда (тэг)
- (void) saveMarathoneInfo:(NSInteger)tag isNil:(BOOL)isNil {
    
    //если записываем нил
    if (isNil) {
        
        if (tag == TFCity) {
            [MarathonInfo sharedGlobalVariable].city = nil;
            
        } else if (tag == TFDate) {
            [MarathonInfo sharedGlobalVariable].birthDate = nil;
            
        } else if (tag == TFTime) {
            [MarathonInfo sharedGlobalVariable].estimatedTime = nil;
            
        } else if (tag == TFPhoneNumber) {
            [MarathonInfo sharedGlobalVariable].phoneNumberRelation = nil;
        }
        
    } else {
    
        if (tag == TFCity) {
            [MarathonInfo sharedGlobalVariable].city = self.textFieldCity.text;
        
        } else if (tag == TFDate) {
            [MarathonInfo sharedGlobalVariable].birthDate = self.textFieldBirthDate.text;
        
        } else if (tag == TFTime) {
            [MarathonInfo sharedGlobalVariable].estimatedTime = self.textFieldEstimatedTime.text;
        
        } else if (tag == TFPhoneNumber) {
            [MarathonInfo sharedGlobalVariable].phoneNumberRelation = self.textFieldPhoneNumberRelation.text;
        
        } else if (tag == TFSex) {
            [MarathonInfo sharedGlobalVariable].sex = [NSString stringWithFormat:@"%li", self.segmentControlSexOutlet.selectedSegmentIndex];
        }
        
    }
}


#pragma mark - Parsing Data
//метод вычисления даты 18 лет назад
- (NSDate *) maximumDate {
    
    //берем сегодняшнюю дату и раскладываем ее по int компонентам (год месяц день)
    NSDate * date = [NSDate date];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * componets = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    //создаем форматтер по которому будет собрана дата (день, месяц, год полный)
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    
    //создаем строку максимальной даты (сегодня минус 18 лет) и по это строке собираем дату
    NSString * maxDate = [NSString stringWithFormat:@"%li.%li.%li", componets.day, componets.month, componets.year - 18];
    NSDate * maximumDate = [formatter dateFromString:maxDate];
    
    return maximumDate;
}


//форматирование даты, возвращает текст
- (NSString *) dateFormatForString : (NSDate *) date {
    
    //создаем форматтер по которому будет собрана дата строкой (день, месяц письменно, год полный)
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMMM yyyy"];
    
    return [formatter stringFromDate:date];
}


//парсинг города и даты
- (NSArray *) parsingCityDateMarathon:(NSString *)string {
    
    //определяем локацию даты по пробелу, сканируем с конца
    NSInteger location = [string rangeOfString:@" " options:NSBackwardsSearch].location;
    
    //город определяем из строки до пробела
    NSString * city = [string substringToIndex:location];
    
    //дата
    //массив даты день/месяц/год берем после локации пробела и раскладываем в массив
    NSString * dateForParsing = [string substringFromIndex:location + 1];
    NSArray * arrayForParsing = [dateForParsing componentsSeparatedByString:@"/"];
    
    //форматтер что бы задать дату не как строку а как дату
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    
    //собираем строку даты
    NSString * stringDateMatathon = [NSString stringWithFormat:@"%@.%@.%@", [arrayForParsing objectAtIndex:0],
                                     [arrayForParsing objectAtIndex:1],
                                     [arrayForParsing objectAtIndex:2]];
    
    //строку переводим в дату и по форматтеру возвращаем строку
    NSDate * dateMatathon = [formatter dateFromString:stringDateMatathon];
    NSString * date = [self dateFormatForString:dateMatathon];
    
    //создаем массив города и даты
    NSArray * array = [[NSArray alloc] initWithObjects:city, date, nil];
    return array;
}




#pragma mark - Other Function
//определяем следующее не заполненное текстовое поле
- (UITextField *) nextTextField:(UITextField *)field {
    UITextField * nextField = nil;
    
    //берем следующий по порядку филд
    for (int i = (int)field.tag + 1; i < self.textFieldCollection.count; i++) {
        
        //проверяем у этого филда заполнение, если он пустой, определяем его
        if (![self checkIsOk:i] & !nextField) {
            nextField = [self.textFieldCollection objectAtIndex:i];
        }
    }
    
    //если следующих пустых полей не оказалось, проверим предыдущие по порядку
    for (int i = 0; i < field.tag; i++) {
        
        //проверяем у этого филда заполнение, если он пустой, определяем его
        if (![self checkIsOk:i] & !nextField) {
            nextField = [self.textFieldCollection objectAtIndex:i];
        }
    }
    
    //возвращаем или определенный филд или нил
    return nextField;
}


//прыгаем в следующее не заполненное поле или убираем клавиатуру
- (void) jumpNextField:(UITextField *)field {
    
    //определяем следующее пустое поле
    UITextField * nextField = [self nextTextField:field];
    
    //если такое есть переходим редактировать его
    if (nextField) {
        [nextField becomeFirstResponder];
        
        //если нет то закрываем редактирование
    } else {
        [self.view endEditing:YES];
    }
}


//если все поля заполнены по правилам то активируем кнопку, если нет, деактивируем
- (void) checkAllTextFieldForFilling {
    
    if (self.isCityOK & self.isBirthDateOK & self.isEstimatedTimeOK & self.isPhoneNumberOK & self.isSexOk) {
        [RFAnimation buttonActivated:self.buttonThirdViewShow];
    } else {
        [RFAnimation buttonDeactivated:self.buttonThirdViewShow];
    }
}


//задаем что происходит по тапу
- (void) tapEndEditing {
    
    //закрываем редактирование
    [self.view endEditing:YES];
    
    //проверяем заполение по правилам
    BOOL answer = [self validationTF:self.actualField ShowMessage:NO];
    
    //если правилу не соответствует но хоть что то введено то показываем предупреждение
    if (answer | (self.actualField.text.length == 0)) {
    } else {
        [RFAnimation animationWarningTextShow:[self.textFieldErrorCollection objectAtIndex:self.actualField.tag]];
    }
}



//проводит анализ текстового поля с показом ошибки и возвращение  да/нет
- (BOOL) validationTF:(UITextField *)textField ShowMessage:(BOOL)show {
    UILabel * label = nil;
    
    //если сообщение показываем то определим лейбл для этого сообщения
    if (show) {
        label = [self.textFieldErrorCollection objectAtIndex:textField.tag];
    }
    
    BOOL answer;
    
    //проверяем заполнение по правилу и переопределяем индикатор заполнения этого поля
    if (textField.tag < TFPhoneNumber) {
        [self writeIsOk:textField.tag isOk:[TFValidation isReturnNotEmpty:textField ErrorLabel:label]];
        
    } else if (textField.tag == TFPhoneNumber) {
        [self writeIsOk:textField.tag isOk:[TFValidation isReturnPhoneNumber:textField ErrorLabel:label]];
    }
    
    //переопределяем ответ по индикатору заполнения конкретного поля
    answer = [self checkIsOk:textField.tag];
    
    //возвращем YES/NO
    return answer;
}


//проводит анализ стекстового поля без возвращения результата
- (void) onlyValidationTF:(UITextField *)textField {
    
    UILabel * label = [self.textFieldErrorCollection objectAtIndex:textField.tag];
    
    //проверяем заполнение по правилу и переопределяем индикатор заполнения этого поля
    if (textField.tag < TFPhoneNumber) {
        [self writeIsOk:textField.tag isOk:[TFValidation isReturnNotEmpty:textField ErrorLabel:label]];
    } else if (textField.tag == TFPhoneNumber) {
        [self writeIsOk:textField.tag isOk:[TFValidation isReturnPhoneNumber:textField ErrorLabel:label]];
    }
    
}


//определяем индикатор заполения для определенного текстфилда
- (void) writeIsOk:(NSInteger)tag isOk:(BOOL)isOk {
    
    if (tag == TFCity) {
        self.isCityOK = isOk;
    } else if (tag == TFDate) {
        self.isBirthDateOK = isOk;
    } else if (tag == TFTime) {
        self.isEstimatedTimeOK = isOk;
    } else if (tag == TFPhoneNumber) {
        self.isPhoneNumberOK = isOk;
    } else if (tag == TFSex) {
        self.isSexOk = isOk;
    }
}


//проверяем значение индикатора заполения для определенного филда (тэг)
- (BOOL) checkIsOk:(NSInteger)tag {
    
    BOOL answer = NO;
    if ((tag == TFCity) & self.isCityOK) {
        answer = YES;
    } else if ((tag == TFDate) & self.isBirthDateOK) {
        answer = YES;
    } else if ((tag == TFTime) & self.isEstimatedTimeOK) {
        answer = YES;
    } else if ((tag == TFPhoneNumber) & self.isPhoneNumberOK) {
        answer = YES;
    } else if ((tag == TFSex) & self.isSexOk) {
        answer = YES;
    }
    
    return answer;
}






@end
