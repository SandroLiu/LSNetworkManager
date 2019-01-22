//
//  LSAPIBaseManager.m
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import "LSAPIBaseManager.h"
#import <CoreTelephony/CTCellularData.h>
#import "LSServiceCreateProtocol.h"
#import "LSErrorProtocol.h"
#import "LSResponseError.h"
#import "LSNetworkConfig.h"
#import "LSURLResponse.h"
#import "LSApiProxy.h"
#import "LSService.h"
#import "LSLogger.h"
#import "LSCache.h"

#define AXCallAPI(REQUEST_METHOD, REQUEST_ID)                                                   \
{                                                                                               \
__weak typeof(self) weakSelf = self;                                                        \
REQUEST_ID = [[LSApiProxy sharedInstance] call##REQUEST_METHOD##WithParams:apiParams serviceIdentifier:self.child.serviceType methodName:self.child.methodName success:^(LSURLResponse *response) { \
__strong typeof(weakSelf) strongSelf = weakSelf;                                        \
[strongSelf successedOnCallingAPI:response];                                            \
} fail:^(LSResponseError *responseError) {                                                        \
__strong typeof(weakSelf) strongSelf = weakSelf;                                        \
[strongSelf failedOnCallingAPI:responseError];    \
}];                                                                                         \
[self.requestIdList addObject:@(REQUEST_ID)];                                               \
}

/** 在调用成功之后的params字典里面，用这个key可以取出requestID*/
NSString * const kLSAPIBaseManagerRequestID = @"kLSAPIBaseManagerRequestID";

@interface LSAPIBaseManager ()

/** 解析前的数据*/
@property (nonatomic, strong, readwrite) id fetchedRawData;
@property (nonatomic, assign, readwrite) BOOL isLoading;
/** 本地缓存是否为空*/
@property (nonatomic, assign) BOOL isNativeDataEmpty;
/** 错误信息*/
@property (nonatomic, copy, readwrite) NSString *errorMessage;
/** 错误类型*/
@property (nonatomic, readwrite) LSAPIManagerErrorType errorType;
/** 请求列表*/
@property (nonatomic, strong) NSMutableArray *requestIdList;
/** 缓存*/
@property (nonatomic, strong) LSCache *cache;

@end

@implementation LSAPIBaseManager

#pragma mark- life cycle

- (instancetype)init
{
    if (self = [super init]) {
        _delegate = nil;
        _validator = nil;
        _paramSource = nil;
        
        _errorMessage = nil;
        _errorType = LSAPIManagerErrorTypeDefault;
        if ([self conformsToProtocol:@protocol(LSAPIManagerDelegate)]) {
            self.child = (NSObject<LSAPIManagerDelegate> *)self;
        } else {
            NSException *exception = [[NSException alloc] init];
            @throw exception;
            
        }
    }
    return self;
}

- (void)dealloc
{
    [self cancelAllRequests];
    self.requestIdList = nil;
}

