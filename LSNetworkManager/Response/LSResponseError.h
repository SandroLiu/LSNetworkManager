//
//  LSResponseError.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LSResponseError(MSG,CODE,ID) [LSResponseError errorWithMessage:MSG code:CODE requestId:ID]
@interface LSResponseError : NSError

@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly) NSString *message;
@property (nonatomic, strong) NSDictionary *response;

- (instancetype)initWithMessage:(NSString *)message
                           code:(NSInteger)code
                      requestId:(NSInteger)requestId;

+ (LSResponseError *)errorWithMessage:(NSString *)message
                                 code:(NSInteger)code
                            requestId:(NSInteger)requestId;
@end

