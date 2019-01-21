//
//  LSRequestGenerator.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LSUploadFileItem;

/** request 生成类*/
@interface LSRequestGenerator : NSObject

/** 指定初始化方法*/
+ (instancetype)sharedInstance;

/**
 *  生成 GET 请求
 *
 *  @param serviceIdentifier 请求基本服务标识
 *  @param requestParams     请求参数
 *  @param methodName        请求地址
 *
 *  @return  request
 */
- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;

/**
 *  生成 POST 请求
 *
 *  @param serviceIdentifier 请求基本服务标识
 *  @param requestParams     请求参数
 *  @param methodName        请求地址
 *
 *  @return  request
 */
- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;

/**
 上传文件请求
 
 @param serviceIdentifier 请求基本服务标识
 @param requestParams 请求参数
 @param methodName 请求地址
 @param fileDatas 文件数据
 @return 请求
 */
- (NSURLRequest *)generateUploadRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName fileDatas:(NSArray<LSUploadFileItem *> *)fileDatas;
@end
