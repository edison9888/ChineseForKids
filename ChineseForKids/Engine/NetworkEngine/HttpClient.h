//
//  HttpClient.h
//  PinyinGame
//
//  Created by yang on 13-11-16.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface HttpClient : NSObject<ASIHTTPRequestDelegate>

@property (nonatomic, readonly)NSInteger statuCode;
@property (nonatomic, readonly)BOOL isRequestCanceled;

@property (nonatomic, strong)NSError *error;

- (NSString *)getRequestFromURL:(NSString *)url params:(NSString *)params error:(NSError *)error;
- (NSString *)postRequestFromURL:(NSString *)url params:(NSString *)params error:(NSError *)error;

- (void)cancelRequest;

@end
