//
//  AppDelegate.m
//  All_Parts
//
//  Created by RuanSTao on 14-2-18.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//

#import "AppDelegate.h"
#import "HpCViewController.h"
#import "C_N_ViewController.h"
#import "Q_N_ViewController.h"
#import "ThingsViewController.h"
#import "PersonalViewController.h"
#import "CustomTabBarViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    HpCViewController * hp_Ctl=[[HpCViewController alloc] init];
    C_N_ViewController * c_Ctl=[[C_N_ViewController alloc] init];
    Q_N_ViewController * q_Ctl=[[Q_N_ViewController alloc] init];
    ThingsViewController * things=[[ThingsViewController alloc] init];
    PersonalViewController * personal=[[PersonalViewController alloc] init];
    UINavigationController * hp_Nav=[[UINavigationController alloc] initWithRootViewController:hp_Ctl];
    UINavigationController * c_Nav=[[UINavigationController alloc] initWithRootViewController:c_Ctl];
    UINavigationController * q_Nav=[[UINavigationController alloc] initWithRootViewController:q_Ctl];
    UINavigationController * th_Nav=[[UINavigationController alloc] initWithRootViewController:things];
    UINavigationController * per_Nav=[[UINavigationController alloc] initWithRootViewController:personal];
    hp_Nav.navigationBar.translucent=NO;
//    c_Nav.navigationBar.translucent=NO;
    CustomTabBarViewController * root=[[CustomTabBarViewController alloc] init];
//    root.tabBar.translucent=NO;
    root.viewControllers=@[hp_Nav,c_Nav,q_Nav,th_Nav,per_Nav];
    self.window.rootViewController=root;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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
