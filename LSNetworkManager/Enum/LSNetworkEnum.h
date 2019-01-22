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

/**
 *  网络请求返回错误类型，包括数据错误等
 */
typedef NS_ENUM(NSUInteger, LSAPIManagerErrorType) {
    /**
     *  没有产生过 API 请求即网络请求失败，默认状态
     */
    LSAPIManagerErrorTypeDefault = -2,
    /**
     *  请求超时
     */
    LSAPIManagerErrorTypeTimeout = 101,
    /**
     *  网络不通。在调用 API 之前会判断一下当前网络是否通畅。
     */
    LSAPIManagerErrorTypeNoNetwork = 102,
    /**
     *   API 请求成功且返回数据正确，此时 manager 的数据可以直接拿来使用
     */
    LSAPIManagerErrorTypeSuccess = 200,
    /**
     *   API 请求成功但返回数据不正确。如果回调数据验证函数返回值为 NO，manager 的状态就是这个
     */
    LSAPIManagerErrorTypeNoContent = 201,
    /**
     *  参数错误，此时 manager 不会调用 API，因为参数验证是在调用 API 之前做的。
     */
    LSAPIManagerErrorTypeParamsError = 400
};

/**
 *  网络请求类型
 */
typedef NS_ENUM(NSUInteger, LSAPIManagerRequestType) {
    /**
     *  GET 请求
     */
    LSAPIManagerRequestTypeGet,
    /**
     *  POST 请求
     */
    LSAPIManagerRequestTypePost,
    /**
     * 上传文件请求
     */
    LSAPIManagerRequestTypeUpLoad
};

/**
 请求序列化类型
 */
typedef NS_ENUM(NSInteger, LSRequestSerializerType) {
    /** 表单格式*/
    LSRequestSerializerTypeHTTP = 0,
    /** JSON格式*/
    LSRequestSerializerTypeJSON,
};

/**
 响应序列化类型
 */
typedef NS_ENUM(NSInteger, LSResponseSerializerType) {
    /** NSData type*/
    LSResponseSerializerTypeHTTP,
    /** JSON对象*/
    LSResponseSerializerTypeJSON,
};
#endif /* LSNetworkEnum_h */
