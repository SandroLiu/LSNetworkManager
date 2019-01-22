//
//  LSRequestParamsProotocol.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/22.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LSRequestParamsProtocol <NSObject>

@optional
- (NSDictionary *)paramsWithOriginParams:(NSDictionary *)originParams methodName:(NSString *)methodName;
@end

