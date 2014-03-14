//
//  AppDelegate.h
//  All_Parts
//
//  Created by RuanSTao on 14-2-18.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarViewController.h"
#import "WeiboSDK.h"
#import <libDoubanApiEngine/DOUService.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate,WBHttpRequestDelegate,UIScrollViewDelegate>

//@property (strong, nonatomic) SinaWeibo * sinaweibo;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CustomTabBarViewController * root;
@property (strong, nonatomic) NSString *wbtoken;
@end

