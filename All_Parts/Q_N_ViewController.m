//
//  Q_N_ViewController.m
//  All_Parts
//
//  Created by RuanSTao on 14-2-18.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//

#import "Q_N_ViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "NJKScrollFullScreen.h"
#import "DataBaseSimple.h"
#import "UIViewController+NJKFullScreenSupport.h"
#import "QN_View.h"
#import "QNModel.h"
#import "ActionView.h"
#import "ActionViewContent.h"
#import "AppDelegate.h"
#import <libDoubanApiEngine/DOUService.h>
#import <libDoubanApiEngine/DOUQuery.h>
#import <libDoubanApiEngine/DOUOAuthStore.h>
#import <libDoubanApiEngine/DOUHttpRequest.h>
#import "WebViewController.h"
@interface Q_N_ViewController ()<EGORefreshTableHeaderDelegate,NJKScrollFullscreenDelegate,UIScrollViewDelegate,ActionViewContentDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *refreshScrollView;
@property (nonatomic) NJKScrollFullScreen *scrollProxy;
@property (nonatomic, retain)NSArray         *shareImageList;
@property (nonatomic, retain)NSArray         *shareImageValue;
@property (nonatomic, retain)NSArray         *shareImageActionTypes;
@property (nonatomic, retain)ActionView      *shareView;
@end

@implementation Q_N_ViewController
{
    EGORefreshTableHeaderView* _pullRightRefreshView;
    BOOL _reloading;
    DataBaseSimple * _simple;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)creatScrollView
{
    int pagewide = self.refreshScrollView.bounds.size.width;
    int height = self.refreshScrollView.bounds.size.height;
    [_refreshScrollView setScrollEnabled:YES];
    _refreshScrollView.contentSize = CGSizeMake(pagewide*10,height);
    for (int i=0;i<10; i++) {
        QN_View * v  =[[[NSBundle mainBundle] loadNibNamed:@"QN_View" owner:Nil options:nil] lastObject];
        v.frame=CGRectMake(320*i, 0, _refreshScrollView.bounds.size.width, _refreshScrollView.bounds.size.height);
        v.tag=100+i;
        v.row=i+1;
        v.scrollView.delegate = (id)_scrollProxy;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [v setData];
//        });
        [_refreshScrollView addSubview:v];
        
    }
    
    [_refreshScrollView setShowsVerticalScrollIndicator:NO];
    [_refreshScrollView setShowsHorizontalScrollIndicator:NO];
    [_refreshScrollView setPagingEnabled:NO];
    _refreshScrollView.alwaysBounceHorizontal=YES;
    _refreshScrollView.delegate = self;
    //    [self.view addSubview:_scrollView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    _scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self];
    [self creatScrollView];
    _scrollProxy.delegate = self;
    if (_pullRightRefreshView == nil) {
		EGORefreshTableHeaderView * view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f-self.refreshScrollView.bounds.size.width, 0.0f, self.refreshScrollView.frame.size.width, self.refreshScrollView.bounds.size.height)];
        view.delegate = self;
        [self.refreshScrollView addSubview:view];
        _pullRightRefreshView=view;
		
	}
    _reloading = NO;
    self.navigationItem.titleView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shareBtn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButton)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishRemoveView) name:@"REMOVE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveButton) name:@"SAVE" object:nil];
//
    
}

- (void)dealloc
{
    _pullRightRefreshView = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - EGORefreshTableHeaderDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    [self reloadAllView];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
    
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
	return [NSDate date]; // should return date data source was last changed
	
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_pullRightRefreshView egoRefreshScrollViewDidScroll:scrollView];
    //    NSLog(@"%f",scrollView.contentOffset.x);
    if (_refreshScrollView.contentOffset.x>0) {
        [_refreshScrollView setPagingEnabled:YES];
    }else{
        [_refreshScrollView setPagingEnabled:NO];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_pullRightRefreshView egoRefreshScrollViewDidEndDragging:scrollView];
	
}
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
    
	_reloading = YES;
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_pullRightRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.refreshScrollView];
	
}

#pragma mark -
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
#pragma mark - My Method
-(void) reloadAllView
{
    //    NSLog(@"%d---%@",_scrollView.subviews.count,_scrollView.subviews[10] );
    for (int i = 0; i<10; i++) {
        QN_View * v= (QN_View *)[self.view viewWithTag:100+i];
        [v setData];
    }
}
-(void) rightBarButton
{
        [self showShareView:self isFollow:NO];
}
-(void) moveUpView
{
    [self scrollFullScreen:nil scrollViewDidScrollUp:-44];
    [UIView animateWithDuration:0.2 animations:^{
        //        self.navigationController.navigationBar.frame=CGRectMake(0, -44, 320, 44);
        self.refreshScrollView.frame=CGRectMake(0, -44, 320, self.refreshScrollView.frame.size.height);
    } completion:^(BOOL finished) {
        //        [self.tabBarController.tabBar setHidden:YES];
    }];
}
-(void) moveDownView
{
    [self scrollFullScreen:nil scrollViewDidScrollDown:44];
    [UIView animateWithDuration:0.2 animations:^{
        //        self.navigationController.navigationBar.frame=CGRectMake(0, 20, 320, 44);
        self.refreshScrollView.frame=CGRectMake(0,0, 320, self.refreshScrollView.frame.size.height);
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
        [self.shareView.FollowButton setTitle:@"收藏" forState:UIControlStateNormal];
        self.shareView.FollowButtonNormal=@"已收藏";
        self.shareView.FollowButtonSelect=@"已收藏";
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
    int currentpage=(_refreshScrollView.contentOffset.x+160)/320;
    QN_View * v=(QN_View*)[self.view viewWithTag:100+currentpage];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    [dic setObject: v.questionTitle.text forKey:@"title"];
    [dic setObject: [_simple getDateForYestoday:(double)currentpage] forKey:@"markettime"];
    [dic setObject: v.qnId forKey:@"id"];
    [dic setObject:@"all_question" forKey:@"tablename"];
    [_simple insertDataForTableName:@"all_things" with:dic];

    
    
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
        int currentpage=(_refreshScrollView.contentOffset.x+160)/320;
        QN_View * v=(QN_View*)[self.view viewWithTag:100+currentpage];
        _simple=[DataBaseSimple sharedDataBase];
        QNModel * mod =[_simple getFromDataBaseFromTableName:@"all_question" withMarketTime:v.selfTime];
        NSString * shareStr=[NSString stringWithFormat:@"%@ - 阅读全文：%@",mod.questiontitle,mod.sweblk];
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
    int currentpage=(_refreshScrollView.contentOffset.x+160)/320;
    QN_View * v=(QN_View*)[self.view viewWithTag:100+currentpage];
    _simple=[DataBaseSimple sharedDataBase];
    QNModel * mod =[_simple getFromDataBaseFromTableName:@"all_question" withMarketTime:v.selfTime];
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
        
        NSString * shareStr=[NSString stringWithFormat:@"text= %@ - 阅读全文：%@",mod.questiontitle,mod.sweblk];
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

@end
