//
//  LSURLResponse.m
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import "LSURLResponse.h"
#import "NSURLRequest+LSNetwork.h"
#import "NSObject+LSNetwork.h"
#import "LSNetworkConfig.h"

@interface LSURLResponse ()

@property (nonatomic, assign, readwrite) LSURLResponseStatus status;
@property (nonatomic, copy, readwrite) NSString *contentString;
@property (nonatomic, copy, readwrite) id content;
@property (nonatomic, copy, readwrite) NSURLRequest *request;
@property (nonatomic, assign, readwrite) NSInteger requestId;
@property (nonatomic, copy, readwrite) NSData *responseData;
@property (nonatomic, assign, readwrite) BOOL isCache;
@end

@implementation LSURLResponse

#pragma mark- life cycle

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData status:(LSURLResponseStatus)status
{
    if (self = [super init]) {
        self.contentString = responseString;
        if ([LSNetworkConfig sharedInstance].responseSerializer == LSResponseSerializerTypeJSON) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        } else {
            self.content = responseData;
        }
        self.requestId = requestId.integerValue;
        self.responseData = responseData;
        self.requestParams = request.ls_requestParams;
        self.isCache = NO;
    }
    return self;
}

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error
{
    if (self = [super init]) {
        self.contentString = [responseString ls_defaultValue:@""];
        self.status = [self responseStatusWithError:error];
        self.requestId = [requestId integerValue];
        self.request = request;
        self.responseData = responseData;
        self.requestParams = request.ls_requestParams;
        self.isCache = NO;
        
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        } else {
            self.content = nil;
        }
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data
{
    if (self = [super init]) {
        self.contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.status = [self responseStatusWithError:nil];
        self.requestId = 0;
        self.request = nil;
        self.responseData = [data copy];
        if ([LSNetworkConfig sharedInstance].responseSerializer == LSResponseSerializerTypeJSON) {
            self.content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        } else {
            self.content = data;
        }
        self.isCache = YES;
    }
    return self;
}

#pragma mark- private methods
/** 判断错误状态*/
- (LSURLResponseStatus)responseStatusWithError:(NSError *)error
{
    if (error) {
        LSURLResponseStatus result = LSURLResponseStatusNoNetwork;
        if (error.code == NSURLErrorTimedOut) {
            result = LSURLResponseStatusErrorTimeout;
        }
        return result;
    }
    return LSURLResponseStatusSuccess;
}
@end
