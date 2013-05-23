//
//  RemoveMediaInterface.h
//  Color
//  Created by chao han on 12-6-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@protocol RemoveMediaInterfaceDelegate;

@interface RemoveMediaInterface : BaseInterface <BaseInterfaceDelegate>{
    NSString *_mediaId;
}

@property (nonatomic,assign) id<RemoveMediaInterfaceDelegate> delegate;

-(void)removeMediaById:(NSString *)mediaId;

@end

@protocol RemoveMediaInterfaceDelegate <NSObject>

-(void)removeMediaByIdDidFinished:(NSString *)mediaId;
-(void)removeMediaByIdDidFailed:(NSString *)errorMsg;


@end
