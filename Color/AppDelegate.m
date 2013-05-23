//
//  AppDelegate.m
//  Color
//
//  Created by chao han on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "NearByUIViewController.h"
#import "DynamicUIViewController.h"
#import "TakePhotoUIViewController.h"
#import "DiaryUIViewController.h"
#import "NotificationUIViewController.h"
#import "CustomTabBarController.h"

#import "LoginViewController.h"
#import "DefaultLoginInterface.h"

#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"

#import "PendingUploadDao.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize tabBarController = _tabBarController , loginNav = _loginNav , mDefaultLoginInterface = _mDefaultLoginInterface;
@synthesize mSendLogInterface = _mSendLogInterface;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [MobClick startWithAppkey:kUMENGAPPKEY];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    PendingUploadDao *dao = [[PendingUploadDao alloc] init];
    [dao repairAllTask];
    [dao release];
    
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    if (manager.locationServicesEnabled == NO) {
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:nil message:@"请开启GPS位置定位服务" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
        [servicesDisabledAlert release];
        
        
    }
    [manager release];  
    
    
    if ([self GetCurrntNet]) {
        self.mDefaultLoginInterface = [[[DefaultLoginInterface alloc] init] autorelease];
        self.mDefaultLoginInterface.delegate = self;
        [self.mDefaultLoginInterface doLogin];
        
        
        [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackTranslucent];
        [self.window makeKeyAndVisible];
    }else{
        if ([[MySingleton sharedSingleton] isStateDictExist]) {
            [self showMainView];
        }else{
            [self showRegisteView];
        }
    }
    
    NSLog(@"===============================================application didFinishLaunchingWithOptions========"); 
    if (!self.mSendLogInterface) {
        self.mSendLogInterface = [[[SendLogInterface alloc] init] autorelease];
        self.mSendLogInterface.delegate = self;
        [self.mSendLogInterface sendLog];
    }
    
    
    return YES;
}


-(BOOL)GetCurrntNet
{
    NSString* result;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];    
    switch ([r currentReachabilityStatus]) {
            
        case NotReachable:
        {
            result=@"请检查您的网络";
#ifndef __IPHONE_5_0  
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络状态"
                                                            message:result
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"设置",nil];
            [alert show];
            alert.delegate = self;
            [alert release];
#else  
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络状态"
                                                            message:result
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            alert.tag = 11112;
            alert.delegate = self;
            [alert release];
#endif 
            
            return NO;
            break;
        }
        case ReachableViaWWAN:
            
            
            return  YES;
            break;
            
        case ReachableViaWiFi:
            
            
            return  YES;
            break;    
    }
}

