//
//  NSMutableString+LSNetwork.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (LSNetwork)

/**
 拼接请求内容
 */
- (void)ls_appendURLRequest:(NSURLRequest *)request;
@end
