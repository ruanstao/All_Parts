//
//  AppDelegate.h
//  All_Parts
//
//  Created by RuanSTao on 14-2-18.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#define kAppKey             @"2130509836"
#define kAppSecret          @"b2018c9075b2becc352f9fc73a1dea36"
#define kAppRedirectURI     @"https://api.weibo.com/oauth2/default.html"
@class  SinaWeibo;
@interface AppDelegate : UIResponder <UIApplicationDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate>

@property (strong, nonatomic) SinaWeibo * sinaweibo;
@property (strong, nonatomic) UIWindow *window;

@end
