//
//  FTPWrapper.m
//  FtpTest
//
//  Created by mmc on 12-12-15.
//  Copyright (c) 2012年 mmc. All rights reserved.
//

#import "FTPWrapper.h"
#include "../ftpupload/ftpupload.h"

void uploadProgress(double ultotal, double ulnow);

@interface FTPWrapper()

@property (nonatomic, assign) BOOL bFinished;
@property (nonatomic, copy  ) NSString* remoteServerPath;
@property (nonatomic, copy  ) NSString* remoteFilePath;

- (void) asyncUploadFile:(NSString*)localFile;
- (void) progressCallBack:(NSNotification *)notification;
- (void) uploadDelegateCallBack:(NSNumber*)progressInfo;

@end

@implementation FTPWrapper

@synthesize bFinished = _bFinished;
@synthesize remoteServerPath = _remoteServerPath;
@synthesize remoteFilePath = _remoteFilePath;
@synthesize uploadDelegate = _uploadDelegate;

#pragma mark-
#pragma mark LifeCycle
- (id) init
{
    if ( self = [super init] )
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(progressCallBack:) name: @"uploadProgress" object:nil];
        
        [self resetUploadStatus];
    }
    
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"uploadProgress" object:nil];
    
    [super dealloc];
}

#pragma mark-
#pragma mark Private
- (void) asyncUploadFile:(NSString*)localFile
{    
    CURL *curlhandle=nil ;
    curl_global_init(CURL_GLOBAL_ALL);
    curlhandle = curl_easy_init();
    
    upload(curlhandle,[self.remoteFilePath UTF8String],[localFile UTF8String],0, 2);
    
    curl_easy_cleanup(curlhandle);
    curl_global_cleanup();
    curlhandle=nil;
}

- (void) uploadDelegateCallBack:(NSNumber*)progressInfo
{
    if ( [self.uploadDelegate conformsToProtocol:@protocol(IFtpUploadDelegate)] &&
        [self.uploadDelegate respondsToSelector:@selector(uploadFinished)])
    {
        if ( [[progressInfo stringValue] isEqualToString:@"1"] )
        {
            if ( !self.bFinished )
            {
                [self.uploadDelegate uploadFinished];
            }
            self.bFinished = YES;
        }
    }
    if ( [self.uploadDelegate conformsToProtocol:@protocol(IFtpUploadDelegate)] &&
        [self.uploadDelegate respondsToSelector:@selector(uploadProgress:)])
    {
        if ( ![[progressInfo stringValue] isEqualToString:@"nan"] && ![[progressInfo stringValue] isEqualToString:@"inf"] )
        {
            [self.uploadDelegate uploadProgress:[progressInfo floatValue]];
        }
    }
}

- (void) progressCallBack:(NSNotification *)notification
{
    NSNumber* uploadProgress = (NSNumber*)[notification object];
    
    [self performSelectorOnMainThread:@selector(uploadDelegateCallBack:) withObject:uploadProgress waitUntilDone:NO];
}

- (void) initRemoteFtpServer:(NSString*)serverIP port:(int)port
                   userName:(NSString*)userName passwd:(NSString*)passwd
{
    self.remoteServerPath = [NSString stringWithFormat:@"ftp://%@:%@@%@:%d",userName,passwd,serverIP,port];
}

#pragma mark-
#pragma mark Public
- (void) resetUploadStatus
{
    self.bFinished = NO;
}

- (void) setFtpUploadPath:(NSString*)filePath
{
    if ( 0 != [self.remoteServerPath length] )
    {
        self.remoteFilePath = [NSString stringWithFormat:@"%@%@",self.remoteServerPath,filePath];
    }
}

- (void) uploadFile:(NSString*)localFile
{
    [self performSelectorInBackground:@selector(asyncUploadFile:) withObject:localFile];
    
    if ( [self.uploadDelegate conformsToProtocol:@protocol(IFtpUploadDelegate)] &&
        [self.uploadDelegate respondsToSelector:@selector(uploadBegin)])
    {
        [self.uploadDelegate uploadBegin];
    }
}

- (void) stopUpload
{
    stopftpUpload();
    
    if ( [self.uploadDelegate conformsToProtocol:@protocol(IFtpUploadDelegate)] &&
        [self.uploadDelegate respondsToSelector:@selector(uploadStopped)])
    {
        [self.uploadDelegate uploadStopped];
    }
}

- (void) releaseUpload
{
    
}

/*
C 函数回调到这里，非OO化，不适合做业务处理
*/
#pragma mark-
#pragma mark C callBack
void uploadProgress(double ultotal, double ulnow)
{
    NSNumber* progress = [NSNumber numberWithFloat:ulnow/ultotal];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadProgress" object:progress];
}


@end