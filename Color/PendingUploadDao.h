//
//  PendingUploadDao.h
//  Color
//
//  Created by chao han on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseDao.h"
#import "PendingUploadTaskDTO.h"

@interface PendingUploadDao : BaseDao

-(NSArray *)getAllWaitUploadPendingUploadTaskDTO;
-(PendingUploadTaskDTO *)getPendingUploadTaskDTOById:(long long int)pid;
-(long long int)addPendingUploadTaskDTO:(PendingUploadTaskDTO *)dto;
-(BOOL)updatePendingStateById:(NSInteger)pid state:(NSInteger)state;//根据id修改状态
-(BOOL)removePendingUploadTaskDTOById:(NSInteger) pid;

-(BOOL)repairAllTask;//修复所有上传任务记录(若上传中客户端被关闭则需要重新上传)

@end
