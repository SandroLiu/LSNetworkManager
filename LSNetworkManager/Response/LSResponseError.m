//
//  LSResponseError.m
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import "LSResponseError.h"

static NSString *const LSNetworkingResponseErrorKey = @"com.response.error.domain";

@implementation LSResponseError

- (instancetype)initWithMessage:(NSString *)message
                           code:(NSInteger)code
                      requestId:(NSInteger)requestId {
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message
                                                         forKey:NSLocalizedDescriptionKey];
    self = [super initWithDomain:LSNetworkingResponseErrorKey code:code userInfo:userInfo];
    if (self) {
        _requestId = requestId;
    }
    return self;
}


+ (LSResponseError *)errorWithMessage:(NSString *)message
                                 code:(NSInteger)code
                            requestId:(NSInteger)requestId {
    return [[self alloc] initWithMessage:message code:code requestId:requestId];
}
#pragma mark -
- (NSString *)message {
    return [self localizedDescription];
}
#pragma mark -
- (NSString *)description {
    return [NSString stringWithFormat:@"[%ld]code:%ld, message:%@",(long)self.requestId,(long)self.code,self.message];
}
@end
