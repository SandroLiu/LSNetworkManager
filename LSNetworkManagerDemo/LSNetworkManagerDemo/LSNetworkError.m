//
//  LSNetworkError.m
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/22.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import "LSNetworkError.h"
#import "LSResponseError.h"
#import "LSNetworkEnum.h"

@implementation LSNetworkError

- (LSResponseError *)errorWithRequestId:(NSInteger)requestId status:(NSUInteger)status extra:(NSString *)extra {
    return LSResponseError(@"网络请求错误", status, requestId);
}

- (LSResponseError *)errorWithRequestId:(NSInteger)requestId content:(id)content extra:(NSString *)extra {
    NSInteger status = [content[@"code"] integerValue];
    NSString *msg = content[@"msg"];
    return LSResponseError(msg, status, requestId);
}
@end
