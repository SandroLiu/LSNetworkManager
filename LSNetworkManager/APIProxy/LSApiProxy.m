//
//  LSApiProxy.m
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import "LSApiProxy.h"
#import <AFNetworking/AFNetworking.h>
#import "LSRequestGenerator.h"
#import "LSErrorProtocol.h"
#import "LSResponseError.h"
#import "LSNetworkConfig.h"
#import "LSURLResponse.h"
#import "LSNetworkEnum.h"
#import "LSLogger.h"

static LSApiProxy *_sharedInstance = nil;
@interface LSApiProxy ()

/** 缓存请求 */
@property (nonatomic, strong)  NSMutableDictionary *dispatchTable;
/** AFN请求会话 */
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation LSApiProxy

#pragma mark- getters and setters

- (AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        //!!!: 可以在这里配置 sessionManager
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _sessionManager;
}

- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [NSMutableDictionary dictionary];
    }
    return _dispatchTable;
}

#pragma mark- life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LSApiProxy alloc] init];
    });
    return _sharedInstance;
}
#pragma mark- request method
/** GET 请求*/
- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(LSNetworkCallBack)success fail:(LSNetworkFail)fail
{
    // 生成 request
    NSURLRequest *request = [[LSRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    // 发送请求
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

/** POST 请求*/
- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(LSNetworkCallBack)success fail:(LSNetworkFail)fail
{
    // 生成 request
    NSURLRequest *request = [[LSRequestGenerator sharedInstance] generatePOSTRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    // 发送请求
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

/** 发送请求*/
- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(LSNetworkCallBack)success fail:(LSNetworkFail)fail
{
    __block NSURLSessionDataTask *dataTask = nil;
    __weak LSApiProxy *weakSelf = self;
    dataTask = [self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        // 移除任务
        NSNumber *requestID = @(dataTask.taskIdentifier);
        [self.dispatchTable removeObjectForKey:requestID];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        // 接收数据
        NSData *responseData = responseObject;
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        if (error) { // 请求失败
            [LSLogger logDebugInfoWithResponse:httpResponse responseString:responseString request:request error:error];
            LSResponseError *responseError = [weakSelf responseErrorWithCode:error.code requestID:requestID];
            fail?fail(responseError):nil;
            
        } else { // 请求成功
            [LSLogger logDebugInfoWithResponse:httpResponse responseString:responseString request:request error:nil];
            LSURLResponse *response = [[LSURLResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData status:LSURLResponseStatusSuccess];
            success ? success(response) : nil;
        }
    }];
    NSNumber *requestId = @(dataTask.taskIdentifier);
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    return requestId;
}

/// 上传文件
- (NSInteger)uploadFileWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier methodNmae:(NSString *)methodName fileDatas:(NSArray<LSUploadFileItem *> *)fileDatas success:(LSNetworkCallBack)success fail:(LSNetworkFail)fail {
    
    NSURLRequest *request = [[LSRequestGenerator sharedInstance] generateUploadRequestWithServiceIdentifier:serviceIdentifier requestParams:params methodName:methodName fileDatas:fileDatas];
    __block NSURLSessionDataTask *dataTask = nil;
    __weak LSApiProxy *weakSelf = self;
    dataTask = [self.sessionManager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        // 移除任务
        NSNumber *requestID = @(dataTask.taskIdentifier);
        [self.dispatchTable removeObjectForKey:requestID];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        // 接收数据
        NSData *responseData = responseObject;
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        if (error) { // 请求失败
            [LSLogger logDebugInfoWithResponse:httpResponse responseString:responseString request:request error:error];
            LSResponseError *responseError = [weakSelf responseErrorWithCode:error.code requestID:requestID];
            fail?fail(responseError):nil;
        } else { // 请求成功
            [LSLogger logDebugInfoWithResponse:httpResponse responseString:responseString request:request error:nil];
            LSURLResponse *response = [[LSURLResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData status:LSURLResponseStatusSuccess];
            success ? success(response) : nil;
        }
    }];
    NSNumber *requestId = @(dataTask.taskIdentifier);
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    return [requestId integerValue];
}


/** 根据 id 取消请求*/
- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    NSURLSessionDataTask *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

#pragma mark- private method
- (LSResponseError *)responseErrorWithCode:(NSInteger)code requestID:(NSNumber *)requestID {
    LSNetworkConfig *config = [LSNetworkConfig sharedInstance];

    if ([config.errorDelegate respondsToSelector:@selector(errorWithRequestId:status:extra:)]){
        
        LSURLResponseStatus status = 0;
        if (code == NSURLErrorCancelled) {
            status = LSURLResponseStatusCancel;
        } else if (code == NSURLErrorTimedOut) {
            status = LSURLResponseStatusErrorTimeout;
        } else {
            status = LSURLResponseStatusErrorUnknown;
        }
        LSResponseError *error =  [config.errorDelegate errorWithRequestId:[requestID integerValue] status:status extra:nil];
        if (error) {
            return error;
        }
    }
    if (code == NSURLErrorCancelled) {
        // 若取消则不发送任何消息
        return LSResponseError(@"请求取消",LSURLResponseStatusCancel,[requestID integerValue]);
    } else if (code == NSURLErrorTimedOut) {
        return LSResponseError(@"请求超时",LSURLResponseStatusErrorTimeout,[requestID integerValue]);
    } else {
        return LSResponseError(@"未知错误",LSURLResponseStatusErrorUnknown,[requestID integerValue]);
    }
}
@end
