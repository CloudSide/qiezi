//
//  AppDelegate.h
//  Color
//
//  Created by chao han on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultLoginInterface.h"
#import "CustomTabBarController.h"
#import "DefaultLoginInterface.h"
#import "SendLogInterface.h"
#import "MobClick.h"

#define kUMENGAPPKEY                @"50d978af527015327c00000c"

@interface AppDelegate : UIResponder <UIApplicationDelegate,DefaultLoginInterfaceDelegate,SendLogInterfaceDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,retain) CustomTabBarController *tabBarController;
@property (nonatomic,retain) UINavigationController *loginNav;
@property (nonatomic,retain) DefaultLoginInterface *mDefaultLoginInterface;

@property (nonatomic,retain) SendLogInterface *mSendLogInterface;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void)showMainView;

@end
