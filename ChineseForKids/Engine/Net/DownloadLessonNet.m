//
//  DownloadLessonNet.m
//  ChineseForKids
//
//  Created by yang on 13-12-18.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "DownloadLessonNet.h"
#import "JSONKit.h"
#import "HttpClient.h"
#import "DownloadLessonDAL.h"
#import "ResponseModel.h"
#import "LessonModel.h"
#import "DownloadModel.h"
#import "GameManager.h"
#import "CommonHelper.h"
#import "Constants.h"
#import "FileHelper.h"
#import "ZipArchive.h"
#import "GlobalDataHelper.h"

static DownloadLessonNet *instance = nil;

@interface DownloadLessonNet ()<ASIHTTPRequestDelegate>
{
    BOOL isDownloading;
    NSString *unzipPath;
}
@property (nonatomic, strong)HttpClient *requestClient;
@property(nonatomic, strong)NSOperationQueue *downlist;

@end

@implementation DownloadLessonNet
+ (DownloadLessonNet *)sharedInstance
{
    if(instance==nil)
    {
        instance = [[DownloadLessonNet alloc] init];
    }
    return instance;
}

- (void)dealloc
{
    self.requestClient=nil;
    self.downlist = nil;
    instance=nil;
}

- (id)getLessonDonwloadInfoWithUserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID
{
    DownloadLessonDAL *downloadDAL = [[DownloadLessonDAL alloc] init];
    NSString *params = [downloadDAL getDownloadLessonInfoURLParamsWithSN:SN_SEND_DOWNLOADLESSONDATA UserID:userID HumanID:humanID GroupID:groupID BookID:bookID TypeID:typeID LessonID:lessonID productID:productID()];
    
    self.requestClient = [[HttpClient alloc] init];
    id jsonData = [[self.requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kLessonUpdateData] params:params error:nil] objectFromJSONString];
    
    //NSLog(@"下载的api: %@", jsonData);
    
    ResponseModel *response = [[ResponseModel alloc] init];
    response.resultInfo = [downloadDAL parseDownloadLessonInfoByData:jsonData];
    response.error = downloadDAL.error;
    return response;
}

- (id)downloadLessonInfoWithUserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID error:(NSError *__autoreleasing *)error
{
    ResponseModel *response = (ResponseModel *)[self getLessonDonwloadInfoWithUserID:userID HumanID:humanID GroupID:groupID BookID:bookID TypeID:typeID LessonID:lessonID];
    if (response.error.code != 0)
    {
        return response;
    }
    
    if (error) *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
    
    if(![[FileHelper sharedInstance] isExistPath:kDownloadingPath])
    {
        if(![[FileHelper sharedInstance] createDirectory:kDownloadingPath])
        {
            DLog(@"创建课程音频临时文件夹失败!");
            if (error) *error = [NSError errorWithDomain:@"创建课程音频临时文件夹失败!" code:1 userInfo:nil];
            return response;
        }
    }
    
    if(![[FileHelper sharedInstance] isExistPath:kDownloadedPath])
    {
        if(![[FileHelper sharedInstance] createDirectory:kDownloadedPath])
        {
            DLog(@"创建课程音频文件夹失败!");
            if (error) *error = [NSError errorWithDomain:@"创建课程音频文件夹失败!" code:1 userInfo:nil];
            return response;
        }
    }
    
    if(self.downlist == nil)
    {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        self.downlist = queue;
        [self.downlist setMaxConcurrentOperationCount:2];
    }
    DownloadModel *downloadModel = (DownloadModel *)response.resultInfo;
    
    NSString *lessonPath = [NSString stringWithFormat:@"%@.zip", lessonID];
    NSString *lessonTmpPath = [NSString stringWithFormat:@"%@.temp", lessonID];
    NSString *destionPath=[kDownloadedPath stringByAppendingPathComponent:lessonPath];
    NSString *tmpPath = [kDownloadingPath stringByAppendingPathComponent:lessonTmpPath];
    
    NSURL *url = [NSURL URLWithString:downloadModel.dataURL];
    //NSLog(@"下载的url: %@", url);
    //创建请求
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;//代理
    [request setDownloadDestinationPath:destionPath];//下载路径
    [request setTemporaryFileDownloadPath:tmpPath];//缓存路径
    [request setAllowResumeForFileDownloads:YES];//断点续传
    request.downloadProgressDelegate = self;//下载进度代理
    [self.downlist addOperation:request];//添加到队列，队列启动后不需重新启动
    
    isDownloading = YES;
    // hold 住下载, 直到下载完成。
    while (isDownloading)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    DLog(@"code: %d ; message: %@", request.responseStatusCode, request.responseStatusMessage);
    if (request.responseStatusCode != 200)
    {
        if (error) *error = [NSError errorWithDomain:@"下载资源文件失败!" code:1 userInfo:nil];
    }
    else
    {
        // 解压文件
        [self unzipFileWithLessonID:lessonID error:error];
    }
    
    return response;
}

