//
//  NSArray+LSNetwork.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LSNetwork)

/**
 字母排序之后形成的参数字符串
 */
- (NSString *)ls_paramsString;

/**
 数组变json
 */
- (NSString *)ls_jsonString;
@end
