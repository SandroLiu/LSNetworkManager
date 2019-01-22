//
//  LSAppContext.m
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/22.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import "LSAppContext.h"

static LSAppContext *_sharedInstance = nil;
@implementation LSAppContext

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LSAppContext alloc] init];
    });
    return _sharedInstance;
}

/** 软件版本*/
- (NSString *)appVersion
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}
#pragma mark- 设备信息
- (NSString *)type
{
    return @"iOS";
}

- (NSString *)os
{
    return [[UIDevice currentDevice] systemVersion];
}

- (NSString *)rom
{
    return [[UIDevice currentDevice] model];
}

- (NSString *)imei
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (NSString *)imsi
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (NSString *)deviceName
{
    return [[UIDevice currentDevice] name];
}
@end
