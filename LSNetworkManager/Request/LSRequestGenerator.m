//
//  LSRequestGenerator.m
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/21.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import "LSRequestGenerator.h"
#import "LSServiceCreateProtocol.h"
#import "NSURLRequest+LSNetwork.h"
#import "LSUploadFileItem.h"
#import "LSServiceFactory.h"
#import <AFNetworking.h>
#import "LSLogger.h"

static LSRequestGenerator *_sharedInstance = nil;
@interface LSRequestGenerator ()
/** 请求解析器 */
@property (nonatomic, strong)  AFHTTPRequestSerializer *httpRequestSerializer;
@end

@implementation LSRequestGenerator

/**
 *  使用自己生成的 request 而不使用, 可以添加加密信息等
 *
 */

/** 指定初始化函数*/
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LSRequestGenerator alloc] init];
    });
    return _sharedInstance;
}

/** 生成 GET 请求*/
- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    LSService *service = [[LSServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", service.apiBaseUrl, methodName];
    //!!!: 可以设置自定义的请求头
    NSDictionary *finalRequestParams = [self appendCommonParamsForRequsetParams:requestParams methodName:methodName];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:finalRequestParams error:nil];
    request.ls_requestParams = requestParams;
    [LSLogger logDebugInfoWithRequest:request apiName:methodName service:service requestParams:requestParams httpMethod:methodName];
    return request;
}

/** 生成 POST 请求*/
- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    LSService *service = [[LSServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", service.apiBaseUrl, methodName];
    //!!!: 可以设置自定义的请求头
    NSDictionary *finalRequestParams = [self appendCommonParamsForRequsetParams:requestParams methodName:methodName];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:finalRequestParams error:nil];
    request.ls_requestParams = requestParams;
    [LSLogger logDebugInfoWithRequest:request apiName:methodName service:service requestParams:requestParams httpMethod:methodName];
    return request;
}

/** 上传数据请求 请求*/
- (NSURLRequest *)generateUploadRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName fileDatas:(NSArray<LSUploadFileItem *> *)fileDatas {
    LSService *service = [[LSServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", service.apiBaseUrl, methodName];
    //!!!: 可以设置自定义的请求头
    NSDictionary *finalRequestParams = [self appendCommonParamsForRequsetParams:requestParams methodName:methodName];
    
    NSMutableURLRequest *request = [self.httpRequestSerializer multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:finalRequestParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (LSUploadFileItem *item in fileDatas) {
            [formData appendPartWithFileData:item.fileData name:item.name fileName:item.fileName mimeType:item.mimeType];
        }
    } error:nil];
    request.ls_requestParams = requestParams;
    [LSLogger logDebugInfoWithRequest:request apiName:methodName service:service requestParams:requestParams httpMethod:methodName];
    return request;
}

#pragma mark- private method

- (NSDictionary *)appendCommonParamsForRequsetParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
//    if ([methodName isEqualToString:@"common/download"]) {
//        return requestParams;
//    }
//    NSDictionary *commonPrarms = [NCCommonParamsGenerator commonParamsDictionary];
//    NSMutableDictionary *finalParams = [NSMutableDictionary dictionary];
//    [finalParams addEntriesFromDictionary:commonPrarms];
//    [finalParams addEntriesFromDictionary:requestParams];
//
//    return [finalParams copy];
    
    //TODO: 添加具体参数拼接代码
    return nil;
}

#pragma mark- getters and setters
- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    // 使用 form 表单格式请求数据
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFJSONRequestSerializer serializer];
        //TODO: 设置超时时间
        _httpRequestSerializer.timeoutInterval = 20; //TODO: 改成可配置
    }
    return _httpRequestSerializer;
}
@end
