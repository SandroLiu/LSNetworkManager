//
//  LSAPIBaseManager.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSNetworkEnum.h"

@class LSUploadFileItem;
@class LSAPIBaseManager;
@class LSResponseError;
@class LSURLResponse;

/** 在调用成功之后的params字典里面，用这个key可以取出requestID*/
FOUNDATION_EXPORT NSString * const kLSAPIBaseManagerRequestID;


/** API 请求回调*/
@protocol LSAPIManagerCallBackDelegate <NSObject>
@required
/**
 *  网络请求成功回调
 *
 *  @param manager api
 */
- (void)managerCallAPIDidSuccess:(LSAPIBaseManager *)manager;
/**
 *  网络请求失败回调
 *
 *  @param manager  api
 */
- (void)managerCallAPIDidFailed:(LSAPIBaseManager *)manager loadDataFail:(LSResponseError *)error;;
@end

/** 获取数据后重新组装 API 数据, 需要 reformer 遵守*/
@protocol LSAPIManagerDataReformer <NSObject>
@required
/**
 *  重新组装数据, 由控制器或其他类提供重组数据的 reformer 对象
 *
 *  @param manager  api
 *  @param data     请求的数据
 *
 *  @return 组装后的数据对象
 */
- (id)manager:(LSAPIBaseManager *)manager reformData:(NSDictionary *)data;
@end

/** 验证器，用于验证 API 的返回或者调用 API 的参数是否正确*/
@protocol LSAPIManagerValidator <NSObject>
@required
/**
 *  校验请求参数
 *
 *  @param manager api
 *  @param data     请求参数
 *
 *  @return 是否符合规范
 */
- (BOOL)manager:(LSAPIBaseManager *)manager isCorrectParamsData:(NSDictionary *)data;
/**
 *  校验返回数据，包括数据格式，是否为空，登录失败等。
 *
 *  @param manager api
 *  @param data     返回数据
 *
 *  @return 是否成功
 */
