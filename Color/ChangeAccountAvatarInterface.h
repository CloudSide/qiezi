//
//  ChangeAccountAvatarInterface.h
//  Color
//  修改账户头像
//  Created by chao han on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@protocol ChangeAccountAvatarInterfaceDelegate;

@interface ChangeAccountAvatarInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic,assign) id<ChangeAccountAvatarInterfaceDelegate> delegate;

-(void)changeMyAvatar:(UIImage *)image;

@end

@protocol ChangeAccountAvatarInterfaceDelegate <NSObject>
-(void)changeMyAvatarDidFinished;
-(void)changeMyAvatarDidFailed:(NSString *)errorMsg;


@end
