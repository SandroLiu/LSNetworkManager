//
//  NSURLRequest+LSNetwork.m
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import "NSURLRequest+LSNetwork.h"
#import <objc/runtime.h>

@implementation NSURLRequest (LSNetwork)

- (void)setLs_requestParams:(NSDictionary *)ls_requestParams
{
    objc_setAssociatedObject(self, @selector(ls_requestParams), ls_requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)ls_requestParams
{
    return objc_getAssociatedObject(self, _cmd);
}
@end