#pragma mark - UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11112 && buttonIndex == 1) {
        NSURL*url=[NSURL URLWithString:@"prefs:root=WIFI"]; 
        [[UIApplication sharedApplication] openURL:url]; 
    }else if (alertView.tag == 9999 && buttonIndex == 1) {
        NSURL*url=[NSURL URLWithString:[MySingleton sharedSingleton].updateUrl]; 
        [[UIApplication sharedApplication] openURL:url]; 
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    if (!self.mSendLogInterface) {
        NSLog(@"===============================================applicationWillEnterForeground========");
        self.mSendLogInterface = [[[SendLogInterface alloc] init] autorelease];
        self.mSendLogInterface.delegate = self;
        [self.mSendLogInterface sendLog];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Color" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Color.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - 
-(void)showMainView {
    NearByUIViewController *mNearByUIViewController = [[NearByUIViewController alloc] init];
    DynamicUIViewController *mDynamicUIViewController = [[DynamicUIViewController alloc]init];
    //    TakePhotoUIViewController *mTakePhotoUIViewController = [[TakePhotoUIViewController alloc]init];
    DiaryUIViewController *mDiaryUIViewController = [[DiaryUIViewController alloc]init];
    NotificationUIViewController *mNotificationUIViewController = [[NotificationUIViewController alloc]init];
    mNearByUIViewController.hidesBottomBarWhenPushed = true;
    mDynamicUIViewController.hidesBottomBarWhenPushed = true;
    //    mTakePhotoUIViewController.hidesBottomBarWhenPushed = true;
    mDiaryUIViewController.hidesBottomBarWhenPushed = true;
    mNotificationUIViewController.hidesBottomBarWhenPushed = true;
    
    mNearByUIViewController.title = @"附近";
    mDynamicUIViewController.title = @"动态";
    mDiaryUIViewController.title = @"回忆";
    mNotificationUIViewController.title = @"收件箱";
    
    UINavigationController *nav = [[UINavigationController alloc] 
                                   initWithRootViewController:mNearByUIViewController ];
    [mNearByUIViewController release];
    UINavigationController *nav1 = [[ UINavigationController alloc] 
                                    initWithRootViewController:mDynamicUIViewController];
    [mDynamicUIViewController release];
    
    
    
    UINavigationController *nav3 = [[UINavigationController alloc]
                                    initWithRootViewController:mDiaryUIViewController];  
    [mDiaryUIViewController release];
    UINavigationController *nav4 = [[UINavigationController alloc]
                                    initWithRootViewController:mNotificationUIViewController];
    [mNotificationUIViewController release];
    
    nav.navigationBar.hidden = YES;
    nav1.navigationBar.hidden = YES;
    
    nav3.navigationBar.hidden = YES;
    nav4.navigationBar.hidden = YES;
    
    nav.view.frame = CGRectMake(0, 0, self.window.frame.size.width, 406);
    nav1.view.frame = CGRectMake(0, 0, self.window.frame.size.width, 406);
    
    nav3.view.frame = CGRectMake(0, 0, self.window.frame.size.width, 406);
    nav4.view.frame = CGRectMake(0, 0, self.window.frame.size.width, 406);
    
    
    
    NSMutableArray *controllers = [[NSMutableArray alloc]init];
    [controllers addObject:nav];
    [nav release];
    [controllers addObject:nav1];
    [nav1 release];
    
    
    [controllers addObject:nav3];
    [nav3 release];
    [controllers addObject:nav4];
    [nav4 release];
    
    self.tabBarController = [[CustomTabBarController alloc] init];
    self.tabBarController.viewControllers = controllers;
    [controllers release];
    self.tabBarController.selectedIndex = 0;
    [self.loginNav.view removeFromSuperview];
    self.loginNav = nil;
    
    [self.window addSubview:self.tabBarController.view];
    [self.window makeKeyAndVisible];
}

-(void)showRegisteView{
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    self.loginNav = [[[UINavigationController alloc] initWithRootViewController:loginVC] autorelease];
    self.loginNav.navigationBar.hidden = YES;
    [loginVC release];
    
    [self.window addSubview:self.loginNav.view];
    [self.window makeKeyAndVisible];

}

#pragma mark - DefaultLoginInterfaceDelegate

-(void)loginDidFinished:(NSInteger)isNew updateUrl:(NSString *)url{
    if (url != nil && url.length > 4) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本" 
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"稍后安装"
                                                  otherButtonTitles:@"安装", nil];
        alertView.tag = 9999;
        [alertView show];
        [alertView release];
    }
    
    if (isNew == 1) {
        [self showRegisteView];
    }else{
        [self showMainView];
    }
    
    self.mDefaultLoginInterface = nil;
}

-(void)loginDidFailed{    
    if ([[MySingleton sharedSingleton] isStateDictExist]) {
        [self showMainView];
    }else{
        [self showRegisteView];
    }
}

#pragma mark - SendLogInterfaceDelegate
-(void)sendLogDidFinished
{
    NSLog(@"================sendLogDidFinished======================");
    self.mSendLogInterface.delegate = nil;
    self.mSendLogInterface = nil;
}
-(void)sendLogDidFailed
{
    NSLog(@"================sendLogDidFailed======================");
    //do nothing
}

@end
