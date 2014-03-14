//
//  Hp_C_ViewController.m
//  All_Parts
//
//  Created by RuanSTao on 14-2-18.
//  Copyright (c) 2014年 RuanSTao. All rights reserved.
//

#import "HpCViewController.h"
#import "C_N_ViewController.h"
#import "ThingsViewController.h"
#import "Hp_C_View.h"
#import "HpModel.h"
#import "Reachability.h"
#import "DataBaseSimple.h"
#import "AppDelegate.h"
#import "ActionView.h"
#import "ActionViewContent.h"
#import "AppDelegate.h"
#import <libDoubanApiEngine/DOUService.h>
#import <libDoubanApiEngine/DOUQuery.h>
#import <libDoubanApiEngine/DOUOAuthStore.h>
#import <libDoubanApiEngine/DOUHttpRequest.h>
#import "ASIProgressDelegate.h"
#import "WebViewController.h"
#define POSTONE @"Post  http://bea.wufazhuce.com:7001/OneForWeb/one/o_m"

@interface HpCViewController ()<ActionViewContentDelegate,ASIProgressDelegate,ASIHTTPRequestDelegate>
{
    EGORefreshTableHeaderView* _pullRightRefreshView;
    BOOL _reloading;
    ASIHTTPRequest * _request;
    ASIFormDataRequest * _fromDataRequest;
    DataBaseSimple * _simple;
//    MBProgressHUD * _hud;
    NSMutableArray * _imageViews;
    NSInteger _curPage;
    NSInteger _oldPage;
    BOOL _pageChanging;
}
@property (nonatomic, retain)NSArray         *shareImageList;
@property (nonatomic, retain)NSArray         *shareImageValue;
@property (nonatomic, retain)NSArray         *shareImageActionTypes;
@property (nonatomic, retain)ActionView      *shareView;
@end

@implementation HpCViewController

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
    int pagewide = [UIScreen mainScreen].bounds.size.width;
    int height =[UIScreen mainScreen].bounds.size.height;
    [_scrollView setScrollEnabled:YES];
    _scrollView.contentSize = CGSizeMake(pagewide*3,height);
    _scrollView.tag=188;
    _imageViews=[[NSMutableArray alloc] init];
    _curPage=0;
    [self addView:_curPage];
    
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setPagingEnabled:NO];
    _scrollView.alwaysBounceHorizontal=YES;
    _scrollView.delegate = self;
//    [self.view addSubview:_scrollView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.focusManager = [[ASMediaFocusManager alloc] init];
    AppDelegate * dele=(AppDelegate *)[UIApplication sharedApplication].delegate;
    self.focusManager.delegate = dele.root;
    // Do any additional setup after loading the view from its nib.
//    self.view.backgroundColor=[UIColor orangeColor];
    // Do any additional setup after loading the view from its nib.
    [self creatScrollView];
    if (_pullRightRefreshView == nil) {
		EGORefreshTableHeaderView * view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f-[UIScreen mainScreen].bounds.size.width, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        view.delegate = self;
        [self.scrollView addSubview:view];
        _pullRightRefreshView=view;
		
	}
    _reloading = NO;
    self.navigationItem.titleView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shareBtn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButton)];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        Reachability * reach=[Reachability reachabilityForLocalWiFi];
//        if ([reach isReachable]) {
//            [self postOne];
//        }else{
//            _simple=[DataBaseSimple sharedDataBase];
//            [self resolve:[[[_simple getOnePost] JSONValue] objectForKey:@"entRet"]];
//        }
//    });
//    _hud = [[MBProgressHUD alloc] initWithView:self.view];
//    _hud.delegate =self;
//    _hud.labelText = @"努力的加载中...";
//    _hud.center =CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
//    [self.view addSubview:_hud];
//    [self startAnimation];
    //  注册通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishRemoveView) name:@"REMOVE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveButton) name:@"SAVE" object:nil];
    

//    NSLog(@"%@",((Hp_C_View*)_scrollView.subviews[1]).strOriginalImg);

}
-(void)viewWillDisappear:(BOOL)animated
{
    [_request cancel];
}

