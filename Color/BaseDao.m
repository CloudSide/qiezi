//
//  BaseDao.m
//  MagFan
//
//  Created by chao han on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseDao.h"

@implementation BaseDao

@synthesize db = _db;

- (id)init{
    if(self = [super init]){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
        NSString *documentDirectory = [paths objectAtIndex:0];  
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"qiezi.db"];  
        self.db = [FMDatabase databaseWithPath:dbPath] ;  
        if (![self.db open]) {  
            NSLog(@"Could not open db.");  
            self.db = nil; 
        }
        
        FMResultSet *rs = [self.db executeQuery:@"select name from SQLITE_MASTER where name = 'pending_uploads'"];
        
        if (![rs next]) {
            NSLog(@"setting up new tables.");
            [rs close];
            
            [self.db executeUpdate:@"CREATE TABLE pending_uploads (id INTEGER PRIMARY KEY  NOT NULL ,file_path VARCHAR NOT NULL ,media_type INTEGER NOT NULL ,retry_times INTEGER NOT NULL  DEFAULT (0) ,error_code VARCHAR,lon DOUBLE,lat DOUBLE,circle_id VARCHAR,description VARCHAR,thumbnail_path VARCHAR,pending_state INTEGER  DEFAULT (0))"];
            
//            [self.db commit];
        }
        
        [rs close];

    
    }
    return self;
}

-(void)dealloc
{
    self.db = nil;
    
    [super dealloc];
}
@end
