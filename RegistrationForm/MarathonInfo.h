//
//  MarathonInfo.h
//  RegistrationForm
//
//  Created by Clyde Barrow on 15.08.17.
//  Copyright © 2017 Pavel Podgornov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarathonInfo : NSMutableDictionary

@property (nonatomic, strong) NSString * firstName;
@property (nonatomic, strong) NSString * secondName;
@property (nonatomic, strong) NSString * phoneNumber;
@property (nonatomic, strong) NSString * eMail;

@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * birthDate;
@property (nonatomic, strong) NSString * estimatedTime;
@property (nonatomic, strong) NSString * phoneNumberRelation;
@property (nonatomic, strong) NSString * date;

@property (nonatomic, strong) NSString * sex;

+ (instancetype) sharedGlobalVariable;

- (void) initWithInfo;

@end
