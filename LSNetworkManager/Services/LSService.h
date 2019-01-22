//
//  LSService.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 所有 LSService 的派生类都要符合这个 protocol*/
@protocol LSServiceProtocol <NSObject>

/**  是正式环境还是开发环境*/
@property (nonatomic, readonly) BOOL isProduction;
/** 开发环境 baseUrl*/
@property (nonatomic, readonly) NSString *developBaseUrl;
/** 生产环境 baseUrl*/
@property (nonatomic, readonly) NSString *productionBaseUrl;
@end

@interface LSService : NSObject

/** baseUrl */
@property (nonatomic, strong, readonly) NSString *apiBaseUrl;
/** 指向派生类，可以强制要求派生执行相关协议*/
@property (nonatomic, weak) id<LSServiceProtocol>child;
@end