- (void)cancelRequest
{
    [self.requestClient cancelRequest];
    if (isDownloading)
    {
        //取消下载
        isDownloading = NO;
        [self.downlist cancelAllOperations];
    }
}

- (BOOL)isRequestCanceled
{
    return ([self.requestClient isRequestCanceled] || [self.downlist operationCount] <= 0);
}

#pragma mark - ASIHTTPRequest Delegate
- (void)requestStarted:(ASIHTTPRequest *)request
{
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    isDownloading = NO;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    isDownloading = NO;
}

#pragma mark - Zip Method
- (void)unzipFileWithLessonID:(NSString *)lessonID error:(NSError **)error
{
    //解压
    NSString *lessonPath = [NSString stringWithFormat:@"%@.zip", lessonID];
    NSString *destionPath=[kDownloadedPath stringByAppendingPathComponent:lessonPath];
    NSString *lessonSPath = [NSString stringWithFormat:@"%@", lessonID];
    
    unzipPath = [kDownloadedPath stringByAppendingPathComponent:lessonSPath];
    ZipArchive *unzip = [[ZipArchive alloc] init];
    if ([unzip UnzipOpenFile:destionPath])
    {
        BOOL result = [unzip UnzipFileTo:unzipPath overWrite:YES];
        
        if (result)
        {
            DLog(@"解压成功！");
            [self deleteDownloadFileWithLessonID:lessonID];
            // 做一个标记，看看该课的该游戏是否已经下载了。
            //NSString *bookID = [NSString stringWithFormat:@"%d", [GlobalDataHelper sharedManager].curBookID];
            NSString *typeID = [NSString stringWithFormat:@"%d", [GlobalDataHelper sharedManager].curTypeID];
            NSString *lessonPath = [NSString stringWithFormat:@"%@_%@.txt", typeID, lessonSPath];
            [lessonSPath writeToFile:[unzipPath stringByAppendingPathComponent:lessonPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
            //NSArray *arrAudio = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:[kDownloadedPath stringByAppendingPathComponent:lessonID]  error:nil];
            //NSLog(@"所有的音频文件: %@", arrAudio);
        }
        else
        {
            DLog(@"解压资源文件失败!");
            if (error) *error = [NSError errorWithDomain:@"解压资源文件失败!" code:1 userInfo:nil];
        }
        [unzip UnzipCloseFile];
    }
    else
    {
        DLog(@"打开待解压文件失败!");
        if (error) *error = [NSError errorWithDomain:@"打开待解压文件失败!" code:2 userInfo:nil];
    }
}

- (void)deleteDownloadFileWithLessonID:(NSString *)lessonID
{
    NSString *lessonPath = [NSString stringWithFormat:@"%@.zip", lessonID];
    NSString *lessonTmpPath = [NSString stringWithFormat:@"%@.temp", lessonID];
    NSString *destionPath = [kDownloadedPath stringByAppendingPathComponent:lessonPath];
    NSString *tmpPath = [kDownloadingPath stringByAppendingPathComponent:lessonTmpPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:destionPath])
    {
        if ([[NSFileManager defaultManager] removeItemAtPath:destionPath error:nil])
        {
            DLog(@"删除压缩文件成功!");
        }
        else
        {
            DLog(@"删除压缩文件失败");
        }
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:tmpPath])
    {
        if ([[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil])
        {
            DLog(@"删除临时文件成功!");
        }
        else
        {
            DLog(@"删除临时文件失败");
        }
    }
}

@end
