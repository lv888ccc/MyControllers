//
//  FTPWrapper.h
//  FtpTest
//
//  Created by mmc on 12-12-15.
//  Copyright (c) 2012年 mmc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFtpUploadDelegate.h"

@interface FTPWrapper : NSObject

@property (nonatomic, assign) id<IFtpUploadDelegate> uploadDelegate;

- (void) resetUploadStatus;
- (void) initRemoteFtpServer:(NSString*)serverIP port:(int)port userName:(NSString*)userName passwd:(NSString*)passwd;
- (void) setFtpUploadPath:(NSString*)filePath;
- (void) uploadFile:(NSString*)localFile;
- (void) stopUpload;
- (void) releaseUpload;

@end