#pragma mark- public methods
/** 取消所有请求*/
- (void)cancelAllRequests
{
    [[LSApiProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

/** 取消某个 id 对应的请求*/
- (void)cancelRequestWithRequestId:(NSInteger)requestID
{
    [self removeRequestIdWithRequestID:requestID];
    [[LSApiProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

/** 传递数据给 reformer 进行解析*/
- (id)fetchDataWithReformer:(id<LSAPIManagerDataReformer>)reformer
{
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    } else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}

#pragma mark- calling api
/** 加载数据*/
- (NSInteger)loadData
{
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}

/**
 *  网络请求
 *
 *  @param params 请求参数
 *
 *  @return 请求任务 id
 */
- (NSInteger)loadDataWithParams:(NSDictionary *)params
{
    NSInteger requestId = 0;
    if (!params) {
        params = [NSDictionary dictionary];
    }
    // 添加额外参数
    NSDictionary *apiParams = [self reformParams:params];
    
    // 拦截方法，是否允许请求
    if ([self shouldCallAPIWithParams:params]) { // 允许请求
        // 请求参数校验
        if ([self.validator manager:self isCorrectParamsData:apiParams]) { // 参数校验成功
            // 是否先加载本地数据(磁盘数据), 然后会请求网络
            if ([self.child shouldLoadFromNative]) {
                [self loadDataFromNative];
            }
            // 是否使用内存缓存的数据, 如果使用内存缓存则不会请求网络
            if (self.shouldCache && [self hasCacheWithParams:apiParams]) {
                return 0;
            }
            // 网络请求
            // 判断是否有网络
            if (self.isReachable) { // 有网络
                self.isLoading = YES;
                // 根据请求类型发起请求
                switch (self.child.requestType) {
                    case LSAPIManagerRequestTypeGet:{
                        AXCallAPI(GET, requestId);
                        break;
                    }
                    case LSAPIManagerRequestTypePost:{
                        AXCallAPI(POST, requestId);
                        break;
                    }
                    case LSAPIManagerRequestTypeUpLoad: {
                        __weak typeof(self) weakSelf = self;
                        NSArray *files = [self.paramSource uploadFileItemsForApi:self];
                        requestId = [[LSApiProxy sharedInstance] uploadFileWithParams:apiParams serviceIdentifier:self.child.serviceType methodNmae:self.child.methodName fileDatas:files success:^(LSURLResponse *response) {
                            __strong typeof(weakSelf) strongSelf = weakSelf;
                            [strongSelf successedOnCallingAPI:response];
                            
                        } fail:^(LSResponseError *responseError) {
                            __strong typeof(weakSelf) strongSelf = weakSelf;
                            [strongSelf failedOnCallingAPI:responseError];
                        }];
                        [self.requestIdList addObject:@(requestId)];
                        break;
                    }
                }
                NSMutableDictionary *params = [apiParams mutableCopy];
                params[kLSAPIBaseManagerRequestID] = @(requestId);
                // 告诉调用请求完毕
                [self afterCallingAPIWithParams:params];
            } else { // 没有网络
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    LSResponseError *error = [self errorWithRequestId:requestId status:LSAPIManagerErrorTypeNoNetwork extra:nil];
                    [self failedOnCallingAPI:error];
                });
            }
        } else { // 参数校验失败
            LSResponseError *error = [self errorWithRequestId:requestId status:LSAPIManagerErrorTypeParamsError extra:self.errorMessage];
            [self failedOnCallingAPI:error];
        }
    }
    return 0;
}
#pragma api callbacks
/** 请求成功后调用*/
- (void)successedOnCallingAPI:(LSURLResponse *)response
{
    self.isLoading = NO;
    self.response = response;
    // 缓存数据到本地
    if ([self.child shouldLoadFromNative]) { // 是否允许加载本地数据
        if (response.isCache == NO) { // 是不是从缓存中获取的数据
            [[NSUserDefaults standardUserDefaults] setObject:response.responseData forKey:[self.child methodName]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    
    // 移除请求
    [self removeRequestIdWithRequestID:response.requestId];
    
    // 校验返回数据
    if ([self.validator manager:self isCorrectWithCallBackData:response.content]) { // 校验成功
        // 缓存数据到内存
        if (self.shouldCache && !response.isCache) {
            [self.cache saveCacheWithData:response.responseData serviceIdentifier:self.child.serviceType methodName:self.child.methodName requestParams:response.requestParams];
        }
        // 返回数据之前拦截修改
        if ([self beforePerformSuccessWithResponse:response]) { // 允许调用
            if ([self.child shouldLoadFromNative]) { // 是否允许从本地加载数据
                if (self.response.isCache == YES) {
                    [self.delegate managerCallAPIDidSuccess:self];
                }
                if (self.isNativeDataEmpty) {
                    [self.delegate managerCallAPIDidSuccess:self];
                }
            } else {
                [self.delegate managerCallAPIDidSuccess:self];
            }
        }
        // 返回数据后其他类可做处理
        [self afterPerformSuccessWithResponse:response];
    } else { // 数据错误
        LSResponseError *error = [self errorWithRequestId:response.requestId content:response.content extra:self.errorMessage];
        [self failedOnCallingAPI:error];
    }
}

/** 请求失败后调用*/
- (void)failedOnCallingAPI:(LSResponseError *)responseError {
    self.isLoading = NO;
    [self removeRequestIdWithRequestID:responseError.requestId];
    if ([self beforePerformFailWithResponse:responseError] ) {
        [self.delegate managerCallAPIDidFailed:self loadDataFail:responseError];
    }
    [self afterPerformFailWithResponse:responseError];
}
#pragma mark - method for interceptor
/** 是否允许调用 api 请求*/
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
    if ((id<LSAPIManagerInterceptor>)self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)]) {
        return [self.interceptor manager:self  shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}

/** 请求调用完毕*/
- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    if ((id<LSAPIManagerInterceptor>)self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithParams:)]) {
        [self.interceptor manager:self shouldCallAPIWithParams:params];
    }
}

/** 请求成功回调前拦截*/
- (BOOL)beforePerformSuccessWithResponse:(LSURLResponse *)response
{
    BOOL result = YES;
    self.errorType = LSAPIManagerErrorTypeSuccess;
    if ((id<LSAPIManagerInterceptor>)self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformSuccessWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
    return result;
}

/** 请求成功回调后调用*/
- (void)afterPerformSuccessWithResponse:(LSURLResponse *)response
{
    if ((id<LSAPIManagerInterceptor>)self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

/** 请求失败回调前拦截*/
- (BOOL)beforePerformFailWithResponse:(LSResponseError *)responseError
{
    BOOL result = YES;
    if ((id<LSAPIManagerInterceptor>)self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformFailWithResponse:responseError];
    }
    return result;
}

/** 请求失败回调后拦截*/
- (void)afterPerformFailWithResponse:(LSResponseError *)responseError
{
    if ((id<LSAPIManagerInterceptor>)self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:responseError];
    }
}
#pragma mark- method for child overwrite
/** 子类使用这个方法添加额外参数*/
- (NSDictionary *)reformParams:(NSDictionary *)params
{
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}

/** 是否使用内存缓存*/
- (BOOL)shouldCache
{
    return [LSNetworkConfig sharedInstance].shouldCache;
}

/** 清除数据*/
- (void)cleanData
{
    [self.cache clean];
    self.fetchedRawData = nil;
    self.errorMessage = nil;
    self.errorType = LSAPIManagerErrorTypeDefault;
}
#pragma mark- private methods
/** 从请求列表中移除 id*/
- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if (storedRequestId.integerValue == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove != nil) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

/** 加载本地数据*/
- (void)loadDataFromNative
{
    //TODO: 需要更换成自己的缓存方式
    NSString *methodName = self.child.methodName;
    // 获取本地数据
    NSDictionary *result = [(NSDictionary *)[NSUserDefaults standardUserDefaults] objectForKey:methodName];
    
    if (result) { // 回调
        self.isNativeDataEmpty = NO;
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            LSURLResponse *response = [[LSURLResponse alloc] initWithData:[NSJSONSerialization dataWithJSONObject:result options:0 error:nil]];
            [strongSelf successedOnCallingAPI:response];
        });
    } else {
        self.isNativeDataEmpty = YES;
    }
}

/** 检查有没有内存缓存数据*/
- (BOOL)hasCacheWithParams:(NSDictionary *)params
{
    NSString *serviceIdentifier = self.child.serviceType;
    NSString *methodName = self.child.methodName;
    NSData *result = [self.cache fetchCachedDataWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params];
    
    if (result == nil) {
        return NO;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        LSURLResponse *response = [[LSURLResponse alloc] initWithData:result];
        response.requestParams = params;
        LSService *service = [[LSNetworkConfig sharedInstance].serviceCreate serviceWithIdentifier:serviceIdentifier];
        [LSLogger logDebugInfoWithCachedResponse:response methodName:methodName serviceIdentifier:service];
        [strongSelf successedOnCallingAPI:response];
    });
    return YES;
}

