//
//  UploadMediaService.m
//  Color
//  Created by chao han on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UploadMediaService.h"
#import "PendingUploadDao.h"
#import "PendingUploadTaskDTO.h"

@implementation UploadMediaService
@synthesize operationQueue , interfaceHolder = _interfaceHolder;
- (id)init
{
    self = [super init];
    if (self) {
        self.operationQueue = [[[NSOperationQueue alloc] init] autorelease];
        [self.operationQueue setMaxConcurrentOperationCount:2];
        
        self.interfaceHolder = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)addOperationAfterDelay:(NSNumber *)taskId
{
    [self addOperation:[taskId longLongValue]];
}

- (void)addOperation:(long long int)taskId
{
    PendingUploadDao *dao = [[PendingUploadDao alloc] init];
    PendingUploadTaskDTO *dto = [[dao getPendingUploadTaskDTOById:taskId] retain];
    
    if (dto) {
        PendingUploadDao *dao = [[PendingUploadDao alloc] init];
        [dao updatePendingStateById:dto.pid state:1];
        [dao release];
        
        NSInvocationOperation* theOp = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(doUploadTask:) object:dto];
        
        [self.operationQueue addOperation:theOp];
        [theOp release];
    }
    
    [dto release];
    [dao release];
}

//- (void)reStartOperation:(NSDictionary *)_dic
//{
//    //从userdefaults读取数据，并添加到队列
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSArray *array = [userDefault valueForKey:@"upload"];
//    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:array];
//    int i = (int)[arr indexOfObject:_dic];
//    if (i == NSNotFound) {
//        return;
//    }
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[arr objectAtIndex:i]];
//    [dic setValue:[NSNumber numberWithInt:0] forKey:@"state"];//0 等待上传 1 上传中 2 失败
//    [arr replaceObjectAtIndex:i withObject:dic];
//    [userDefault setValue:arr forKey:@"upload"];
//    [userDefault synchronize];
//    
//    NSInvocationOperation* theOp = [[NSInvocationOperation alloc] initWithTarget:self
//                                                                        selector:@selector(myTaskMethod:) object:dic];
//    
//    [self.operationQueue addOperation:theOp];
//    [theOp release];
//    
//    //更新UI
//}

- (void)doUploadTask:(id)_obj
{
    if ([_obj isMemberOfClass:[PendingUploadTaskDTO class]]) {
        PendingUploadTaskDTO *dto = (PendingUploadTaskDTO *)[_obj retain];
        
        if (dto.mediaType == 0) {
            UploadImageInterface *mUploadImageInterface = [[UploadImageInterface alloc] init];
            [self.interfaceHolder setObject:mUploadImageInterface forKey:[NSNumber numberWithInt:dto.pid]];
            mUploadImageInterface.delegate = self;
            [mUploadImageInterface doUploadImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:dto.filePath]]] 
                                          description:dto.description
                                             circleId:[dto.circleId intValue] 
                                                  lon:dto.lon 
                                                  lat:dto.lat
                                               taskId:dto.pid];
            [mUploadImageInterface release];
        }else{
            UploadVideoInterface *mUploadVideoInterface = [[UploadVideoInterface alloc] init];
            [self.interfaceHolder setObject:mUploadVideoInterface forKey:[NSNumber numberWithInt:dto.pid]];
            mUploadVideoInterface.delegate = self;
            [mUploadVideoInterface doUploadVideo:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:dto.filePath]]
                                            thumbnail:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:dto.thumbnailPath]]]
                                          description:dto.description
                                             circleId:[dto.circleId intValue]
                                                  lon:dto.lon 
                                                  lat:dto.lat
                                               taskId:dto.pid];
            [mUploadVideoInterface release];
        }
        
        [dto release];
    }
}

