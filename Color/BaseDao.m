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
        //paths： ios下Document路径，Document为ios中可读写的文件夹  
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
        NSString *documentDirectory = [paths objectAtIndex:0];  
        //dbPath： 数据库路径，在Document中。  
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"qiezi.db"];  
        //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"  
        self.db = [FMDatabase databaseWithPath:dbPath] ;  
        if (![self.db open]) {  
            NSLog(@"Could not open db.");  
            self.db = nil; 
        }
        
        FMResultSet *rs = [self.db executeQuery:@"select name from SQLITE_MASTER where name = 'pending_uploads'"];
        
        if (![rs next]) {
            NSLog(@"setting up new tables.");
            [rs close];
            // if we don't get a result, then we'll need to make our tables.
            
//            int schemaVersion = 1;
//            
//            [cacheDB beginTransaction];
//            
//            // simple key value stuff, for config info.  The type is the value type.  Eventually i'll add something like:
//            // - (void) setDBProperty:(id)obj forKey:(NSString*)key
//            // - (id) dbPropertyForKey:(NSString*)key
//            // which just figures out what the type is, and stores it appropriately.
//            
//            [cacheDB executeUpdate:@"create table letters_meta ( name text, type text, value blob )"];
//            
//            [cacheDB executeUpdate:@"insert into letters_meta (name, type, value) values (?,?,?)", @"schemaVersion", @"int", [NSNumber numberWithInt:schemaVersion]];
//            
//            // this table obviously isn't going to cut it.  It needs multiple to's and other nice things.
//            [cacheDB executeUpdate:@"create table message ( localUUID text primary key,\n\
//             serverUID text,\n\
//             messageId text,\n\
//             inReplyTo text,\n\
//             mailbox text,\n\
//             subject text,\n\
//             fromAddress text, \n\
//             toAddress text, \n\
//             receivedDate float,\n\
//             sendDate float,\n\
//             seenFlag integer,\n\
//             answeredFlag integer,\n\
//             flaggedFlag integer,\n\
//             deletedFlag integer,\n\
//             draftFlag integer,\n\
//             flags text\n\
//             )"];
//            
//            // um... do we need anything else?
//            [cacheDB executeUpdate:@"create table mailbox ( mailbox text, subscribed int )"];
            
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
