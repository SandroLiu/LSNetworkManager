//
//  LSService.m
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import "LSService.h"

@implementation LSService

- (instancetype)init
{
    if (self = [super init]) {
        // 要求子类遵循 NCServiceProtocol 协议
        if ([self conformsToProtocol:@protocol(LSServiceProtocol)]) {
            self.child = (id<LSServiceProtocol>)self;
        }
    }
    return self;
}

#pragma mark- getters and setters

- (NSString *)apiBaseUrl
{
    return self.child.isProduction ? self.child.productionBaseUrl : self.child.developBaseUrl;
}
@end
