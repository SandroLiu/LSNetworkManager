//
//  LSDemoBaseManager.m
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/22.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import "LSDemoBaseManager.h"
#import "LSServiceFactory.h"

@interface LSDemoBaseManager()<LSAPIManagerValidator, LSAPIManagerDelegate>
@property(nonatomic, copy, readwrite) NSString *errorMessage;
@property(nonatomic, copy, readwrite) NSString *retCode;
@end

@implementation LSDemoBaseManager
@synthesize errorMessage = _errorMessage;
@synthesize retCode = _retCode;

#pragma mark- life cycle
- (instancetype)init
{
    if (self = [super init]) {
        self.validator = self;
    }
    return self;
}

#pragma mark- LSAPIManagerDelegate
- (NSString *)methodName
{
    return @"";
}

- (NSString *)serviceType
{
    return KLSServiceNetwork;
}

- (LSAPIManagerRequestType)requestType
{
    return LSAPIManagerRequestTypePost;
}

- (BOOL)shouldCache
{
    return NO;
}

#pragma mark- NCAPIManagerValidator
/** 请求参数是否正确*/
- (BOOL)manager:(LSAPIBaseManager *)manager isCorrectParamsData:(NSDictionary *)data
{
    return YES;
}

/** 返回数据校验*/
- (BOOL)manager:(LSAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    NSInteger code = [data[@"code"] integerValue];
    self.retCode = [NSString stringWithFormat:@"%ld", (long)code];
    if (code == 1000) {
        return YES;
    }
    self.errorMessage = data[@"msg"];
    return NO;
}

@end

