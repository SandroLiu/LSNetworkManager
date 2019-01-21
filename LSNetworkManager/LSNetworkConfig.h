//
//  LSNetworkConfig.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/17.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol LSErrorProtocol;

@interface LSNetworkConfig : NSObject

/** 是否使用缓存, 默认为NO*/
@property (nonatomic, assign) BOOL shouldCache;
/** 错误处理代理*/
@property (nonatomic, strong, nonnull) id<LSErrorProtocol> errorDelegate;

+ (instancetype)sharedInstance;

/**
 网络是否可用
 */
- (BOOL)isReachable;
@end
