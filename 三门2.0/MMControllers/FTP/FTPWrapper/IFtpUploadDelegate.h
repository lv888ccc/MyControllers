//
//  IFtpUploadDelegate.h
//  FtpTest
//
//  Created by mmc on 12-12-16.
//  Copyright (c) 2012年 mmc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IFtpUploadDelegate <NSObject>

- (void) uploadBegin;
- (void) uploadProgress:(float)progress;
- (void) uploadStopped;
- (void) uploadFinished;

@end