//
//  LSAppContext.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/22.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSAppContext : NSObject
// 设备信息
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSString *os;
@property (nonatomic, copy, readonly) NSString *rom;
@property (nonatomic, copy, readonly) NSString *ppi;
@property (nonatomic, copy, readonly) NSString *imei;
@property (nonatomic, copy, readonly) NSString *imsi;
@property (nonatomic, copy, readonly) NSString *deviceName;
// app 信息
/** app 版本*/
@property (nonatomic, copy, readonly) NSString *appVersion;
+ (instancetype)sharedInstance;
@end

