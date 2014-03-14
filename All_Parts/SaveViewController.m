//
//  SaveViewController.m
//  All_Parts
//
//  Created by RuanSTao on 14-2-23.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//

#import "SaveViewController.h"
#import "DataBaseSimple.h"
#import "QN_View.h"
#import "QNModel.h"
#import "CN_View.h"
#import "CNModel.h"
#import "MBProgressHUD.h"
#import "NJKScrollFullScreen.h"
#import "UIViewController+NJKFullScreenSupport.h"
//#import "EGORefreshTableHeaderView.h"
#import "ActionView.h"
#import "ActionViewContent.h"
#import "AppDelegate.h"
#import <libDoubanApiEngine/DOUService.h>
#import <libDoubanApiEngine/DOUQuery.h>
#import <libDoubanApiEngine/DOUOAuthStore.h>
#import <libDoubanApiEngine/DOUHttpRequest.h>
#import "WebViewController.h"
@interface SaveViewController ()<NJKScrollFullscreenDelegate,UIScrollViewDelegate,ActionViewContentDelegate>
{
    DataBaseSimple * _simple;
    QN_View * _qn;
    CN_View * _cn;
}
@property (nonatomic) NJKScrollFullScreen *scrollProxy;
@property (nonatomic, retain)NSArray         *shareImageList;
@property (nonatomic, retain)NSArray         *shareImageValue;
@property (nonatomic, retain)NSArray         *shareImageActionTypes;
@property (nonatomic, retain)ActionView      *shareView;
@end

@implementation SaveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationItem.titleView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shareBtn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButton)];
    _scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self];
    if ([_mod.tablename isEqualToString:@"all_question"]){
        _qn= (QN_View *) [[[NSBundle mainBundle] loadNibNamed:@"QN_View" owner:Nil options:Nil] lastObject];
        _qn.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _qn.thingsTime= _mod.markettime;
        _qn.scrollView.delegate=(id)_scrollProxy;
        _qn.tag=402;
        [_qn setTimeData];
        [self.view addSubview:_qn];
    }
    else if ([_mod.tablename isEqualToString:@"all_content"]){
        _cn=(CN_View *) [[[NSBundle mainBundle] loadNibNamed:@"CN_View" owner:Nil options:Nil] lastObject] ;
        _cn.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _cn.thingsTime=_mod.markettime;
        _cn.scrollView.delegate=(id)_scrollProxy;
        _cn.tag=401;
        [_cn setTimeData];
        [self.view addSubview:_cn];
    }
    _scrollProxy.delegate=self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishRemoveView) name:@"REMOVE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveButton) name:@"SAVE" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - My Method
