//
//  LSNetworkConfig.m
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/17.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import "LSNetworkConfig.h"
#import <AFNetworkReachabilityManager.h>

static LSNetworkConfig *_sharedInstance = nil;
@interface LSNetworkConfig ()
/** 网络监听 */
@property (nonatomic, strong)  AFNetworkReachabilityManager *reachabilityManager;
@end

@implementation LSNetworkConfig

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LSNetworkConfig alloc] init];
        _sharedInstance.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [_sharedInstance.reachabilityManager startMonitoring];
    });
    return _sharedInstance;
}

/** 网络是否可用*/
- (BOOL)isReachable
{
    if (_reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    }
    return _reachabilityManager.reachable;
}
@end
