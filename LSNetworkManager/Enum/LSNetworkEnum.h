//
//  LSNetworkEnum.h
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#ifndef LSNetworkEnum_h
#define LSNetworkEnum_h

/**
 *  网络请求状态，作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的APIManager来决定。
 */
typedef NS_ENUM(NSUInteger, LSURLResponseStatus) {
    /** 请求成功*/
    LSURLResponseStatusSuccess,
    /** 取消请求*/
    LSURLResponseStatusCancel,
    /** 请求超时*/
    LSURLResponseStatusErrorTimeout,
    /** 无网络*/
    LSURLResponseStatusNoNetwork,
    /** 未知*/
    LSURLResponseStatusErrorUnknown
};
#endif /* LSNetworkEnum_h */
