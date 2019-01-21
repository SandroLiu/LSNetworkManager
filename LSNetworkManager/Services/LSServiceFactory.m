//
//  LSServiceFactory.m
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import "LSServiceFactory.h"

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
- (LSService<LSServiceCreateProtocol> *)serviceWithIdentifier:(NSString *)identifier
{
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

- (LSService<LSServiceCreateProtocol> *)newServiceWithIdentifier:(NSString *)identifier
{
    //TODO: 添加具体网络服务
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
