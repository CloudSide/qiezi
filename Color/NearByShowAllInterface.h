//
//  NearByShowAllInterface.h
//  Color
//  附近接口
//  Created by chao han on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@protocol NearByShowAllInterfaceDelegate;

@interface NearByShowAllInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic,assign) id<NearByShowAllInterfaceDelegate> delegate;

-(void)getAll;

@end

@protocol NearByShowAllInterfaceDelegate <NSObject>

-(void)getAllDidFinished:(NSArray *)circleArray users:(NSArray *)userArray;
-(void)getAllDidFailed:(NSString *)errorMsg;


@end
