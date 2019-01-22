//
//  ViewController.m
//  LSNetworkManagerDemo
//
//  Created by 刘帅 on 2019/1/17.
//  Copyright © 2019年 刘帅. All rights reserved.
//

#import "ViewController.h"
#import "LSLoginAPIManager.h"

@interface ViewController ()<LSAPIManagerCallBackDelegate, LSAPIManagerDataReformer, LSAPIManagerParamSource>

/** */
@property (nonatomic, strong) LSLoginAPIManager *loginAPIManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _loginAPIManager = [LSLoginAPIManager new];
    _loginAPIManager.paramSource = self;
    _loginAPIManager.delegate = self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self login];
}

- (void)login {
    [_loginAPIManager loadData];
}

#pragma mark- LSAPIManagerParamSource
- (NSDictionary *)paramsForApi:(LSAPIBaseManager *)manager {
    return @{
             @"account":@"13464934582",
             @"password":@"123456".ls_md5
             };
}

#pragma mark- LSAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(LSAPIBaseManager *)manager {
    NSDictionary *data = [manager fetchDataWithReformer:self];
    NSLog(@"%@", data);
}

- (void)managerCallAPIDidFailed:(LSAPIBaseManager *)manager loadDataFail:(LSResponseError *)error {
    NSLog(@"error ----- %@", error.localizedDescription);
}
#pragma mark- LSAPIManagerDataReformer
- (id)manager:(LSAPIBaseManager *)manager reformData:(NSDictionary *)data {
    return data;
}
@end
