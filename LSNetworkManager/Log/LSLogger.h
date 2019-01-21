//
//  LSLogger.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LSURLResponse;
@class LSService;

@interface LSLogger : NSObject

/**
 *  打印请求信息
 *
 *  @param request       请求
 *  @param apiName       请求 api
 *  @param service       请求基础
 *  @param requestParams 请求参数
 *  @param httpMethod    请求地址
 */
+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName service:(LSService *)service requestParams:(id)requestParams httpMethod:(NSString *)httpMethod;

/**
 *  打印响应信息
 *
 *  @param response      响应
 *  @param responseString 响应字符串
 *  @param request       请求
 *  @param error         错误
 */
+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response responseString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error;

/**
 *  打印缓存响应
 *
 *  @param response   响应
 *  @param methodName 请求地址
 *  @param service    请求基础
 */
+ (void)logDebugInfoWithCachedResponse:(LSURLResponse *)response methodName:(NSString *)methodName serviceIdentifier:(LSService *)service;
@end

