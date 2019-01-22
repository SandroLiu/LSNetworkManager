//
//  LSServiceFactory.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSServiceCreateProtocol.h"
#import "LSService.h"

static NSString *const KLSServiceNetwork = @"KLSServiceNetwork";
@interface LSServiceFactory : NSObject<LSServiceCreateProtocol>

+ (instancetype)sharedInstance;

- (LSService<LSServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier;
@end

