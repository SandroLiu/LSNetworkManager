//
//  LSRequestParams.m
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/22.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import "LSRequestParams.h"
#import "LSAppContext.h"

#define APP_ID 10011
#define APP_KEY @"59525484fc33a8865b2eed1a4fe8ad3a"

// 签名key
static NSString *const kAppIdSignKey = @"appId";
static NSString *const kClientTimestampSignKey = @"clientTimestamp";
static NSString *const kClientGuidSignKey = @"clientGuid";
static NSString *const kClientVersiionSignKey = @"clientVersion";
static NSString *const kAppKeySignKey = @"key";

// 通用参数
static NSString *const kAppUsignKey = @"sign";
static NSString *const kAccessTokenSignKey = @"accessToken"; // 登录才传
static NSString *const kUserLanguageKey = @"language";

@implementation LSRequestParams

- (NSDictionary *)paramsWithOriginParams:(NSDictionary *)originParams methodName:(NSString *)methodName {
    NSDictionary *commonPrarms = [self commonParamsDictionary];
    NSMutableDictionary *finalParams = [NSMutableDictionary dictionary];
    [finalParams addEntriesFromDictionary:commonPrarms];
    [finalParams addEntriesFromDictionary:originParams];
    return finalParams;
}

- (NSDictionary *)commonParamsDictionary
{
    LSAppContext *appContext = [LSAppContext sharedInstance];
    NSInteger timestamp = [NSDate ls_getCurrentTimestamp];
    NSMutableDictionary *publicParamsDict = @{
                                              kAppIdSignKey : @(APP_ID),
                                              kClientTimestampSignKey : @(timestamp),
                                              
                                              kClientGuidSignKey : appContext.imsi,
                                              kClientVersiionSignKey : appContext.appVersion
                                              
                                              }.mutableCopy;
    
    NSArray *array = [[publicParamsDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        return [str1 compare:str2];
    }];
    
    NSMutableString *signStr = [NSMutableString string];
    for (int i = 0; i < array.count; i++) {
        [signStr appendFormat:@"%@=%@&", array[i], publicParamsDict[array[i]]];
    }
    
    [signStr appendFormat:@"%@=%@", kAppKeySignKey, APP_KEY];
    
    NSString *md5Str = signStr.ls_md5;
    [publicParamsDict setObject:md5Str forKey:kAppUsignKey]; // 添加签名
    [publicParamsDict setObject:@"zh" forKey:kUserLanguageKey]; // 添加用户语言
//    if (appContext.isLoggedIn) {
//        [publicParamsDict setObject:appContext.accessToken forKey:kAccessTokenSignKey]; // 添加token
//    }
    
    return publicParamsDict;
}
@end
