//
//  LSApiProxy.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LSUploadFileItem;
@class LSResponseError;
@class LSURLResponse;

typedef void(^LSNetworkCallBack)(LSURLResponse *response);
typedef void(^LSNetworkFail)(LSResponseError *responseError);

/** 网络请求类，只负责发送请求和取消请求*/
@interface LSApiProxy : NSObject

/** 指定初始化方法*/
+ (instancetype)sharedInstance;

/**
 *  GET 请求
 *
 *  @param params           请求参数
 *  @param servieIdentifier 请求基础服务类标识符
 *  @param methodName       请求地址
 *  @param success          成功后回调
 *  @param fail             失败后回调
 *
 *  @return 请求标识
 */
- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(LSNetworkCallBack)success fail:(LSNetworkFail)fail;

/**
 *  post 请求
 *
 *  @param params           请求参数
 *  @param serviceIdentifier 服务标识
 *  @param methodName       请求地址
 *  @param success          成功后回调
 *  @param fail             失败后回调
 *
 *  @return 请求标识
 */
- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName success:(LSNetworkCallBack)success fail:(LSNetworkFail)fail;

/**
 *  上传数据请求
 *
 *  @param params           请求参数
 *  @param serviceIdentifier 服务标识
 *  @param methodName       请求地址
 *  @param fileDatas        上传数据参数
 *  @param success          成功后回调
 *  @param fail             失败后回调
 *
 *  @return 请求标识
 */
- (NSInteger)uploadFileWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier methodNmae:(NSString *)methodName fileDatas:(NSArray<LSUploadFileItem *> *)fileDatas success:(LSNetworkCallBack)success fail:(LSNetworkFail)fail;

/**
 *  发送请求
 *
 *  @param request 请求
 *  @param success 成功后回调
 *  @param fail    失败后回调
 *
 *  @return 请求标识
 */
- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(LSNetworkCallBack)success fail:(LSNetworkFail)fail;

/**
 *  根据请求标识取消请求
 *
 *  @param requestID 请求标识
 */
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
/**
 *  取消数组里的所有请求
 *
 *  @param requestIDList 请求标识数组
 */
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;
@end

