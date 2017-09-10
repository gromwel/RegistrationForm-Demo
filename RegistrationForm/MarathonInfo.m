//
//  MarathonInfo.m
//  RegistrationForm
//
//  Created by Clyde Barrow on 15.08.17.
//  Copyright © 2017 Pavel Podgornov. All rights reserved.
//

#import "MarathonInfo.h"

@implementation MarathonInfo

+ (instancetype) sharedGlobalVariable {
    
    static id _singletonInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singletonInstance = [[super allocWithZone:NULL] init];
    });
    
    
    return _singletonInstance;
}


+ (id) allocWithZone:(struct _NSZone *)zone {
    return [self sharedGlobalVariable];
}


- (id) copyWithZone:(NSZone *)zone {
    return self;
}


- (void) initWithInfo {
    _firstName = nil;
    _secondName = nil;
    _phoneNumber = nil;
    _eMail = nil;
    _city = nil;
    _birthDate = nil;
    _estimatedTime = nil;
    _phoneNumberRelation = nil;
    _date = nil;
}


@end
