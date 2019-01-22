//
//  LSServiceFactory.m
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import "LSServiceFactory.h"
#import "LSNetworkService.h"

/** 基本请求服务*/

static LSServiceFactory *_sharedInstance = nil;
@interface LSServiceFactory ()

/** 存储service */
@property (nonatomic, strong) NSMutableDictionary *serviceStorage;
@end

@implementation LSServiceFactory


+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LSServiceFactory alloc] init];
    });
    return _sharedInstance;
}

#pragma mark- public methods
- (LSService<LSServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier
{
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

- (LSService<LSServiceProtocol> *)newServiceWithIdentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:KLSServiceNetwork]) {
        return [[LSNetworkService alloc] init];
    }
    return nil;
}

#pragma mark- getters and setters
- (NSMutableDictionary *)serviceStorage
{
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}
@end