-(void) rightBarButton
{
    [self showShareView:self isFollow:NO];
}
-(void) moveUpView
{
    [self scrollFullScreen:nil scrollViewDidScrollUp:-44];
    [UIView animateWithDuration:0.2 animations:^{
        UIView * v=[self.view.subviews lastObject];
        v .frame=CGRectMake(0, -44, 320, self.view.frame.size.height);
    } completion:^(BOOL finished) {
    }];
}
-(void) moveDownView
{
    [self scrollFullScreen:nil scrollViewDidScrollDown:44];
    [UIView animateWithDuration:0.2 animations:^{
        UIView * v=[self.view.subviews lastObject];
        v.frame=CGRectMake(0,0, 320, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        //        [self.tabBarController.tabBar setHidden:NO];
    }];
}
#pragma mark - ShowAction
-(void)showShareView:(UIViewController *)uiViewController isFollow:(BOOL)follow
{
    [self moveUpView];
    if (self.shareImageList==nil) {
        self.shareImageList = @[@"share_sina.png", @"share_tc.png", @"share_douban.png", @"share_timeline.png", @"share_wc.png", @"share_wc.png", @"share_renn.png", @"share_save.png", @"share_font",@"share_sina.png",@"share_douban.png"];
        self.shareImageValue = @[@"新浪微博", @"腾讯微博", @"豆瓣",@"朋友圈",@"微信好友",@"微信收藏",@"人人网",@"拷贝",@"短信",@"登出新浪微博",@"登出豆瓣"];
        self.shareImageActionTypes = @[[NSNumber numberWithInteger:ShareTypeSinaWeibo],
                                       [NSNumber numberWithInteger:ShareTypeTencentWeibo],
                                       [NSNumber numberWithInteger:ShareTypeDouBan],
                                       [NSNumber numberWithInteger:ShareTypeWeixiTimeline],
                                       [NSNumber numberWithInteger:ShareTypeWeixiFav],
                                       [NSNumber numberWithInteger:ShareTypeWeixiSession],
                                       [NSNumber numberWithInteger:ShareTypeSMS],
                                       [NSNumber numberWithInteger:ShareTypeCopy],
                                       [NSNumber numberWithInteger:ShareTypeAny],
                                       [NSNumber numberWithInteger:ShareTypeSinaWeibo],
                                       [NSNumber numberWithInteger:ShareTypeDouBan]];
    }
    CGRect baseRect = [[UIScreen mainScreen] bounds];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        ActionViewContent * sheetContentView = [[ActionViewContent alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
        sheetContentView = [sheetContentView initwithIconSheetDelegate:self ItemCount:[self numberOfItemsInActionSheet]];
        self.shareView=[[ActionView alloc] initWithFrame:CGRectMake(0, [[UIApplication sharedApplication] keyWindow].frame.size.height, baseRect.size.width, 350)];
        [self.shareView addSubview:sheetContentView];
        [self.shareView updateFollowStatus:follow];
        
        [self.shareView.FollowButton setTitle:@"取消收藏" forState:UIControlStateNormal];
        self.shareView.FollowButtonNormal=@"取消收藏";
        self.shareView.FollowButtonSelect=@"收藏";
        [self.shareView showInView:uiViewController.view];
    }
}
#pragma mark - ActionViewContentDelegate
- (int)numberOfItemsInActionSheet
{
    return self.shareImageList.count;
}
- (ActionViewContentCell*)cellForViewAtIndex:(NSInteger)index
{
    ActionViewContentCell* cell = [[ActionViewContentCell alloc] init];
    
    [[cell iconView] setImage:[UIImage imageNamed:[self.shareImageList objectAtIndex:index]]];
    [[cell titleLabel] setText:[ self.shareImageValue objectAtIndex:index]];
    cell.index = index;
    cell.actionType = [[self.shareImageActionTypes objectAtIndex:index] integerValue];
    return cell;
}
- (void)DidTapOnItemAtIndex:(NSInteger)index actionType:(NSInteger)type
{
    NSLog(@"didTap: %d",index);
    switch (index) {
        case 0:{
            [self sinaWeiBo];
        }
            break;
        case 1:{
            
        }
            break;
        case 2:{
            [self douban];
        }
            break;
        case 3:{
            
        }
            break;
        default:
            break;
        case 9:{
            [self removeSinaWeiboUserInfo];
        }
            break;
        case 10:{
            [[DOUOAuthStore sharedInstance] clear];
            
        }
    }
    [self.shareView dismiss];
}

#pragma mark - ActionViewDelegate

-(void) finishRemoveView
{
    [self moveDownView];
}
-(void) saveButton
{
    _simple=[DataBaseSimple sharedDataBase];
    if ([self.view.subviews[0] isKindOfClass:[CN_View class]]) {
        CN_View * v=(CN_View *)self.view.subviews[0];
        if ( [self.shareView.FollowButton.titleLabel.text isEqualToString:@"收藏"]) {
            [_simple deleteDataWithID:v.conId];
        }else{
            NSMutableDictionary * dic=[NSMutableDictionary dictionary];
            [dic setObject: v.contTitle.text forKey:@"title"];
            [dic setObject: v.selfTime forKey:@"markettime"];
            [dic setObject: v.conId forKey:@"id"];
            [dic setObject:@"all_content" forKey:@"tablename"];
            [_simple insertDataForTableName:@"all_things" with:dic];

        }
        
    }else if ([self.view.subviews[0] isKindOfClass:[QN_View class]]){
        QN_View * v=(QN_View *)self.view.subviews[0];
        if ([self.shareView.FollowButton.titleLabel.text isEqualToString:@"收藏"]) {
            [_simple deleteDataWithID:v.qnId];
        }
            NSMutableDictionary * dic=[NSMutableDictionary dictionary];
            [dic setObject: v.questionTitle.text forKey:@"title"];
            [dic setObject: v.selfTime forKey:@"markettime"];
            [dic setObject: v.qnId forKey:@"id"];
            [dic setObject:@"all_question" forKey:@"tablename"];
            [_simple insertDataForTableName:@"all_things" with:dic];
        }


}
#pragma mark - SinaWeiBo
-(void) sinaWeiBo
{
    NSDictionary * userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"SinaWeiBoUserInfo"];
    if (userInfo==nil) {
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = kAppRedirectURI;
        request.scope = @"all";
        request.userInfo =nil;
        [WeiboSDK sendRequest:request];
    }
    else {
        NSString * shareStr;
        _simple=[DataBaseSimple sharedDataBase];
        if ([self.view.subviews[0] isKindOfClass:[CN_View class]]) {
            CN_View * v=(CN_View *)self.view.subviews[0];
            CNModel * mod =[_simple getFromDataBaseFromTableName:@"all_content" withMarketTime:v.selfTime];
           shareStr=[NSString stringWithFormat:@"《%@》by %@ “%@” %@ - 阅读全文：%@",mod.conttitle,mod.contauthor,mod.sgw,mod.swbn,mod.sweblk];

        }else if ([self.view.subviews[0] isKindOfClass:[QN_View class]]){
            QN_View * v=(QN_View *)[self.view.subviews lastObject];
            QNModel * mod =[_simple getFromDataBaseFromTableName:@"all_question" withMarketTime:v.selfTime];
            shareStr=[NSString stringWithFormat:@"%@ - 阅读全文：%@",mod.questiontitle,mod.sweblk];
        }
        

       
        [WBHttpRequest requestWithAccessToken:[userInfo objectForKey:@"access_token"]
                                          url:@"https://api.weibo.com/2/statuses/update.json"
                                   httpMethod:@"POST"
                                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:shareStr,@"status",nil]
                                     delegate:(AppDelegate *)[UIApplication sharedApplication].delegate
                                      withTag:@"200"];
        //        WBMessageObject * message=[WBMessageObject message];
        //        message.text=shareStr;
        //        WBProvideMessageForWeiboResponse * respone = [WBProvideMessageForWeiboResponse responseWithMessage:message];
        //        [WeiboSDK sendResponse:respone];
    }
}
- (void)removeSinaWeiboUserInfo
{
    NSDictionary * userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"SinaWeiBoUserInfo"];
    [WeiboSDK logOutWithToken:[userInfo objectForKey:@"access_token"] delegate:(AppDelegate *)[UIApplication sharedApplication].delegate withTag:@"210"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiBoUserInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - DouBan
-(void) douban
{
    NSString * shareStr;
    _simple=[DataBaseSimple sharedDataBase];
    if ([self.view.subviews[0] isKindOfClass:[CN_View class]]) {
        CN_View * v=(CN_View *)self.view.subviews[0];
        CNModel * mod =[_simple getFromDataBaseFromTableName:@"all_content" withMarketTime:v.selfTime];
        shareStr=[NSString stringWithFormat:@"text=《%@》by %@ “%@” %@ - 阅读全文：%@",mod.conttitle,mod.contauthor,mod.sgw,mod.swbn,mod.sweblk];
        
    }else if ([self.view.subviews[0] isKindOfClass:[QN_View class]]){
        QN_View * v=(QN_View *)self.view.subviews[0];
        QNModel * mod =[_simple getFromDataBaseFromTableName:@"all_question" withMarketTime:v.selfTime];
        shareStr=[NSString stringWithFormat:@"text= %@ - 阅读全文：%@",mod.questiontitle,mod.sweblk];
    }
    
    DOUOAuthStore *store = [DOUOAuthStore sharedInstance];
    DOUService * service = [DOUService sharedInstance];
    if (store.userId != 0 && store.refreshToken && ![store shouldRefreshToken]) {
        DOUQuery * query =[[DOUQuery alloc] initWithSubPath:@"/shuo/v2/statuses/" parameters:nil];
        DOUReqBlock completionBlock=^(DOUHttpRequest * req){
            //            NSLog(@"code:%d, str:%@", [req responseStatusCode], [req responseString]);
            NSError *theError = [req doubanError];
            NSString * str;
            if (!theError) {
                str=@"分享成功";
            }
            else {
                str=@"分享失败";
                NSLog(@"%@", theError);
            }
            UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"All_Parts" message:str delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:@"知道了", nil];
            [alert show];
        };
        
        //        [service post2: query photoData:data description:description callback:completionBlock uploadProgressDelegate:self];
        [service post:query postBody:shareStr callback:completionBlock];
    }
    else{
        NSString *str = [NSString stringWithFormat:@"https://www.douban.com/service/auth2/auth?client_id=%@&redirect_uri=%@&response_type=code",kAPIKey, kRedirectUrl];
        //            NSLog(@"%@",str);
        NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlStr];
        UIViewController *webViewController = [[WebViewController alloc] initWithRequestURL:url];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

#pragma mark NJKScrollFullScreenDelegate

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollUp:(CGFloat)deltaY
{
    [self moveNavigtionBar:deltaY animated:YES];
    //    [self moveToolbar:-deltaY animated:YES]; // move to revese direction
    [self moveTabBar:-deltaY animated:YES];
}

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollDown:(CGFloat)deltaY
{
    [self moveNavigtionBar:deltaY animated:YES];
    //    [self moveToolbar:-deltaY animated:YES];
    [self moveTabBar:-deltaY animated:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp:(NJKScrollFullScreen *)proxy
{
    [self hideNavigationBar:YES];
    //    [self hideToolbar:YES];
    [self hideTabBar:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown:(NJKScrollFullScreen *)proxy
{
    [self showNavigationBar:YES];
    //    [self showToolbar:YES];
    [self showTabBar:YES];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_scrollProxy reset];
    [self showNavigationBar:YES];
    //    [self showToolbar:YES];
    [self showTabBar:YES];
}

@end
