//
//  AppDelegate.m
//  iNotice
//
//  Created by zy on 12-10-27.
//  Copyright (c) 2012年 myqsc. All rights reserved.
//

#import "AppDelegate.h"
#import "memoryManager.h"
//#import "mainViewController.h"

@implementation AppDelegate

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [PFPush storeDeviceToken:deviceToken]; // Send parse the device token
    // Subscribe this user to the broadcast channel, ""
    [[PFInstallation currentInstallation] addUniqueObject:@"mobile" forKey:@"channels"];
    [[PFInstallation currentInstallation] saveEventually];

}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"求是潮－提示" message:@"请您点击允许推送通知，否则您将无法收到我们推送的活动信息。" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
    //[application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [PFPush handlePush:userInfo];
    application.applicationIconBadgeNumber = 0;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    memoryManager *m = [memoryManager new];
    [NSThread detachNewThreadSelector:@selector(listen) toTarget:m withObject:nil];
        //if first launch
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"ever_launched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ever_launched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first_launch"];
        NSLog(@"App:First launch");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"save_user_info"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"first_launch"];
        NSLog(@"App:Ever launched");
    }

    [[NSUserDefaults standardUserDefaults] synchronize];
    //things to do when first launch
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        versionControl *verCtrl = [versionControl new];
        [NSThread detachNewThreadSelector:@selector(firstLauch) toTarget:verCtrl withObject:nil];
    }
    
    //cnzz analysis
    [MobileProbe initWithAppKey:@"cnzz.i_47927ea247e8c41a43d8befa" channel:@"TEST"];
    //push
    [Parse setApplicationId:@"UhsT16PtA9sAiN0RPzLasaJt83mjJcdEvsz0ZhMu"
                  clientKey:@"0IFRVZzrgjVQA0UW1qIrGsJtNKUP5Zmrdkm0YciF"];
    //[application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    
    //receive push
    if (launchOptions) {
        NSDictionary *push = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (push) {
            [PFPush handlePush:push];
        }
    }
    
    application.applicationIconBadgeNumber = 1;
    application.applicationIconBadgeNumber = 0;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}
@end
