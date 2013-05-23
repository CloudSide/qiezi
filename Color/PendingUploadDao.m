//
//  PendingUploadDao.m
//  Color
//
//  Created by chao han on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PendingUploadDao.h"

@implementation PendingUploadDao

-(NSArray *)getAllWaitUploadPendingUploadTaskDTO{
    NSMutableArray *pendingArray = [[[NSMutableArray alloc] init] autorelease];
    
    FMResultSet *rs = [self.db executeQuery:@"select id,file_path,media_type,retry_times,error_code,lon,lat,circle_id,description,thumbnail_path,pending_state from pending_uploads where pending_state != 1"];
    while ([rs next]) {
        PendingUploadTaskDTO *dto = [[PendingUploadTaskDTO alloc] init];
        NSInteger idx = 0;
        dto.pid = [rs intForColumnIndex:idx];
        dto.filePath = [rs stringForColumnIndex:++idx];
        dto.mediaType = [rs intForColumnIndex:++idx];
        dto.retryTimes = [rs intForColumnIndex:++idx];
        dto.errorCode = [rs stringForColumnIndex:++idx];
        dto.lon = [rs intForColumnIndex:++idx];
        dto.lat = [rs intForColumnIndex:++idx];
        dto.circleId = [rs stringForColumnIndex:++idx];
        dto.description = [rs stringForColumnIndex:++idx];
        dto.thumbnailPath = [rs stringForColumnIndex:++idx];
        dto.pendingState = [rs intForColumnIndex:++idx];
        
        [pendingArray addObject:dto];
        [dto release];
    }
    [rs close];
    
    return pendingArray;
}

-(PendingUploadTaskDTO *)getPendingUploadTaskDTOById:(long long int)pid
{
    PendingUploadTaskDTO *dto = nil;
    
    FMResultSet *rs = [self.db executeQuery:@"select id,file_path,media_type,retry_times,error_code,lon,lat,circle_id,description,thumbnail_path,pending_state from pending_uploads where id = ?",[NSString stringWithFormat:@"%lld",pid]];

    while ([rs next]) {
        dto = [[[PendingUploadTaskDTO alloc] init] autorelease];
        NSInteger idx = 0;
        dto.pid = [rs intForColumnIndex:idx];
        dto.filePath = [rs stringForColumnIndex:++idx];
        dto.mediaType = [rs intForColumnIndex:++idx];
        dto.retryTimes = [rs intForColumnIndex:++idx];
        dto.errorCode = [rs stringForColumnIndex:++idx];
        dto.lon = [rs doubleForColumnIndex:++idx];
        dto.lat = [rs doubleForColumnIndex:++idx];
        dto.circleId = [rs stringForColumnIndex:++idx];
        dto.description = [rs stringForColumnIndex:++idx];
        dto.thumbnailPath = [rs stringForColumnIndex:++idx];
        dto.pendingState = [rs intForColumnIndex:++idx];
        
        break;
    }
    [rs close];
    
    return dto;
}

-(long long int)addPendingUploadTaskDTO:(PendingUploadTaskDTO *)dto
{
    [self.db executeUpdate:@"insert into pending_uploads ( file_path,media_type,lon,lat,circle_id,description,thumbnail_path,pending_state ) values (?,?,?,?,?,?,?,?)"
            ,dto.filePath
            ,[NSString stringWithFormat:@"%d", dto.mediaType]
            ,[NSString stringWithFormat:@"%f", dto.lon]
            ,[NSString stringWithFormat:@"%f", dto.lat]
            ,dto.circleId
            ,dto.description
            ,dto.thumbnailPath
            ,[NSString stringWithFormat:@"%d", 0]];
    
    return [self.db lastInsertRowId];//返回当前id

}

-(BOOL)updatePendingStateById:(NSInteger)pid state:(NSInteger)state
{
    return [self.db executeUpdate:@"UPDATE pending_uploads SET pending_state = ? WHERE id = ?"
            ,[NSString stringWithFormat:@"%d", state]
            ,[NSString stringWithFormat:@"%d", pid]];
}

-(BOOL)removePendingUploadTaskDTOById:(NSInteger) pid
{
    return [self.db executeUpdate:@"delete from pending_uploads where id = ? ",[NSString stringWithFormat:@"%d", pid]];
}

-(BOOL)repairAllTask
{
    return [self.db executeUpdate:@"UPDATE pending_uploads SET pending_state = 0"];
}
@end
