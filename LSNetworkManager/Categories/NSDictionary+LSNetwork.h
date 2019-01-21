//
//  NSDictionary+LSNetwork.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (LSNetwork)

/**
 拼接成参数字符串
 */
- (NSString *)ls_urlParamsStringSignature:(BOOL)isForSignature;

/**
 字典变json
 */
- (NSString *)ls_jsonString;

@end

