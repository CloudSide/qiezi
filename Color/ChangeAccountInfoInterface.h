//
//  ChangeAccountInfoInterface.h
//  Color
//  Created by chao han on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@protocol ChangeAccountInfoInterfaceDelegate;

@interface ChangeAccountInfoInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic,assign) id<ChangeAccountInfoInterfaceDelegate> delegate;

-(void)changeAccountInfo:(NSString *)name tel:(NSString *)tel;

@end

@protocol ChangeAccountInfoInterfaceDelegate <NSObject>
-(void)changeAccountInfoDidFinished;
-(void)changeAccountInfoDidFailed:(NSString *)errorMsg;



@end
