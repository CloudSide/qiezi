//
//  VideoDownloader.m
//  Color
//
//  Created by chao han on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VideoDownloader.h"
#import "ASIHTTPRequest.h"

@implementation VideoDownloader

@synthesize fileUrl = _fileUrl , delegate = _delegate
, myQueue = _myQueue;

-(void)downloadFileByUrl:(NSString *)url fileName:(NSString *)fileName{
    self.fileUrl = url;
    
    self.myQueue = [[ASINetworkQueue alloc] init];
    [self.myQueue cancelAllOperations];
    [self.myQueue setDelegate:self];
    [self.myQueue setQueueDidFinishSelector:@selector(queueComplete:)];
    
    NSString * baseVideoPath=[ NSSearchPathForDirectoriesInDomains ( NSDocumentDirectory , NSUserDomainMask , YES ) objectAtIndex : 0 ];
    baseVideoPath=[baseVideoPath stringByAppendingPathComponent : @"video" ];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDirectory = NO;
    BOOL exists = [fileManager fileExistsAtPath:baseVideoPath isDirectory:&isDirectory];
    if (!exists || !isDirectory) {
        [fileManager removeItemAtPath:baseVideoPath error:nil];
        
        [fileManager createDirectoryAtPath:baseVideoPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSURL *downloadUrl = [NSURL URLWithString:url];
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :downloadUrl];
    [request setDownloadDestinationPath :[baseVideoPath stringByAppendingPathComponent : fileName ]];
    
    [self.myQueue addOperation:request];
    [self.myQueue go];
} 

-(void)queueComplete:(ASINetworkQueue *)queue
{
    [self.delegate downloadFileDidFinished];
}

-(void)dealloc
{
    [self.myQueue cancelAllOperations];
    self.myQueue = nil;
    
    self.fileUrl = nil;
    
    [super dealloc];
}

@end
