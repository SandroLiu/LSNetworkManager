//
//  LSNetworkService.m
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/22.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import "LSNetworkService.h"

@implementation LSNetworkService

/** 是不是生产环境*/
- (BOOL)isProduction
{
    return NO;
}
/** 生产环境 baseUrl*/
- (NSString *)productionBaseUrl
{
    return @"http://m.nanochap.cn/api";
}
/** 开发环境 baseUrl*/
- (NSString *)developBaseUrl
{
    return @"http://hzoffice.nanochap.cn:18080/nanochap/api";
    
}
@end