#pragma mark- getters and setters
- (LSCache *)cache
{
    if (_cache == nil) {
        _cache = [LSCache sharedInstance];
    }
    return _cache;
}

- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

/** 是否有网络*/
- (BOOL)isReachable
{
    BOOL isReachability = [LSNetworkConfig sharedInstance].isReachable;
    if (!isReachability) {
        self.errorType = LSAPIManagerErrorTypeNoNetwork;
    }
    return isReachability;
}

/** 是否正在加载*/
- (BOOL)isLoading
{
    if (self.requestIdList.count == 0) {
        _isLoading = NO;
    }
    return _isLoading;
}

- (BOOL)shouldLoadFromNative
{
    return NO;
}


- (LSResponseError *)errorWithRequestId:(NSInteger)requestId
                                 status:(LSAPIManagerErrorType)status
                                  extra:(NSString *)extra {
    LSNetworkConfig *config = [LSNetworkConfig sharedInstance];
    if ([config.errorDelegate respondsToSelector:@selector(errorWithRequestId:status:extra:)]) {
        LSResponseError *error = [config.errorDelegate errorWithRequestId:requestId status:status extra:extra];
        if (error) {
            return error;
        }
    }
    return LSResponseError(extra, status, requestId);
}

- (LSResponseError *)errorWithRequestId:(NSInteger)requestId content:(id)content extra:(NSString *)extra {
    
    LSNetworkConfig *config = [LSNetworkConfig sharedInstance];
    if ([config.errorDelegate respondsToSelector:@selector(errorWithRequestId:content:extra:)]) {
        LSResponseError *error = [config.errorDelegate errorWithRequestId:requestId content:content extra:extra];
        if (error) {
            return error;
        }
    }
    return LSResponseError(extra, 0, requestId);
}
@end