- (void)viewDidUnload
{
    _pullRightRefreshView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void)dealloc
{
    _pullRightRefreshView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - EGORefreshTableHeaderDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
//    [self postOne];
    [self reloadView];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
    
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
	return [NSDate date]; // should return date data source was last changed
}
#pragma mark - ScrollView Method
-(void) addView:(NSInteger) index
{
    Hp_C_View * v=[[[NSBundle mainBundle]loadNibNamed:@"Hp_C_View" owner:Nil options:Nil] lastObject];
    v.frame=CGRectMake(320*index, 0,[UIScreen mainScreen].bounds.size.width,     [UIScreen mainScreen].bounds.size.height);
    v.tag=100+index;
    v.row=1+_curPage;
    [_imageViews removeAllObjects];
    [_imageViews addObject:v.strOriginalImg];
    [self.focusManager installOnViews:_imageViews];
    [v setData];
    [_scrollView addSubview:v];
    _pageChanging=NO;
}
- (NSInteger)beyondBounds:(NSInteger)index
{
    NSInteger i;
    if (index==0) {
        i=0;
    }
    else if(index==10){
        i=2;
    }
    else{
        i=1;
    }
    return i;
}
-(void) reloadView
{
//    NSLog(@"%d",_curPage);
    if (_pageChanging) {
        NSInteger i=[self beyondBounds:_oldPage];
        Hp_C_View * v= (Hp_C_View *)[self.view viewWithTag:100+i];
        [v removeFromSuperview];
        i=[self beyondBounds:_curPage];
        [self addView:i];
    }
    if ((_curPage!=0)&&(_curPage!=10)) {
        [_scrollView  scrollRectToVisible:CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:NO];
    }
    
    [_scrollView reloadInputViews];

}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_pullRightRefreshView egoRefreshScrollViewDidScroll:scrollView];
//    NSLog(@"%f",scrollView.contentOffset.x);
    if (_scrollView.contentOffset.x>0) {
        [_scrollView setPagingEnabled:YES];
    }else{
        [_scrollView setPagingEnabled:NO];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_pullRightRefreshView egoRefreshScrollViewDidEndDragging:scrollView];
    
    //	[self reloadView];
}
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag==188) {
        _oldPage=_curPage;
        if ((scrollView.contentOffset.x > 480)&&(_curPage<10)) {
            _curPage++;
            _pageChanging=YES;
        }else if((scrollView.contentOffset.x < 160)&&(_curPage>0)){
            _curPage--;
            _pageChanging=YES;
        }else if ((_curPage==0)&&(scrollView.contentOffset.x>=320)){
            _curPage++;
            _pageChanging=YES;
        }else if((_curPage==10)&&(scrollView.contentOffset.x<=320)){
            _curPage--;
            _pageChanging=YES;
        }
        [self reloadView];
    }

}
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
    
	_reloading = YES;
    
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_pullRightRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
	
}
#pragma mark - ASI Method

-(void) postOne
{
//    _reloading=YES;
    _fromDataRequest=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://bea.wufazhuce.com:7001/OneForWeb/one/o_m"]];
    _fromDataRequest.delegate=self;
//    [_fromDataRequest startAsynchronous];
}
//-(void) reloadAllView
//{
////    NSLog(@"%d---%@",_scrollView.subviews.count,_scrollView.subviews[10] );
//    for (int i = 0; i<10; i++) {
//        Hp_C_View * v= (Hp_C_View *)[self.view viewWithTag:100+i];
//        v.row=i+1;
////        v.strHpId=_lstHp[i];
//        [v setData];
//    }
//}
-(void) rightBarButton
{
    [self showShareView:self isFollow:NO];
//    BOOL flag=self.navigationController.toolbarHidden;
//    self.navigationController.toolbarHidden=!flag;
}
-(void) moveUpView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.navigationController.navigationBar.frame=CGRectMake(0, -24, 320, 44);
        self.scrollView.frame=CGRectMake(0, -44, self.scrollView.frame.size.width,self.scrollView.frame.size.height);
        self.navigationItem.titleView.alpha=0;
    } completion:^(BOOL finished) {
        [self.tabBarController.tabBar setHidden:YES];
    }];
}
-(void) moveDownView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.navigationController.navigationBar.frame=CGRectMake(0, 20, 320, 44);
        self.scrollView.frame=CGRectMake(0, 0, self.scrollView.frame.size.width,self.scrollView.frame.size.height);
        self.navigationItem.titleView.alpha=1;
    } completion:^(BOOL finished) {
        [self.tabBarController.tabBar setHidden:NO];
    }];
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
        
        int currentpage = [self beyondBounds:_curPage];

        Hp_C_View * v=(Hp_C_View*)[self.view viewWithTag:100+currentpage];
        _simple=[DataBaseSimple sharedDataBase];
        HpModel * mod =[_simple getFromDataBaseFromTableName:@"all_homepage" withMarketTime:v.selfTime];
        NSString * shareStr=[NSString stringWithFormat:@"%@ 【%@】 %@",mod.content,mod.author,mod.sWebLk];
