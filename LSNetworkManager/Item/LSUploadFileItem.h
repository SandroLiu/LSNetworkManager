//
//  LSUploadFileItem.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LSUploadFileItem : NSObject

/** data*/
@property (nonatomic, copy) NSData *fileData;
/** name*/
@property (nonatomic, copy) NSString *name;
/** file name*/
@property (nonatomic, copy) NSString *fileName;
/** mimeType*/
@property (nonatomic, copy) NSString *mimeType;
@end

