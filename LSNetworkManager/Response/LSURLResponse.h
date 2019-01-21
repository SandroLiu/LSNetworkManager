//
//  LSURLResponse.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSNetworkEnum.h"

/** 网络请求响应类*/
@interface LSURLResponse : NSObject

/** 请求状态*/
@property (nonatomic, assign, readonly) LSURLResponseStatus status;
/** 返回数据字符串*/
@property (nonatomic, copy, readonly) NSString * contentString;
/** 返回数据 json 解析后内容*/
@property (nonatomic, copy, readonly) id content;
/** 请求任务 id*/
@property (nonatomic, assign, readonly) NSInteger requestId;
/** 请求*/
@property (nonatomic, copy, readonly) NSURLRequest *request;
/** 响应数据, 未经过解析*/
@property (nonatomic, copy, readonly) NSData *responseData;
/** 请求参数*/
@property (nonatomic, copy) NSDictionary *requestParams;
/** 是不是缓存数据(是从网络获取的还是缓存获取的)*/
@property (nonatomic, assign, readonly) BOOL isCache;

/**
 *  请求成功初始化方法
 *
 *  @param responseString 返回字符串
 *  @param requestId      任务 id
 *  @param request        请求
 *  @param responseData   返回数据
 *  @param status         状态
 *
 *  @return  response
 */
- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData status:(LSURLResponseStatus)status;
/**
 *  网络请求失败使用这个方法
 *
 *  @param responseString 返回字符串
 *  @param requestId      任务 id
 *  @param request        请求
 *  @param responseData   响应数据
 *  @param error          错误
 *
 *  @return  response
 */
- (instancetype)initWithResponseString:(NSString *)responseString  requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error;
/**
 *  初始化方法，从缓存中获取时使用这个
 *
 *  @param data 缓存数据
 *
 *  @return  response
 */
- (instancetype)initWithData:(NSData *)data;
@end

