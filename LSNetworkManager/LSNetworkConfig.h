//
//  LSNetworkConfig.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/17.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSNetworkEnum.h"

@protocol LSRequestParamsProtocol;
@protocol LSServiceCreateProtocol;
@protocol LSErrorProtocol;

@interface LSNetworkConfig : NSObject

/** 是否使用缓存, 默认为NO*/
@property (nonatomic, assign) BOOL shouldCache;
/** 内存缓存时间, 默认300秒*/
@property (nonatomic, assign) NSTimeInterval cacheOutdate;
/** 缓存数量, 默认1000*/
@property (nonatomic, assign) NSUInteger cacheCountLimit;
/** 请求序列化类型, 默认为 JSON*/
@property (nonatomic, assign) LSRequestSerializerType requestSerializer;
/** 响应序列化类型, 默认为 JSON*/
@property (nonatomic, assign) LSResponseSerializerType responseSerializer;
/** 网络请求超时时间, 默认 30秒*/
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
/** 错误处理代理*/
@property (nonatomic, strong, nonnull) id<LSErrorProtocol> errorDelegate;
/** 请求地址服务返回代理*/
@property (nonatomic, strong, nonnull) id<LSServiceCreateProtocol> serviceCreate;
/** 请求参数添加, 可以添加公共参数, 不设置默认使用原始参数*/
@property (nonatomic, strong, nullable) id<LSRequestParamsProtocol> requestParams;
/**
 单例
 */
+ (instancetype)sharedInstance;

/**
 网络是否可用
 */
- (BOOL)isReachable;
@end
