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
//#import <libDoubanApiEngine/DOUAPIEngine.h>
//
//static NSString * const kAPIKey = @"0f9c7fedcad387ac2ed57fc9607a9704";
//static NSString * const kPrivateKey = @"2a9aaac9a9cb830f";
//static NSString * const kRedirectUrl = @"http://www.douban.com/location/mobile";
NSString * const kHttpsApiBaseUrl = @"https://api.douban.com";
NSString * const kHttpApiBaseUrl = @"http://api.douban.com";
NSString * const kAuthUrl = @"https://www.douban.com/service/auth2/auth";
NSString * const kTokenUrl = @"https://www.douban.com/service/auth2/token";
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
//    hp_Nav.navigationBar.translucent=NO;
//    c_Nav.navigationBar.translucent=NO;
    _root=[[CustomTabBarViewController alloc] init];
//    root.tabBar.translucent=NO;
    _root.viewControllers=@[hp_Nav,c_Nav,q_Nav,th_Nav,per_Nav];
    self.window.rootViewController=_root;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
//SinaWeiBo
//    _sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
//
//    // 从NSUserDefaults取3个参数 自动登陆
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
//    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
//    {
//        _sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
//        _sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
//        _sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
//    }
    [WeiboSDK registerApp:kAppKey];
    [WeiboSDK enableDebugMode:YES];
    
    DOUService * service = [DOUService sharedInstance];
    service.clientId =kAPIKey;
    service.clientSecret=kPrivateKey;
    if ([service isValid]) {
        service.apiBaseUrlString = kHttpsApiBaseUrl;
    }
    else {
        service.apiBaseUrlString = kHttpApiBaseUrl;
    }
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
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {
//        ProvideMessageForWeiboViewController *controller = [[[ProvideMessageForWeiboViewController alloc] init] autorelease];
//        [self.viewController presentModalViewController:controller animated:YES];
    }
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = @"发送结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *title = @"认证结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        
        [[NSUserDefaults standardUserDefaults] setObject:response.userInfo   forKey:@"SinaWeiBoUserInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [alert show];

    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

#pragma mark- My Method
//- (SinaWeibo *)sinaweibo
//{
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    return delegate.sinaweibo;
//}

#pragma mark - WBHttpRequestDelegate
- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@",request);
    NSHTTPURLResponse * resp=(NSHTTPURLResponse*) response;
    NSLog(@"%@",resp);
    NSString * str;
    
    if ([request.tag isEqual:@"200"]) {
        if (resp.statusCode==200) {
            str=@"微博分享成功";
        }
        else{
            if (resp.statusCode==400) {
                str=@"登入超时，请重新登入";
                [self removeSinaWeiboUserInfo];
            }else{
                str=@"微博分享失败";
            }
        }
    }else if ([request.tag isEqualToString:@"210"]){
        if (resp.statusCode==200) {
            str= @"微博登出成功";
        }
        else{
            str=@"微博登出失败";
        }
    }
    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"All_Parts" message:str delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"知道了", nil];
    [alert show];
}
/*1
 url	__NSCFString *	@"https://api.weibo.com/oauth2/revokeoauth2"	0x08c9abc0
 WeiboSDKResponseStatusCodeSuccess               = 0,//成功
 WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
 WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
 WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
 WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
 WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
 WeiboSDKResponseStatusCodeUnknown               = -100,
 */
/**
 收到一个来自微博Http请求失败的响应
 
 @param error 错误信息
 */

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}
- (void)removeSinaWeiboUserInfo
{
    NSDictionary * userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"SinaWeiBoUserInfo"];
    [WeiboSDK logOutWithToken:[userInfo objectForKey:@"access_token"] delegate:self withTag:@"210"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiBoUserInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
