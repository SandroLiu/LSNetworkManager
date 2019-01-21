//
//  LSServiceFactory.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSService.h"

@interface LSServiceFactory : NSObject

+ (instancetype)sharedInstance;

- (LSService<LSServiceCreateProtocol> *)serviceWithIdentifier:(NSString *)identifier;
@end

