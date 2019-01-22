//
//  LSErrorProtocol.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LSResponseError;

@protocol LSErrorProtocol <NSObject>

@optional
/**
 网络请求错误，包括参数校验
 
 @param requestId 请求ID
 @param status 网络请求错误类型
 @param extra 额外信息
 @return 错误信息
 */
- (LSResponseError *_Nonnull)errorWithRequestId:(NSInteger)requestId status:(NSUInteger)status extra:(NSString *)extra;

/**
 请求返回校验不通过错误
 
 @param requestId 请求ID
 @param content 请求内容
 @param extra 额外信息
 @return 错误信息
 */
- (LSResponseError *_Nonnull)errorWithRequestId:(NSInteger)requestId content:(id)content extra:(NSString *)extra;
@end

