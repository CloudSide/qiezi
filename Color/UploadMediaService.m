//
//  UploadMediaService.m
//  Color
//  后台照片、视频文件上传服务
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
        [self.operationQueue setMaxConcurrentOperationCount:2];//设置同时进行的线程数量，建议为2。
        
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
//    //保存上传列表到nsuserdefaults
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    if ([userDefault valueForKey:@"upload"] == nil) {
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableArray arrayWithObject:_dic],@"upload",nil];
//        [userDefault registerDefaults:dic];
//        [userDefault synchronize];
//    }
//    else {
//        NSArray *array = [userDefault valueForKey:@"upload"];
//        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:array];
//        [arr addObject:_dic];
//        [userDefault setObject:arr forKey:@"upload"];
//        [arr release];
//        [userDefault synchronize];
//    }
    
    PendingUploadDao *dao = [[PendingUploadDao alloc] init];
    PendingUploadTaskDTO *dto = [[dao getPendingUploadTaskDTOById:taskId] retain];
    
    if (dto) {
        PendingUploadDao *dao = [[PendingUploadDao alloc] init];
        [dao updatePendingStateById:dto.pid state:1];//状态改为1  上传中
        [dao release];
        
        //添加到队列
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
            //上传照片
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
            //上传视频
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
    
//    //实现上传方法
//    //成功调用
//    [self performSelectorOnMainThread:@selector(taskMethodDidFinish:) withObject:nil waitUntilDone:YES];
//    //失败调用
//    [self performSelectorOnMainThread:@selector(taskMethodDidFailed:) withObject:nil waitUntilDone:YES];
}

//- (void)taskMethodDidFailed:(id)_obj
//{
//    //失败的任务更改状态之后保存
//    NSDictionary *tdic = [_obj retain];
//    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:tdic];
//    [dic setValue:[NSNumber numberWithInt:1] forKey:@"state"];
//    
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSArray *array = [userDefault valueForKey:@"upload"];
//    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:array];
//    int _index = (int)[arr indexOfObject:dic];
//    if (_index != NSNotFound) {
//        NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:[arr objectAtIndex:_index]];
//        [tmp setValue:[NSNumber numberWithInt:2] forKey:@"state"];//0 等待上传 1 上传中 2 失败
//        [arr replaceObjectAtIndex:_index withObject:tmp];
//    }
//    [userDefault setObject:arr forKey:@"upload"];
//    [arr release];
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
//    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:array];
//    int _index = (int)[arr indexOfObject:dic];
//    if (_index != NSNotFound) {
//        [arr removeObjectAtIndex:_index];
//    }
//    [userDefault setObject:arr forKey:@"upload"];
//    [arr release];
//    [userDefault synchronize];
//    
//    //更新UI
//}

- (void)dealloc
{
//    self.mUploadImageInterface.delegate = nil;
//    self.mUploadImageInterface = nil;
//    
//    self.mUploadVideoInterface.delegate = nil;
//    self.mUploadVideoInterface = nil;
    
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
    [dao updatePendingStateById:tId state:2];//修改状态为:上传照片失败
    
//    [self addOperation:tId];
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
    [dao updatePendingStateById:tId state:2];//修改状态为:上传照片失败
    
//    [self addOperation:tId];
    [self performSelector:@selector(addOperationAfterDelay:) withObject:[NSNumber numberWithLongLong:tId] afterDelay:5];
    [dao release];
}
@end