- (BOOL)manager:(LSAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;
@end

/** 获取调用 API 所需的参数, 一般是 controller*/
@protocol LSAPIManagerParamSource <NSObject>
@required
- (NSDictionary *)paramsForApi:(LSAPIBaseManager *)manager;
@optional
- (NSArray<LSUploadFileItem *> *)uploadFileItemsForApi:(LSAPIBaseManager *)manager;
@end

/** LSAPIBaseManager的派生类实现*/
@protocol LSAPIManagerDelegate <NSObject>
@required
/** 请求地址*/
- (NSString *)methodName;
/** 服务类型*/
- (NSString *)serviceType;
/** 请求类型*/
- (LSAPIManagerRequestType)requestType;
/** 是否允许缓存*/
- (BOOL)shouldCache;
@optional
/** 清除数据*/
- (void)cleanData;
/** 请求数据前添加额外参数*/
- (NSDictionary *)reformParams:(NSDictionary *)params;
/** 加载数据*/
- (NSInteger)loadDataWithParams:(NSDictionary *)params;
/** 是否加载本地数据*/
- (BOOL)shouldLoadFromNative;
@end

/** 拦截器*/
@protocol LSAPIManagerInterceptor <NSObject>
@optional
/** 响应请求成功之前调用*/
- (BOOL)manager:(LSAPIBaseManager *)manager beforePerformSuccessWithResponse:(LSURLResponse *)response;
/** 响应请求成功之后调用*/
- (void)manager:(LSAPIBaseManager *)manager afterPerformSuccessWithResponse:(LSURLResponse *)response;

/** 响应请求失败之前调用*/
- (BOOL)manager:(LSAPIBaseManager *)manager beforePerformFailWithResponse:(LSResponseError *)responseError;
/** 响应请求失败之后调用*/
- (BOOL)manager:(LSAPIBaseManager *)manager afterPerformFailWithResponse:(LSResponseError *)responseError;

/** 是否允许调用请求*/
- (BOOL)manager:(LSAPIBaseManager *)manager shouldCallAPIWithParams:(NSDictionary *)params;
/** 调用请求后调用*/
- (BOOL)manager:(LSAPIBaseManager *)namager afterCallingAPIWithParams:(NSDictionary *)params;
@end


@interface LSAPIBaseManager : NSObject

/** 回调代理*/
@property (nonatomic, weak) id<LSAPIManagerCallBackDelegate>delegate;
/** 参数代理*/
@property (nonatomic, weak) id<LSAPIManagerParamSource> paramSource;
/** 校验代理*/
@property (nonatomic, weak) id<LSAPIManagerValidator> validator;
/** 子类需要实现*/
@property (nonatomic, weak) NSObject<LSAPIManagerDelegate> *child;
/** 拦截器*/
@property (nonatomic, weak) id<LSAPIManagerInterceptor> interceptor;

/** 错误信息，由子类通过 extension 重写提供*/
@property (nonatomic, copy, readonly) NSString * errorMessage;
@property (nonatomic, copy, readonly) NSString * retCode;
/** 错误类型*/
@property (nonatomic, assign, readonly) LSAPIManagerErrorType errorType;
/** 请求响应 */
@property (nonatomic, strong) LSURLResponse *response;
/** 网络是否通畅*/
@property (nonatomic, assign, readonly) BOOL isReachable;
/** 是否正在加载*/
@property (nonatomic, assign, readonly) BOOL isLoading;

/**
 *  通过 reformer 转换数据, 可以在 controller 内调用
 *
 *  @param reformer  转换器
 *
 *  @return 转换后的数据
 */
- (id)fetchDataWithReformer:(id<LSAPIManagerDataReformer>)reformer;

/**
 *  加载请求
 *
 *  @return 任务 id, 可通过这个 id 取消任务
 */
- (NSInteger)loadData;

/**
 *  取消所有请求
 */
- (void)cancelAllRequests;
/**
 *  取消某个 id 的请求
 *
 *  @param requestID 请求 id
 */
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

#pragma mark- method for interceptor
/**
 拦截器的功能可以由子类通过继承实现，也可以由其它对象实现,两种做法可以共存
 当两种情况共存的时候，子类重载的方法一定要调用一下super
 然后它们的调用顺序是BaseManager会先调用子类重载的实现，再调用外部interceptor的实现
 
 notes:
 正常情况下，拦截器是通过代理的方式实现的，因此可以不需要以下这些代码
 但是为了将来拓展方便，如果在调用拦截器之前manager又希望自己能够先做一些事情，所以这些方法还是需要能够被继承重载的
 所有重载的方法，都要调用一下super,这样才能保证外部interceptor能够被调到
 这就是decorate pattern
 
 */
/**
 *  拦截器方法, 响应成功回调前调用
 *
 *  @param response 响应
 *
 *  @return 是否允许回调请求成功
 */
- (BOOL)beforePerformSuccessWithResponse:(LSURLResponse *)response;
/**
 *  拦截器方法，响应成功回调后调用
 *
 *  @param response 响应
 */
- (void)afterPerformSuccessWithResponse:(LSURLResponse *)response;

/**
 *  拦截器方法，响应失败回调前调用
 *
 *  @param responseError 错误
 *
 *  @return 是否允许回调请求失败
 */
- (BOOL)beforePerformFailWithResponse:(LSResponseError *)responseError;
/**
 *  拦截器方法，响应失败回调前调用
 *
 *  @param responseError 错误
 */
- (void)afterPerformFailWithResponse:(LSResponseError *)responseError;

/**
 *  拦截器方法，请求之前调用
 *
 *  @param params 请求参数
 *
 *  @return 是否允许请求
 */
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params;
/**
 *  拦截器方法，请求之后调用
 *
 *  @param params 请求参数
 */
- (void)afterCallingAPIWithParams:(NSDictionary *)params;

#pragma mark- subClass overwrite
/**
 *  添加额外参数，子类可以在这个方法中添加额外参数
 *
 *  @param params 额外参数
 *
 *  @return 添加后的参数
 */
- (NSDictionary *)reformParams:(NSDictionary *)params;

/**
 *  清除数据, 包括缓存等
 */
- (void)cleanData;

/**
 *  是否使用缓存
 *
 *  @return  YES/NO
 */
- (BOOL)shouldCache;

/**
 *  请求成功后调用
 *
 *  @param response 响应
 */
- (void)successedOnCallingAPI:(LSURLResponse *)response;
/**
 *  请求失败后调用
 *
 *  @param responseError  错误
 */
- (void)failedOnCallingAPI:(LSResponseError *)responseError;
@end

