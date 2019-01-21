//
//  LSServiceProtocol.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol LSServiceProtocol;
@class LSService;

@protocol LSServiceCreateProtocol <NSObject>

- (LSService<LSServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier;
@end

