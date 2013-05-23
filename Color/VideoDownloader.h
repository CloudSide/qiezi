//
//  VideoDownloader.h
//  Color
//
//  Created by chao han on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"

@protocol VideoDownloaderDelegate;
@interface VideoDownloader : NSObject <ASIProgressDelegate>

@property (nonatomic,retain) ASINetworkQueue *myQueue;
@property (nonatomic,retain) NSString *fileUrl;
@property (nonatomic,assign) id<VideoDownloaderDelegate> delegate;

-(void)downloadFileByUrl:(NSString *)url fileName:(NSString *)fileName;

@end

@protocol VideoDownloaderDelegate <NSObject>

-(void)downloadFileDidFinished;

@end