//                             v.strContent.text,v.strAuthor.text,v.sWebLK];
        [WBHttpRequest requestWithAccessToken:[userInfo objectForKey:@"access_token"]
                                          url:@"https://upload.api.weibo.com/2/statuses/upload.json"
                                   httpMethod:@"POST"
                                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:shareStr,@"status",v.strOriginalImg.image, @"pic",nil]
                                     delegate:(AppDelegate *)[UIApplication sharedApplication].delegate
                                      withTag:@"200"];
    }
}
- (void)removeSinaWeiboUserInfo
{
    NSDictionary * userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"SinaWeiBoUserInfo"];
    [WeiboSDK logOutWithToken:[userInfo objectForKey:@"access_token"] delegate:self withTag:@"210"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiBoUserInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - DouBan
-(void) douban
{
    int currentpage = [self beyondBounds:_curPage];
    Hp_C_View * v=(Hp_C_View*)[self.view viewWithTag:100+currentpage];
    DOUOAuthStore *store = [DOUOAuthStore sharedInstance];
    DOUService * service = [DOUService sharedInstance];
    if (store.userId != 0 && store.refreshToken && ![store shouldRefreshToken]) {
        DOUQuery * query =[[DOUQuery alloc] initWithSubPath:@"/shuo/v2/statuses/" parameters:nil];
        DOUReqBlock completionBlock=^(DOUHttpRequest * req){
//            NSLog(@"code:%d, str:%@", [req responseStatusCode], [req responseString]);
            NSError *theError = [req doubanError];
            if (!theError) {
                NSLog(@"发送成功");
            }
            else {
                NSLog(@"%@", theError);
            }
        };
        NSData *data=UIImagePNGRepresentation(v.strOriginalImg.image);
        //                NSData * data = UIImagePNGRepresentation([UIImage imageNamed:@"followUsBtn.png"]);
        NSString * description =@"text=TestText";
        [service post2: query photoData:data description:description callback:completionBlock uploadProgressDelegate:self];
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
        [self.shareView.FollowButton setTitle:@"保存图片" forState:UIControlStateNormal];
        self.shareView.FollowButtonNormal=@"保存图片";
        self.shareView.FollowButtonSelect=@"已保存图片";
        [self.shareView showInView:uiViewController.view];
    }
    
}

#pragma mark -  ActionViewContentDelegate
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
//    self.navigationController.navigationBar.frame=CGRectMake(0, 0, 320, 64);
    [self moveDownView];

}
-(void) saveButton
{
//    _simple=[DataBaseSimple sharedDataBase];
    int currentpage=[self beyondBounds:_curPage];
    Hp_C_View * v=(Hp_C_View*)[self.view viewWithTag:100+currentpage];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImageWriteToSavedPhotosAlbum(v.strOriginalImg.image, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    }
    

}
- (void) image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
//    UIAlertView * alert;
//    if (error==nil) {
//        alert=[[UIAlertView alloc] initWithTitle:@"All_Parts" message:@"保存图片成功" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"知道了", nil];
//    }
//    else{
//        alert=[[UIAlertView alloc] initWithTitle:@"All_Parts" message:@"保存图片失败" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"知道了", nil];
//    }
//    [alert show];
}

//#pragma mark - WBHttpRequestDelegate
//- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
//{
//    NSLog(@"%@",request);
//    NSHTTPURLResponse * resp=(NSHTTPURLResponse*) response;
//        NSLog(@"%@",resp);
//    UIAlertView * alert;
//    if ([request.tag isEqual:@"200"]) {
//        if (resp.statusCode==200) {
//            alert=[[UIAlertView alloc] initWithTitle:@"All_Parts" message:@"微博分享成功" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"知道了", nil];
//        }
//        else{
//            alert=[[UIAlertView alloc] initWithTitle:@"All_Parts" message:@"微博分享失败" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"知道了", nil];
//        }
//    }else if ([request.tag isEqualToString:@"210"]){
//        if (resp.statusCode==200) {
//            alert=[[UIAlertView alloc] initWithTitle:@"All_Parts" message:@"微博登出成功" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"知道了", nil];
//        }
//        else{
//            alert=[[UIAlertView alloc] initWithTitle:@"All_Parts" message:@"微博登出失败" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"知道了", nil];
//        }
//    }
//    [alert show];
//}
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

//- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
//{
//    NSLog(@"%@",error);
//}

/**
 收到一个来自微博Http请求的网络返回
 
 @param result 请求返回结果
 */
