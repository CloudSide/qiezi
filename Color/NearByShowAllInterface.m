//
//  NearByShowAllInterface.m
//  Color
//
//  Created by chao han on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NearByShowAllInterface.h"
#import "DeviceUtil.h"
#import "UserModel.h"
#import "MediaModel.h"
#import "CircleModel.h"

@implementation NearByShowAllInterface
@synthesize delegate = _delegate;

-(void)getAll{
    self.needCacheFlag = NO;
    self.baseDelegate = self;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%.11g",[MySingleton sharedSingleton].lon] forKey:@"lon"];
    [dict setObject:[NSString stringWithFormat:@"%.10g",[MySingleton sharedSingleton].lat] forKey:@"lat"];
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/nearby/showall",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.postKeyValues = dict;
    [dict release];
    
    [self connect];
}

-(void)dealloc {
    self.delegate = nil;
    
    [super dealloc];
}

-(void)parseResult:(NSDictionary *)responseDict{
    if (responseDict && [responseDict count] > 0) {
        NSMutableArray *circleArray = [[NSMutableArray alloc] init];
        NSDictionary *content = [responseDict objectForKey:@"content"];
        NSMutableArray *usersArray = [[NSMutableArray alloc] init];
        NSArray *users = [content objectForKey:@"user"];
        if ([users count] > 0) {
            for (NSDictionary *user in users) {
                UserModel *um = [[UserModel alloc] init];
                um.userId = [user objectForKey:@"userId"];
                um.name = [user objectForKey:@"name"];
                um.avatarUrl = [user objectForKey:@"avatar"];
                
                [usersArray addObject:um];
                [um release];
            }
        }
        
        UserModel *um = [[UserModel alloc] init];
        um.userId = [MySingleton sharedSingleton].userId;
        um.name = [MySingleton sharedSingleton].name;
        um.avatarUrl = [MySingleton sharedSingleton].avatarUrl;
        
        [usersArray addObject:um];
        [um release];

        
        NSArray *circles = [content objectForKey:@"circle"];
        for (NSDictionary *circle in circles) {
            CircleModel *cm = [[CircleModel alloc] init];
            [circleArray addObject:cm];
            cm.cId = [circle objectForKey:@"circleId"];
            cm.ctime = [NSDate dateWithTimeIntervalSince1970:[[circle objectForKey:@"ctime"]intValue]];
            
            NSMutableArray *userArray = [[NSMutableArray alloc] init];
            cm.usersArray = userArray;
            NSArray *userInCircleArray = [circle objectForKey:@"user"];
            for (NSDictionary *u in userInCircleArray) {
                UserModel *um = [[UserModel alloc] init];
                um.userId = [u objectForKey:@"userId"];
                um.name = [u objectForKey:@"name"];
                um.avatarUrl = [u objectForKey:@"avatar"];
                
                [userArray addObject:um];
                [um release];
            }
            [userArray release];
            
            NSMutableArray *mediaArray = [[NSMutableArray alloc] init];
            cm.mediasArray = mediaArray;
            NSArray *mediaInCircleArray = [circle objectForKey:@"media"];
            for (NSDictionary *m in mediaInCircleArray) {
                MediaModel *mm = [[MediaModel alloc] init];
                mm.mid = [m objectForKey:@"mediaId"];
                mm.originalUrl = [m objectForKey:@"original"];
                mm.mediaType = [((NSNumber *)[m objectForKey:@"type"]) intValue];
                mm.ctime = [NSDate dateWithTimeIntervalSince1970:[[m objectForKey:@"ctime"]intValue]];
                
                [mediaArray addObject:mm];
                [mm release];
            }
            [mediaArray release];
            
            [cm release];
        }
                
        [self.delegate getAllDidFinished:circleArray users:(NSArray *)usersArray];
        [circleArray release];
        [usersArray release];
        
    }else{
        [self.delegate getAllDidFinished:nil users:nil];
    }
}

-(void)requestIsFailed:(NSString *)errorMsg{
    [self.delegate getAllDidFailed:errorMsg];
}
@end