//- (void)taskMethodDidFailed:(id)_obj
//{
//    //失败的任务更改状态之后保存
//    NSDictionary *tdic = [_obj retain];
//    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:tdic];
//    [dic setValue:[NSNumber numberWithInt:1] forKey:@"state"];
//    
//    [userDefault synchronize];
//    
//    //更新UI
//}
//
//- (void)taskMethodDidFinish:(id)_obj
//{
//    //成功的任务从userdefaults中删除
//    NSDictionary *tdic = [_obj retain];
//    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:tdic];
//    [dic setValue:[NSNumber numberWithInt:1] forKey:@"state"];
//    
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSArray *array = [userDefault valueForKey:@"upload"];
//}

- (void)dealloc
{
    for (id interface in [self.interfaceHolder allValues]) {
        if ([interface isMemberOfClass:[UploadImageInterface class]]) {
            UploadImageInterface *uii = (UploadImageInterface *)interface;
            uii.delegate = nil;
        }else if ([interface isMemberOfClass:[UploadVideoInterface class]]) {
            UploadVideoInterface *uvi = (UploadVideoInterface *)interface;
            uvi.delegate = nil;
        }
    }
    [self.interfaceHolder removeAllObjects];
    self.interfaceHolder = nil;
    
    [operationQueue release];
    [super dealloc];
}

#pragma mark - UploadImageInterfaceDelegate
-(void)uploadImageDidFinishedTaskId:(long long int)tId{
    UploadImageInterface *mUploadImageInterface = [self.interfaceHolder objectForKey:[NSNumber numberWithLongLong:tId]];
    mUploadImageInterface.delegate = nil;
    [self.interfaceHolder removeObjectForKey:[NSNumber numberWithLongLong:tId]];
    
    PendingUploadDao *dao = [[PendingUploadDao alloc] init];
    [dao removePendingUploadTaskDTOById:tId];
    [dao release];
}
-(void)uploadImageDidFailed:(NSString *)errorMsg taskId:(long long int)tId{
    NSLog(@"-------------------------------%@",errorMsg);
    
    UploadImageInterface *mUploadImageInterface = [self.interfaceHolder objectForKey:[NSNumber numberWithLongLong:tId]];
    mUploadImageInterface.delegate = nil;
    [self.interfaceHolder removeObjectForKey:[NSNumber numberWithLongLong:tId]];
    
    PendingUploadDao *dao = [[PendingUploadDao alloc] init];
    [dao updatePendingStateById:tId state:2];
    
    [self performSelector:@selector(addOperationAfterDelay:) withObject:[NSNumber numberWithLongLong:tId] afterDelay:5];
    [dao release];
}

#pragma mark - UploadVideoInterfaceDelegate
-(void)uploadVideoDidFinishedTaskId:(long long)tId{
    UploadVideoInterface *mUploadVideoInterface = [self.interfaceHolder objectForKey:[NSNumber numberWithLongLong:tId]];
    mUploadVideoInterface.delegate = nil;
    [self.interfaceHolder removeObjectForKey:[NSNumber numberWithLongLong:tId]];
    
    PendingUploadDao *dao = [[PendingUploadDao alloc] init];
    [dao removePendingUploadTaskDTOById:tId];
    [dao release];
}
-(void)uploadVideoDidFailed:(NSString *)errorMsg taskId:(long long)tId{
    NSLog(@"%@",errorMsg);
    
    UploadVideoInterface *mUploadVideoInterface = [self.interfaceHolder objectForKey:[NSNumber numberWithLongLong:tId]];
    mUploadVideoInterface.delegate = nil;
    [self.interfaceHolder removeObjectForKey:[NSNumber numberWithLongLong:tId]];
    
    PendingUploadDao *dao = [[PendingUploadDao alloc] init];
    [dao updatePendingStateById:tId state:2];
    
//    [self addOperation:tId];
    [self performSelector:@selector(addOperationAfterDelay:) withObject:[NSNumber numberWithLongLong:tId] afterDelay:5];
    [dao release];
}
@end