//3
//- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
//    NSLog(@"%@",result);
//}
/*
{"created_at":"Wed Feb 26 17:08:42 +0800 2014","id":3682272845225874,"mid":"3682272845225874","idstr":"3682272845225874","text":"人生的一大挑战是，在一个丧失自我的世界中保持自我。 by 佚名 大合照 绘图/金山 http://t.cn/8F8nwun","source":"<a href=\"http://open.weibo.com\" rel=\"nofollow\">未通过审核应用</a>","favorited":false,"truncated":false,"in_reply_to_status_id":"","in_reply_to_user_id":"","in_reply_to_screen_name":"","pic_urls":[{"thumbnail_pic":"http://ww1.sinaimg.cn/thumbnail/9507ca0djw1edwwb08s8oj211s0scwl6.jpg"}],"thumbnail_pic":"http://ww1.sinaimg.cn/thumbnail/9507ca0djw1edwwb08s8oj211s0scwl6.jpg","bmiddle_pic":"http://ww1.sinaimg.cn/bmiddle/9507ca0djw1edwwb08s8oj211s0scwl6.jpg","original_pic":"http://ww1.sinaimg.cn/large/9507ca0djw1edwwb08s8oj211s0scwl6.jpg","geo":null,"user":{"id":2500315661,"idstr":"2500315661","class":1,"screen_name":"Tao_Ruan","name":"Tao_Ruan","province":"44","city":"3","location":"广东 深圳","description":"","url":"","profile_image_url":"http://tp2.sinaimg.cn/2500315661/50/0/1","profile_url":"u/2500315661","domain":"","weihao":"","gender":"m","followers_count":3,"friends_count":51,"statuses_count":0,"favourites_count":0,"created_at":"Mon Feb 24 09:50:30 +0800 2014","following":false,"allow_all_act_msg":false,"geo_enabled":true,"verified":false,"verified_type":-1,"remark":"","ptype":0,"allow_all_comment":true,"avatar_large":"http://tp2.sinaimg.cn/2500315661/180/0/1","avatar_hd":"http://tp2.sinaimg.cn/2500315661/180/0/1","verified_reason":"","follow_me":false,"online_status":0,"bi_followers_count":0,"lang":"zh-cn","star":0,"mbtype":0,"mbrank":0,"block_word":0},"reposts_count":0,"comments_count":0,"attitudes_count":0,"mlevel":0,"visible":{"type":0,"list_id":0}}
*/
/**
 收到一个来自微博Http请求的网络返回
 
 @param data 请求返回结果
 */
//2
//- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
//{
//    NSLog(@"%@",data);
//}
#pragma mark - ASIHTTPRequestDelegate
//-(void) requestFinished:(ASIHTTPRequest *)request
//{
////    _reloading=NO;
//    [self doneLoadingTableViewData];
//    NSDictionary * dic=[[request responseString] JSONValue];
////    NSLog(@"%@",dic);
//    if ([[dic objectForKey:@"result"] isEqualToString:@"SUCCESS"]) {
//        _simple=[DataBaseSimple sharedDataBase];
//        [_simple insertOnePost:[request responseString]];
//        [self resolve:[dic objectForKey:@"entRet"]];
//    }else{
//        NSLog(@"%@ ASI error",[self class]);
//    }
////    [self stopAnimation];
//}
//-(void) requestFailed:(ASIHTTPRequest *)request
//{
////    _reloading=NO;
//    _simple=[DataBaseSimple sharedDataBase];
//
//    if ([[_simple getOnePost] JSONValue]) {
//         [self resolve:[[[_simple getOnePost] JSONValue] objectForKey:@"entRet"]];
//    }
//    [self doneLoadingTableViewData];
//      NSLog(@"%@ ASI error---%@",[self class],request.error);
////    [self stopAnimation];
//}
#pragma mark - My Method
//-(void) resolve:(NSDictionary * ) dic
//{
//
//    NSMutableArray * hp=[NSMutableArray array];
//    for (NSDictionary * obj in [dic objectForKey:@"lstHp"]){
//        StrContentId * s=[[StrContentId alloc] init];
//        s.contentId=[obj objectForKey:@"strContentId"];
//        s.praiseNumber=[obj objectForKey:@"strPraiseNumber"];
//        [hp addObject:s];
//    }
//
//    NSMutableArray * con=[NSMutableArray array];
//    for (NSDictionary * obj in [dic objectForKey:@"lstCon"]){
//        StrContentId * s=[[StrContentId alloc] init];
//        s.contentId=[obj objectForKey:@"strContentId"];
//        s.praiseNumber=[obj objectForKey:@"strPraiseNumber"];
//        [con addObject:s];
//    }
//    NSMutableArray * thi=[NSMutableArray array];
//    for (NSDictionary * obj in [dic objectForKey:@"lstThing"]){
//        StrContentId * s=[[StrContentId alloc] init];
//        s.contentId=[obj objectForKey:@"strContentId"];
//        s.praiseNumber=[obj objectForKey:@"strPraiseNumber"];
//        [thi addObject:s];
//    }
//
//    self.lstHp=hp;
//    NSArray * arr= self.tabBarController.viewControllers;
//    C_N_ViewController * c =[[[arr objectAtIndex:1] viewControllers] lastObject];
//    c.lisCon=con;
//    ThingsViewController *t=[[[arr objectAtIndex:3] viewControllers] lastObject];
//    t.lstThing=thi;
//    [self reloadAllView];

//}


@end
