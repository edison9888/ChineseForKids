//
//  HttpClient.m
//  PinyinGame
//
//  Created by yang on 13-11-16.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "HttpClient.h"

@interface HttpClient ()
{
    BOOL _isFinished;
}
@property (nonatomic, strong)ASIFormDataRequest *currentRequest;

- (NSString *)requestFromURL:(NSString *)url params:(NSString *)params method:(NSString *)method error:(NSError *)error;

@end

@implementation HttpClient
@synthesize currentRequest;
@synthesize isRequestCanceled = _isRequestCanceled;

- (NSString *)getRequestFromURL:(NSString *)url params:(NSString *)params error:(NSError *)error
{
    return [self requestFromURL:url params:params method:@"GET" error:error];
}

- (NSString *)postRequestFromURL:(NSString *)url params:(NSString *)params error:(NSError *)error
{
    return [self requestFromURL:url params:params method:@"POST" error:error];
}

- (NSString *)requestFromURL:(NSString *)url params:(NSString *)params method:(NSString *)method error:(NSError *)error
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DLog(@"%@: 请求的url: %@; 数据: %@", NSStringFromSelector(_cmd), url, params);
    if ([method isEqualToString:@"GET"])
    {
        // GET 请求的url为 url?params。
        url = [[url stringByAppendingString:@"?"] stringByAppendingString:params];
        self.currentRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    }
    else
    {
        
        self.currentRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        NSArray *arrParams = [params componentsSeparatedByString:@"&"];
        for (NSString *strParam in arrParams)
        {
            NSArray *arrParam = [strParam componentsSeparatedByString:@"="];
            NSString *key = [arrParam objectAtIndex:0];
            NSString *value = [arrParam objectAtIndex:1];
            
            [currentRequest addPostValue:value forKey:key];
        }
    }
    [currentRequest setDelegate:self];
    // 超时时间60秒
    [currentRequest setTimeOutSeconds:60.0f];
    // 请求类型
    [currentRequest setRequestMethod:method];
    // 异步请求
    [currentRequest startAsynchronous];

    // 因为是异步的请求方式, 如果要达到等同于同步请求的直接由该函数返回结果的效果, 那么必须在这里hold住主线程.以等待请求返回.
    while (!_isFinished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    DLog(@"返回的数据: %@", currentRequest.responseString);
    return currentRequest.responseString;
}

- (void)cancelRequest
{
    [self.currentRequest clearDelegatesAndCancel];
    _isFinished = YES;
}

- (BOOL)isRequestCanceled
{
    _isRequestCanceled = self.currentRequest.isCancelled;
    return _isRequestCanceled;
}

#pragma mark - ASIHttpRequest Delegate
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //NSLog(@"%@: 返回的数据: %@", NSStringFromSelector(_cmd), request.responseString);
    _isFinished = YES;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    //NSLog(@"%@: 返回的数据: %@", NSStringFromSelector(_cmd), request.responseString);
    // 处理网络请求的错误。
    
    _isFinished = YES;
    
    self.error = [NSError errorWithDomain:@"网络请求出错!" code:request.responseStatusCode userInfo:nil];
}

#pragma mark - Memeory Manager
- (void)dealloc
{
    [currentRequest clearDelegatesAndCancel];
    self.currentRequest = nil;
    self.error = nil;
}

@end
