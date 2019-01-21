//
//  NSObject+LSNetwork.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (LSNetwork)

/**
 *  判断是否使用默认数据
 *
 *  @param defaultData 默认数据
 *
 *  @return 如果 self 为空使用默认数据
 */
- (id)ls_defaultValue:(id)defaultData;

/**
 是否是NSNull、空字符串、空数组、空字典
 */
- (BOOL)ls_isEmptyObject;
@end


