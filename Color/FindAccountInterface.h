//
//  FindAccountInterface.h
//  QieZi
//
//  用于找回账号
//  Created by hanchao on 14-2-19.
//
//

#import "BaseInterface.h"

@protocol FindAccountInterfaceDelegate <NSObject>

-(void)findAccountDidFinished:(NSArray *)userArray;
-(void)findAccountDidFailed:(NSString *)errorMsg;

@end

@interface FindAccountInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic,assign) id<FindAccountInterfaceDelegate> delegate;
//根据用户名称获取账号
-(void)findAccountByUserName:(NSString *)userName;

@end
